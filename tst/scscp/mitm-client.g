LoadPackage("MathInTheMiddle");

str := StreamToMitMServer("localhost");
CloseStream(str);

str := StreamToMitMServer("localhost", 26133);
oma := OMA(OMS(MitM_cdbase, "lib", "Size"), MitM_GAPToOMRec([]));
call := MitM_ProcedureCall(oma);
out := SendObjToMitMServer(str, call);
if MitM_Content(MitM_Content(MitM_Content(out.result)[1])[2])[2] <> OMI(0) then
    CloseStream(str);
    QUIT_GAP(1);
fi;
CloseStream(str);
