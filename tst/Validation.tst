# OMI
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x</OMI>"));
"OMI contents: -x is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-xs</OMI>"));
"OMI contents: -xs is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3421ABs</OMI>"));
"OMI contents: -x3421ABs is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3421AB</OMI>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>-x3  \n42 1AB</OMI>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI><OMS/></OMI>"));
"OMI contents: must be only a string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI>24<OMS/> 17</OMI>"));
"OMI contents: must be only a string"
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
"OMS contents: must be empty"

# OMV
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV />"));
"OMV objects must have the name attribute"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV name=\"banana\">some content</OMV>"));
"OMV contents: must be empty"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMV name=\"banana\" />"));
true

# OMF
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF dec=\"32.02\" />"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF dec=\"32.02a\" />"));
"dec attribute of OMF object: 32.02a is not a valid float"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF dec=\".01e17\" />"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF dec=\"-INF\" />"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF hex=\"ABC\" />"));
"hex attribute of OMF object: must be 16 characters long"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF hex=\"123456DEADBEEF16\" />"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF hex=\"123456DEADBEET16\" />"));
"hex attribute of OMF object: contains non-hex character"

# OMSTR
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMSTR />"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMSTR></OMSTR>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMSTR>hello!</OMSTR>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMSTR><OMI>3</OMI></OMSTR>"));
"OMSTR contents: must be only a string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMSTR font=\"bold\">hello!</OMSTR>"));
"font is not a valid attribute of OMSTR objects"
