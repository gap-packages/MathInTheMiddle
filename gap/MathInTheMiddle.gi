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

######################################################################
##
#F  MitM_SymLookup( [<cdbase>, <cd>, <name>] )
##
BindGlobal("MitM_SymLookup",
function( symbol )
    local cdbase, cd, name;
    cdbase := symbol[1];
    cd := symbol[2];
    name := symbol[3];
    
    
    
    if IsBound( OMsymRecord.(cd) ) then
        if IsBound( OMsymRecord.(cd).(name) ) then
            if not OMsymRecord.(cd).(name) = fail then
                return OMsymRecord.(cd).(name);
            else
                # the symbol is present in the CD but not implemented
	            # The number, format and sequence of arguments for the three error messages
	            # below is strongly fixed as it is needed in the SCSCP package to return
	            # standard OpenMath errors to the client
	            Error("OpenMathError: ", "unhandled_symbol", " cd=", symbol[1], " name=", symbol[2]);
            fi;
        else
            # the symbol is not present in the mentioned content dictionary.
	        Error("OpenMathError: ", "unexpected_symbol", " cd=", symbol[1], " name=", symbol[2]);
        fi;
    else
        # we didn't even find the cd
        Error("OpenMathError: ", "unsupported_CD", " cd=", symbol[1], " name=", symbol[2]);
    fi;
end);

# TODO: Optional port/address
InstallGlobalFunction(StartMitMServer,
function(args...)
    local optrec;

    if not IsRecord(args[1]) then
        Error("<rec> must be an options record");
    fi;
#    InstallSCSCPprocedure( "EvalMitM", MITM_EvalMitM, "Evaluate MitM OpenMath", 1, 1);
#    RunSCSCPserver(optrec.SCSCPserverAddress, optrec.SCSCPserverPort);
end);

