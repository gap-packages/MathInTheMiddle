MitM_CookieCount := 0;
MitM_CookieJar := rec();

InstallGlobalFunction(MitM_CompleteProcedure,
function(result, attr...)
    if Length(attr) = 0 then
        attr := rec();
    elif Length(attr) = 1 then
        attr := attr[1];
    else
        ErrorNoReturn("MitM_CompleteProcedure: takes 1 or 2 arguments (not ",
                      Length(attr) + 1, ")");
    fi;
    return MitM_OMRecToXML(MitM_OMRecToOMOBJRec(
                 OMATTR( attr
                       , OMA( OMS( "scscp1"
                                 , "procedure_completed" )
                            , result ) ) ) );
end);

InstallGlobalFunction(MitM_TerminateProcedure,
function(message, attr...)
    if Length(attr) = 0 then
        attr := rec();
    elif Length(attr) = 1 then
        attr := attr[1];
    else
        ErrorNoReturn("MitM_TerminateProcedure: takes 1 or 2 arguments (not ",
                      Length(attr) + 1, ")");
    fi;
    return MitM_OMRecToXML(MitM_OMRecToOMOBJRec(
                 OMATTR( attr
                       , OMA( OMS( "scscp1"
                                 , "procedure_terminated" )
                            , OME( OMS( "scscp1"
                                      , "error_system_specific" )
                                 , [ OMSTR(message) ] ) ) ) ) );
end);

InstallValue(MitM_SCSCPHandlers, rec(
    procedure_call := function(attr, oma)
        local t, eval, rattr, res;

        Info(InfoMitMServer, 15, " Evaluating... ", oma);
        Info(InfoMitMServer, 15, " Attributes... ", attr);

        t := NanosecondsSinceEpoch();
        eval := MitM_OMRecToGAPFunc(oma);
        t := NanosecondsSinceEpoch() - t;

        if eval.success then
            rattr := rec( call_id := attr.call_id
                        , info_runtime := t / 1000000. );
            if IsBound(attr.option_return_cookie) then
                MitM_CookieJar.(MitM_CookieCount) := eval.result;
                res := MitM_GAPToOMRec(MitM_CookieCount);
                MitM_CookieCount := MitM_CookieCount + 1;
            elif IsBound(attr.option_return_object) then
                res := MitM_GAPToOMRec(eval.result);
            elif IsBound(attr.option_return_nothing) then
                res := rec();
            fi;

            return MitM_CompleteProcedure(res, rattr);
        else
            Info(InfoMitMServer, 15, " Error during evaluation: ", eval.error);
            return MitM_TerminateProcedure(eval.error, rec(call_id := attr.call_id));
        fi;
    end
) );

InstallGlobalFunction(MitM_HandleSCSCP,
function(node)
    local attr, scscp_call, scscp_oma, content;

    content := MitM_Content(node);
    # Validate wrt SCSCP v1.3 spec - procedure call (4.1.1)
    if not (Length(content) = 1 and MitM_Tag(content[1]) = "OMATTR") then
        Info(InfoMitMServer, 15, " Invalid procedure call: OMATTR expected");
        return MitM_TerminateProcedure("procedure call: OMOBJ should contain one OMATTR and nothing else");
    elif MitM_Tag(MitM_Content(content[1])[2]) <> "OMA" then
        Info(InfoMitMServer, 15, " Invalid procedure call: OMA expected");
        return MitM_TerminateProcedure("procedure call: OMOBJ: OMATTR's 2nd object should be an OMA");
    elif not (Length(MitM_Content(MitM_Content(content[1])[2].content)) = 2 and
              MitM_Tag(MitM_Content(MitM_Content(content[1])[2])[1]) = "OMS") then
        Info(InfoMitMServer, 15, " Invalid procedure call: OMS expected");
        return MitM_TerminateProcedure("procedure call: OMOBJ: OMATTR: OMA's 1st object should be an OMS");
    elif MitM_Tag(MitM_Content(MitM_Content(content[1])[2])[2]) <> "OMA" then
        Info(InfoMitMServer, 15, " Invalid procedure call: OMA expected");
        return MitM_TerminateProcedure("procedure call: OMOBJ: OMATTR: OMA's 2nd object should be an OMA");
    fi;

    attr := MitM_ATPToRec(MitM_Content(content[1])[1]);
    scscp_call := MitM_Content(MitM_Content(content[1])[2])[1];
    scscp_oma := MitM_Content(MitM_Content(content[1])[2])[2];

    if MitM_CD(scscp_call) = "scscp1" then
        if MitM_Name(scscp_call) = "procedure_call" then
            return MitM_SCSCPHandlers.procedure_call(attr, scscp_oma);
        elif MitM_Name(scscp_call) = "terminate_procedure" then
            # TODO:
        fi;
    else
        Info(InfoMitMServer, 15, " Unsupported CD ", scscp_call.attributes.cd);
        return fail;
    fi;
end);

InstallGlobalFunction(MitM_SCSCPHandler,
function(addr, stream)
    local done, version, r, reply, obj;
    done := false;

    Info(InfoMitMServer, 5, "Accepted MitM Connection on ", TCP_AddrToString(addr));
    version := MitM_SCSCPServerHandshake(stream, stream);
    Info(InfoMitMServer, 5, " SCSCP Protocol Version ", version);
    while not done do
        r := MitM_ReadSCSCP(stream);
        Info(InfoMitMServer, 15, " Received: ", r);
        if r.success <> true then
            Info(InfoMitMServer, 15, " Bad object received");
            Info(InfoMitMServer, 15, "  error: ", r.error);
            Info(InfoMitMServer, 15, " closing connection.");
            CloseStream(stream);
            done := true;
            # WriteLine(stream, Concatenation("error: ", r.error));
        else
            reply := MitM_HandleSCSCP(r.result);
            Info(InfoMitMServer, 15, " Evaluated to ", reply);
            WriteLine(stream, "<?scscp start ?>");
            WriteLine(stream, reply);
            WriteLine(stream, "<?scscp end ?>");
        fi;
    od;
    Info(InfoMitMServer, 5, "Leaving handler for ", TCP_AddrToString(addr));
end);

InstallGlobalFunction(StartMitMServer,
function(args...)
    local opt;

    opt := ShallowCopy(MitM_DefaultServerOptions);
    if IsBound(args[1]) and IsString(args[1]) then
        opt.hostname := args[1];
    fi;
    if IsBound(args[2]) and IsPosInt(args[2]) then
        opt.port := args[2];
    fi;

    Info(InfoMitMServer, 5, "Starting MitM TCP Server on ", opt.hostname, ":", opt.port);
    StartTCPServer(opt.hostname, opt.port, MitM_SCSCPHandler);
end);

InstallGlobalFunction(StreamToMitMServer,
function(hostname, port...)
    local stream;
    if Length(port) = 0 then
        port := 26133; # SCSCP default
    elif Length(port) = 1 then
        port := port[1];
    else
        Error("MitM_ConnectionToServer: 1 or 2 arguments expected, but ",
              Length(port) + 1, " found");
    fi;
    stream := ConnectInputOutputTCPStream(hostname, port);
    MitM_SCSCPClientHandshake(stream, stream);
    return stream;
end);

InstallGlobalFunction(SendObjToMitMServer,
function(stream, obj)
    local xml;
    xml := MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec(obj)));
    WriteLine(stream, "<?scscp start ?>");
    WriteLine(stream, xml);
    WriteLine(stream, "<?scscp end ?>");
    return MitM_ReadSCSCP(stream);
end);
