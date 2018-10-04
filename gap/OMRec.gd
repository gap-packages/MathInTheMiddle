
DeclareCategory("MitM_OMRec", IsObject);
DeclareRepresentation("MitM_OMRecRep", MitM_OMRec and IsComponentObjectRep, 1);
BindGlobal("MitM_OMRecFamily", NewFamily("MitM_OMRecFamily"));
BindGlobal("MitM_OMRecType", NewType(MitM_OMRecFamily, MitM_OMRecRep));

DeclareAttribute("MitM_Tag", MitM_OMRec);
DeclareAttribute("MitM_Name", MitM_OMRec);
DeclareAttribute("MitM_Attributes", MitM_OMRec);
DeclareAttribute("MitM_Content", MitM_OMRec);
DeclareAttribute("MitM_CDBase", MitM_OMRec);
DeclareAttribute("MitM_CD", MitM_OMRec);

DeclareGlobalFunction("MitM_ATPToRec");
DeclareGlobalFunction("MitM_RecToATP");
DeclareGlobalFunction("MitM_SimpleOMS");

DeclareGlobalFunction("OMOBJ");
DeclareGlobalFunction("OMA");
DeclareGlobalFunction("OMS");
DeclareGlobalFunction("OMATTR");
DeclareGlobalFunction("OMSTR");
DeclareGlobalFunction("OMF");
DeclareGlobalFunction("OMI");
DeclareGlobalFunction("OME");
