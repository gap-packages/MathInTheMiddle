#
#
#
InstallGlobalFunction(MITM_InstallMitMCDHandlers,
function()
    if not IsBound( OMsymRecord.mitm_1 ) then
        OMsymRecord.mitm_1 := rec();
    fi;
end);

InstallGlobalFunction(MITM_EvalMitM,
function(mitm)

end);


# TODO: Optional port/address
InstallGlobalFunction(StartMitMServer,
function(args...)
    if not IsRecord(args[1]) then
        Error("<rec> must be an options record");
    fi;
    InstallSCSCPprocedure( "EvalMitM", MITM_EvalMitM, "Evaluate MitM OpenMath", 1, 1);
    RunSCSCPserver(SCSCPserverAddress, SCSCPserverPort);
end);

