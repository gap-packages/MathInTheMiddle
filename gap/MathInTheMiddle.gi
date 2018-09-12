InstallGlobalFunction(MitM_SCSCPHandler,
function(addr, stream)
    local done, version, r, obj;
    done := false;

    Info(InfoMitMServer, 5, "Accepted MitM Connection on ", TCP_AddrToString(addr));
    version := MitM_SCSCPServerHandshake(stream, stream);
    Info(InfoMitMServer, 5, " SCSCP Protocol Version ", version);
    while not done do
        r := MitM_ReadSCSCP(stream);
        WriteLine(stream, "<?scscp start ?>");
        if r.success <> true then
            Info(InfoMitMServer, 15, " Bad object received\n");
            Info(InfoMitMServer, 15, "  error: ", r.error);
            WriteLine(stream, Concatenation("error: ", r.error));
        else
            obj := r.result;
            Info(InfoMitMServer, 15, " Evaluated to ", obj);
            WriteLine(stream, MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec(obj))));
        fi;
        WriteLine(stream, "<?scscp end ?>");
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
