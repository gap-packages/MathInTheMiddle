MitM_QueueLength := 5;

# # symbol
# OMS = element OMS { common.attributes,
#                     attribute name { xsd:NCName},
#                     attribute cd { xsd:NCName},
#                     cdbase }
#
# # variable
# OMV = element OMV { common.attributes,
#                     attribute name { xsd:NCName} }
#
# # integer
# OMI = element OMI { common.attributes,
#                     xsd:string {pattern = "\s*(-\s?)?[0-9]+(\s[0-9]+)*\s*"}}
# # byte array
# OMB = element OMB { common.attributes, xsd:base64Binary }
#
# # string
# OMSTR = element OMSTR { common.attributes, text }
#
# # IEEE floating point number
# OMF = element OMF { common.attributes,
#                     ( attribute dec { xsd:double } |
#                       attribute hex { xsd:string {pattern = "[0-9A-F]+"}}) }
#
# # apply constructor
# OMA = element OMA { compound.attributes, omel+ }
#
# # binding constructor
# OMBIND = element OMBIND { compound.attributes, omel, OMBVAR, omel }
#
# # variables used in binding constructor
# OMBVAR = element OMBVAR { common.attributes, omvar+ }
#

# # attribution constructor and attribute pair constructor
# OMATTR = element OMATTR { compound.attributes, OMATP, omel }
#
# OMATP = element OMATP { compound.attributes, (OMS, (omel | OMFOREIGN) )+ }
#
# # foreign constructor
# OMFOREIGN =  element OMFOREIGN {
#     compound.attributes, attribute encoding {xsd:string}?,
#    (omel|notom)* }


#! Interpreter for MitM OpenMath
MitM_OMInterpreter :=
    rec(
       # # symbol
       # OMS = element OMS { common.attributes,
       #                     attribute name { xsd:NCName},
       #                     attribute cd { xsd:NCName},
       #                     cdbase }
         OMS := function(state, obj)
            local cdbase, cd, name;

            if not IsBound(obj[2]) then
                ErrorNoReturn("OMS: expected content");
                return;
            fi;
            if not IsBound(obj[2].name) then
                ErrorNoReturn("OMS: no name given");
                return;
            fi;
            if not IsBound(obj[2].cd) then
                ErrorNoReturn("OMS: no cd given");
                return;
            fi;

            name := obj[2].name;
            cd := obj[2].cd;
            if IsBound(obj[2].cdbase) then
                cdbase := obj[4].cdbase;
            fi;

            return state.LookupSymbol(cdbase, cd, name);
       end

       # Variable
       , OMV := function(state, obj)
           # TODO: How to handle variables? Is this in the context
           #       of a session?
           if not IsBound(obj[2].name) then
               ErrorNoReturn("OMV: no name given");
               return;
           fi;
           return state.LookupVariable(name);
       end

       # Integer
       # OMI = element OMI { common.attributes,
       #                     xsd:string {pattern = "\s*(-\s?)?[0-9]+(\s[0-9]+)*\s*"}}
       , OMI := function(state, obj)
           return Int(obj[2]);
       end

       # Byte array
       , OMB := function(state, obj)
           return String(obj[2]);
       end

       , OMSTR := function(state, obj)
           return obj[2];
       end

       # # IEEE floating point number
       # OMF = element OMF { common.attributes,
       #                     ( attribute dec { xsd:double } |
       #                       attribute hex { xsd:string {pattern = "[0-9A-F]+"}}) }
       # TODO: This only supports decimal
       , OMF := function(state, obj)
           if not IsBound(obj[2].dec) then
               ErrorNoReturn("OMF: Only decimal encoding is supported");
           fi;
           return Float(obj[2].dec);
       end

       # # apply constructor
       # OMA = element OMA { compound.attributes, omel+ }
       , OMA := function(state, obj)
           local cons, parm;

           # Check this is a symbol?
           cons := MitM_InterpretJsonML(state, obj[2]);
           # Check types of this?
           parm := List(obj{ [3..Length(obj)]}, x -> MitM_InterpretJsonML(state, x) );

           return CallFuncList(cons, parm);
       end

       # # binding constructor
       # OMBIND = element OMBIND { compound.attributes, omel, OMBVAR, omel }
       #
       # Lets just support lambda binding right now?
       , OMBIND := function(state, obj)
           local binder, vars, expr;

           binder := obj[2];

           if binder <> "lambda" then
               ErrorNoReturn("OMBIND: only lambda binder is supported");
           fi;

           # TODO: We should be able to interpret
           #       *just* a OMBVAR here
           vars := MitM_InterpretJsonML(state, obj[3]);
           expr := MitM_InterpretJsonML(state, obj[4]);

           # Really we need the Syntax-Tree stuff here!
           return rec( type := "OMBIND"
                     , a := a
                     , vars := vars
                     , b := b );
       end

       # # variables used in binding constructor
       # OMBVAR = element OMBVAR { common.attributes, omvar+ }
       , OMBVAR := function(state, obj)
           local vars;
       end

       # # error constructor
       # OME = element OME { common.attributes, OMS, (omel|OMFOREIGN)* }
       , OME := function(state, obj)
           local err;

           # Interpreting errors
           err := MitM_InterpretJsonML(state, obj[2]);
           Error("Error: ", err);
       end

       , OMATTR := function(state, obj)
       end

       );

InstallGlobalFunction(MitM_InterpretJsonML,
function(state, json)
    local x;

    x := json[1];

    if not IsString(x) then
        Error("expected: string");
        return fail;
    fi;
    if not IsBound(MitM_OMInterpreter.(x)) then
        Error("unsupported element", x);
        return fail;
    fi;

    # TODO: OMOBJ should set cdbase/cd?
    #       For that we might have to change the interpreter?
    return MitM_OMInterpreter.(x)(state, json);
end);

InstallGlobalFunction(MitM_JsonHandler,
function(addr, stream)
    local res;

    # Protocol handshake
    GapToJsonStream(stream, rec( service_name := "GAP"
                               , service_version := GAPInfo.Version
                               , service_id := ""
                               , versions := [ "1.0", "1.1", "1.2", "1.3" ] ) );
    # Flush...
    WriteLine(stream, "");
    res := JsonStreamToGap(stream);
    if not (IsBound(res.version) and
            res.version in [ "1.0", "1.1", "1.2", "1.3" ]) then
        ErrorNoReturn("Protocol error: version needs to be bound");
    fi;

    # Handle until done
    while not IsClosedStream(stream) do
        PrintTo("*errout*", "jsonhandler 1");
        res := JsonStreamToGap(stream);
        Info(InfoMitMJsonHandler, 5, "received: ", res);

        # TODO: This should be flexible, depending on which
        #       encoding we use
        #       In particular we might want to re-add XML
        MitM_InterpretJsonML(res);
    od;
    return true;
end);

InstallGlobalFunction(MitM_MakeBindAddr,
function(addr)
    local res;

    res := IO_gethostbyname(addr);
    return res;
end);

MitM_AddrToString := function(addr)
    return JoinStringsWithSeparator(List(addr{[5..8]}, x -> String(INT_CHAR(x))), ".");
end;

# TODO: IPv4 only (bleh)
InstallGlobalFunction(MitM_StartServer_TCP,
function(addr, port, handlerCallback)
    local socket, client, desc, stream, res, bindaddr, listenname;

    res := IO_gethostbyname(addr);
    if res = fail then
        ErrorNoReturn("Failed to lookup address: ", LastSystemError());
        return fail;
    fi;
    bindaddr := res.addr[1];
    listenname := res.name;

    if not IsPosInt(port) or (port > 65536) then
        ErrorNoReturn("Usage: port has to be a positive integer");
        return fail;
    fi;

    # Create TCP socket
    Info(InfoMitMTCPHandler, 5, "MitM server listening for connections...");
    socket := IO_socket( IO.PF_INET, IO.SOCK_STREAM, "tcp" );
    if socket = fail then
        ErrorNoReturn("Failed to open socket: ", LastSystemError());
        return fail;
    fi;

    res := IO_bind(socket, IO_make_sockaddr_in(bindaddr, port));
    if res = fail then
        ErrorNoReturn("Failed to bind: ", LastSystemError());
        return fail;
    fi;

    Info(InfoMitMTCPHandler, 5, "MitM server listening on ", listenname, " ", port);
    IO_listen(socket, MitM_QueueLength);
    while true do
        # Currently we accept connections from anyone.
        addr := IO_MakeIPAddressPort( "0.0.0.0", 0 );

        # Accept connection, and open stream.
        client := IO_accept(socket, addr);

        # TODO: prettier
        Info(InfoMitMTCPHandler, 5, "Accepted connection from: ",
             MitM_AddrToString(addr));
        stream := InputOutputTCPStream(client);

        # Handle connection
        handlerCallback(addr, stream);

        CloseStream(stream);
        IO_close(client);
    od;
end);
