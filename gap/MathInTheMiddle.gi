#
#
#
InstallGlobalFunction(MitM_SCSCPHandler,
function(addr, stream)
    local version, done, obj;

    done := false;

    Info(InfoMitMServer, 5, "Accepted MitM Connection on ", TCP_AddrToString(addr));
    version := MitM_SCSCPServerHandshake(stream);
    Info(InfoMitMServer, 5, " SCSCP Protocol Version ", version);
    while not done do
        obj := MitM_ReadSCSCP(stream);
        Info(InfoMitMServer, 15, " Evaluated to \n ", obj);
        WriteAll(stream, "<?scscp start>");
        WriteAll(stream, MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec(obj))));
        WriteAll(stream, "<?scscp end>");
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
        opt.port := args[1];
    fi;

    Info(InfoMitMServer, 5, "Starting MitM TCP Server on ", opt.hostname, ":", opt.port);
    StartTCPServer(opt.hostname, opt.port, MitM_SCSCPHandler);
end);

