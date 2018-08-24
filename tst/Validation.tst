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

# OMS
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS />"));
"OMS objects must have the cd attribute"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS cd=\"you\" name=\"ohno\"/>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS xyz=\"you\" name=\"ohno\"/>"));
"xyz is not a valid attribute of OMS objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS cd=\"you\" name=\".ohno\"/>"));
"name attribute of OMS object: must start with a letter or underscore"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS cd=\"you\" name=\"_ohn*o\"/>"));
"name attribute of OMS object: must not contain the character \"'*'\""
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS cd=\"\" name=\"_ohno\"/>"));
"cd attribute of OMS object: must not be the empty string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec(
>      "<OMS cd=\"you\" name=\"ohno\" cdbase=\"www.example.com\"/>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec(
>      "<OMS cd=\"you\" name=\"ohno\">boo!</OMS>"));
"OMS object must have empty content"

# OMV
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV />"));
"OMV objects must have the name attribute"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV name=\"banana\">some content</OMV>"));
"OMV object must have empty content"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV name=\"banana\" />"));
true
