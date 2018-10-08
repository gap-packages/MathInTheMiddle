# Test MMT use-case
gap> xml := """<OMA>
>   <!-- Orbit( -->
>   <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="Orbit" />
>   <!-- DihedralGroup(IsPermGroup, 8), -->
>   <OMA>
>     <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="DihedralGroup" />
>     <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="IsPermGroup" />
>     <OMI>8</OMI>
>   </OMA>
>   <!-- PolynomialByExtRep(RationalFunctionsFamily(FamilyObj(1)), [[2,1],1,[1,1,3,1],3]), -->
>   <OMA>
>     <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="PolynomialByExtRep" />
>     <OMA>
>       <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="RationalFunctionsFamily" />
>       <OMA>
>         <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="FamilyObj" />
>         <OMI>1</OMI>
>       </OMA>
>     </OMA>
>     <OMA>
>       <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>       <OMA>
>         <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>         <OMI>2</OMI>
>         <OMI>1</OMI>
>       </OMA>
>       <OMI>1</OMI>
>       <OMA>
>         <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>         <OMI>1</OMI>
>         <OMI>1</OMI>
>         <OMI>3</OMI>
>         <OMI>1</OMI>
>       </OMA>
>       <OMI>3</OMI>
>     </OMA>
>   </OMA>
>   <!-- OnIndeterminates ); -->
>   <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="OnIndeterminates" />
> </OMA>""";;
gap> p := MitM_XMLToGAP(xml).result;
[ 3*x1*x3+x2, 3*x2*x4+x3, 3*x1*x3+x4, 3*x2*x4+x1 ]
gap> MitM_RoundTripGAP(p).result;
[ 3*x1*x3+x2, 3*x2*x4+x3, 3*x1*x3+x4, 3*x2*x4+x1 ]
gap> MitM_RoundTripGAP(p).result = p;
true

#
gap> MitM_CompleteProcedure(OMSTR(""));
"<OMOBJ version=\"2.0\">\n<OMATTR>\n<OMATP></OMATP>\n<OMA>\n<OMS cd=\"scscp1\"\
 name=\"procedure_completed\" />\n<OMSTR></OMSTR>\n</OMA>\n</OMATTR>\n</OMOBJ>\
"
gap> MitM_CompleteProcedure(OMSTR(""), rec( time := 5 ));
"<OMOBJ version=\"2.0\">\n<OMATTR>\n<OMATP>\n<OMS cd=\"scscp1\" name=\"time\" \
/>\n<OMI>5</OMI>\n</OMATP>\n<OMA>\n<OMS cd=\"scscp1\" name=\"procedure_complet\
ed\" />\n<OMSTR></OMSTR>\n</OMA>\n</OMATTR>\n</OMOBJ>"
gap> MitM_CompleteProcedure(OMSTR(""), rec( time := 5 ), "cheese");
Error, MitM_CompleteProcedure: takes 1 or 2 arguments (not 3)
gap> MitM_TerminateProcedure("Error error");
"<OMOBJ version=\"2.0\">\n<OMATTR>\n<OMATP></OMATP>\n<OMA>\n<OMS cd=\"scscp1\"\
 name=\"procedure_terminated\" />\n<OME>\n<OMS cd=\"scscp1\" name=\"error_syst\
em_specific\" />\n<OMSTR>Error error</OMSTR>\n</OME>\n</OMA>\n</OMATTR>\n</OMO\
BJ>"
gap> MitM_TerminateProcedure("I am sorry Dave", rec( time := 5 ));
"<OMOBJ version=\"2.0\">\n<OMATTR>\n<OMATP>\n<OMS cd=\"scscp1\" name=\"time\" \
/>\n<OMI>5</OMI>\n</OMATP>\n<OMA>\n<OMS cd=\"scscp1\" name=\"procedure_termina\
ted\" />\n<OME>\n<OMS cd=\"scscp1\" name=\"error_system_specific\" />\n<OMSTR>\
I am sorry Dave</OMSTR>\n</OME>\n</OMA>\n</OMATTR>\n</OMOBJ>"
gap> MitM_TerminateProcedure("I am sorry Dave", rec( time := "I cant" ), "do that");
Error, MitM_TerminateProcedure: takes 1 or 2 arguments (not 3)
gap> xml := """
> <OMOBJ>
> </OMOBJ>""";;
gap> MitM_HandleSCSCP(MitM_XMLToOMRec(xml));;
#I   Invalid procedure call: OMATTR expected
gap> xml := """
> <OMOBJ>
>   <OMATTR>
>     <OMATP>
>       <OMS cd="scscp1" name="call_id" />
>       <OMSTR>symcomp.org:26133:18668:s2sYf1pg</OMSTR>
>     </OMATP>
>  <OMSTR>abc</OMSTR>
>  </OMATTR>
> </OMOBJ>""";;
gap> MitM_HandleSCSCP(MitM_XMLToOMRec(xml));;
#I   Invalid procedure call: OMA expected
gap> xml := """
> <OMOBJ>
>   <OMATTR>
>     <OMATP>
>       <OMS cd="scscp1" name="call_id" />
>       <OMSTR>symcomp.org:26133:18668:s2sYf1pg</OMSTR>
>     </OMATP>
>     <OMA>
>       <OMSTR>abc</OMSTR>
>     </OMA>
>   </OMATTR>
> </OMOBJ>""";;
gap> MitM_HandleSCSCP(MitM_XMLToOMRec(xml));;
#I   Invalid procedure call: OMS expected
gap> xml := """
> <OMOBJ>
>   <OMATTR>
>     <OMATP>
>       <OMS cd="scscp1" name="call_id" />
>       <OMSTR>symcomp.org:26133:18668:s2sYf1pg</OMSTR>
>     </OMATP>
>     <OMA>
>       <OMS cd="lib" name="bla"/>
>       <OMSTR>abc</OMSTR>
>     </OMA>
>   </OMATTR>
> </OMOBJ>""";;
gap> MitM_HandleSCSCP(MitM_XMLToOMRec(xml));;
#I   Invalid procedure call: OMA expected

# Client code
gap> StreamToMitMServer("localhost", 2, 3, 4);
Error, MitM_ConnectionToServer: 1 or 2 arguments expected, but 4 found
