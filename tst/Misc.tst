# RoundTripGAP
gap> MitM_RoundTripGAP(3).result;
3
gap> MitM_RoundTripGAP(["hello", "world"]).result;
[ "hello", "world" ]

# RoundTripXML
gap> MitM_RoundTripXML("<OMSTR>quod erat demonstrandum</OMSTR>");
"<OMSTR>quod erat demonstrandum</OMSTR>"
gap> MitM_RoundTripXML("<OMI>42</OMI>");
"<OMI>42</OMI>"
gap> xml := """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMSTR>hello</OMSTR>
> <OMSTR>world</OMSTR>
> <OMI>17</OMI>
> </OMA>""";;
gap> MitM_RoundTripXML(xml) = xml;
true

# MitM_Print
gap> MitM_Print(["hello", "world", 17]);
<OMOBJ>
<OMA>
<OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
<OMSTR>hello</OMSTR>
<OMSTR>world</OMSTR>
<OMI>17</OMI>
</OMA>
</OMOBJ>
