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

#str := StreamToMitMServer("localhost", 26133);
#oma := OMA(OMS(MitM_cdbase, "lib", "Size"), MitM_GAPToOMRec([]));
#call := MitM_ProcedureCall(oma);
#out := SendObjToMitMServer(str, call);
#if MitM_Content(MitM_Content(MitM_Content(out.result)[1])[2])[2] <> OMI(0) then
#    CloseStream(str);
#    FORCE_QUIT_GAP(1);
#fi;
#CloseStream(str);
