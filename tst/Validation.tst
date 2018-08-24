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

# OMB
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB></OMB>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB Length=\"12\">FourFour</OMB>"));
"Length is not a valid attribute of OMB objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB><OMI>3</OMI></OMB>"));
"OMB contents: must be only a string"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0FB8</OMB>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0fb8</OMB>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0 FB8 \n0F+9</OMB>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0F+40A==</OMB>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>FB8</OMB>"));
"OMB contents: must have length divisible by 4"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>==0F</OMB>"));
"OMB contents: only 1 or 2 '=' characters allowed, and only at the end"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>==0F</OMB>"));
"OMB contents: only 1 or 2 '=' characters allowed, and only at the end"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0F==</OMB>"));
"OMB contents: one of [AQgw] must come before '=='"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0Fv=</OMB>"));
"OMB contents: one of [AEIMQUYcgkosw048=] must come before '='"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMB>0Fv*aabC</OMB>"));
"OMB contents: cannot contain character '*'"

# OMA
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA><OMI>4</OMI></OMA>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA></OMA>"));
"OMA contents: must not be empty"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA><OMI Name=\"bad\">4</OMI></OMA>"));
"OMA contents: Name is not a valid attribute of OMI objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA><OMI>hello</OMI></OMA>"));
"OMA contents: OMI contents: hello is not an integer"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA>hello</OMA>"));
"OMA contents: must only contain OM elements"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA><Weird /></OMA>"));
"OMA contents: cannot contain Weird objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMA><Blahblahblah /></OMA>"));
"OMA contents: cannot contain Blahblahblah objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec(
>      "<OMA><OMS cd=\"abc\" name=\"myfunc\" />\n<OMI>4</OMI></OMA>"));
true

# OMBVAR
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMBVAR />"));
"OMBVAR contents: must not be empty"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMBVAR><OMI>42</OMI></OMBVAR>"));
"OMBVAR contents: must only contain OMV objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMBVAR><OMV Name=\"x\" /></OMBVAR>"));
"OMBVAR contents: Name is not a valid attribute of OMV objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMBVAR><OMV name=\"x\" /></OMBVAR>"));
true
