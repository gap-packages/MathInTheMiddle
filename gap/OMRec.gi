InstallGlobalFunction(MitM_ATPToRec,
function(atps)
    local i, res;

    res := rec();

    for i in [1,3..Length(atps)-1] do
        res.( atps[i].attributes.name ) := MitM_OMRecToGAPNC(atps[i+1]).result;
    od;
    return res;
end);

InstallGlobalFunction(MitM_RecToATP,
function(r)
    return rec( name := "ATP"
              , content := Concatenation(
                           List( NamesOfComponents(r)
                               , n -> [ rec( attributes := rec( cd := "scscp1"
                                                              , name := n )
                                           , name := "OMS" )
                                      , MitM_GAPToOMRec(r.(n)) ] ) ) );
end);

InstallGlobalFunction(OMA,
function(oms, args...)
    return rec( name := "OMA"
              , content := args );
end);

InstallGlobalFunction(OMS,
function(args...)
    local res;

    res :=  rec( name := "OMS"
               , attributes := rec( ) );

    if Length(args) = 2 then
        res.attributes.cd := args[1];
        res.attributes.name := args[2];
    elif Length(args) = 3 then
        res.attributes.cdbase := args[1];
        res.attributes.cd := args[2];
        res.attributes.name := args[3];
    else
        return fail;
    fi;
    return res;
end);

InstallGlobalFunction(MitM_SimpleOMS,
obj_name -> OMS(MitM_cdbase, "lib", obj_name));

InstallGlobalFunction(OMATTR,
function(attr, content)
    return rec( name := "OMATTR"
              , content := [ MitM_RecToATP(attr)
                           , content ] );
end);

InstallGlobalFunction(OMSTR,
function(string)
    return rec( name := "OMSTR"
              , content := [ string ] );
end);

InstallGlobalFunction(OME,
function(oms, content)
    return rec( name := "OME"
              , content := Concatenation( [oms], content ) );
end);