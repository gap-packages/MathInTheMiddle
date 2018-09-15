InstallGlobalFunction(MitM_GAPToXML,
obj -> MitM_OMRecToXML(MitM_GAPToOMRec(obj)));

InstallGlobalFunction(MitM_XMLToGAP,
str -> MitM_OMRecToGAP(MitM_XMLToOMRec(str)));

InstallGlobalFunction(MitM_RoundTripGAP,
obj -> MitM_XMLToGAP(MitM_GAPToXML(obj)));

InstallGlobalFunction(MitM_RoundTripXML,
function(str)
    local r;
    r := MitM_XMLToGAP(str);
    if r.success <> true then
        return r;
    fi;
    return MitM_GAPToXML(r.result);
end);

InstallGlobalFunction(MitM_Print,
function(obj)
    Print(MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec(obj))), "\n");
end);

InstallGlobalFunction(MitM_OMRecToOMOBJRec,
r -> rec(name := "OMOBJ", attributes := rec(version := "2.0"), content := [r]));
