LoadPackage("MathInTheMiddle");
str := StreamToMitMServer("localhost");
CloseStream(str);
str := StreamToMitMServer("localhost", 26133);
xml := """
 <OMOBJ>
   <OMATTR>
     <OMATP>
       <OMS cd="scscp1" name="call_id" />
       <OMSTR>symcomp.org:26133:18668:s2sYf1pg</OMSTR>
       <OMS cd="scscp1" name="option_return_object" />
       <OMSTR></OMSTR>
     </OMATP>
     <OMA>
       <OMS cd="scscp1" name="procedure_call" />
       <OMA>
         <OMS cd="scscp_transient_1"
              name="GroupIdentificationService" />
         <OMA>
           <OMS cd="group1" name="group"/>
           <OMA>
             <OMS cd="permut1" name="permutation"/>
             <OMI>2</OMI> <OMI>3</OMI>
             <OMI>1</OMI>
           </OMA>
           <OMA>
             <OMS cd="permut1" name="permutation"/>
             <OMI>1</OMI> <OMI>2</OMI>
             <OMI>4</OMI> <OMI>3</OMI>
           </OMA>
         </OMA>
       </OMA>
     </OMA>
   </OMATTR>
 </OMOBJ>""";;
SendObjToMitMServer(str, MitM_XMLToOMRec(xml));;
CloseStream(str);
