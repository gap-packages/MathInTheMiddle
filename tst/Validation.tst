# OMI
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x</OMI>"));
"-x is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-xs</OMI>"));
"-xs is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3421ABs</OMI>"));
"-x3421ABs is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3421AB</OMI>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3  \n42 1AB</OMI>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI><OMS/></OMI>"));
"OMI object must contain only a string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>24<OMS/> 17</OMI>"));
"OMI object must contain only a string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI x=\"4\">24<OMS/> 17</OMI>"));
"x is not a valid attribute of OMI objects"
