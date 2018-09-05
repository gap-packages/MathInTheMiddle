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
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMS id=\"somename\" />"));
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
"hex attribute of OMF object: contains non-hex character 'T'"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF hex=\"123456deadbeef16\" />"));
"hex attribute of OMF object: contains non-hex character 'd' (not capital)"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMF />"));
"OMF objects must have either the dec or the hex attribute"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec(
>      "<OMF dec=\"32.02\" hex=\"123456DEADBEEF16\" />"));
"OMF objects cannot have both the dec and the hex attribute"

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

# OMBIND
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMBIND><OMI>12</OMI></OMBIND>"));
"OMBIND contents: must be [OM elm, OMBVAR, OM elm] (in that order)"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec(
>      "<OMBIND kind=\"goodbind\"><OMI>12</OMI></OMBIND>"));
"kind is not a valid attribute of OMBIND objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""<OMBIND>
>     <OMI>12</OMI>
>     <OMBVAR>
>       <OMV name="x" />
>       <OMV name="y" />
>     </OMBVAR>
>     <OMSTR>hello world</OMSTR>
>   </OMBIND>"""));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""<OMBIND>
>     <OMI>12</OMI>
>     <OMBVAR>
>       <OMV name="x" z="abc" />
>       <OMV name="y" />
>     </OMBVAR>
>     <OMSTR>hello world</OMSTR>
>   </OMBIND>"""));
"OMBIND contents: OMBVAR contents: z is not a valid attribute of OMV objects"

# id attribute
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""<OMBIND id="a binding!">
>     <OMI id="dozen">12</OMI>
>     <OMBVAR id="cartesian names">
>       <OMV name="x" />
>       <OMV name="y" />
>     </OMBVAR>
>     <OMSTR id="traditional dummy text">hello world</OMSTR>
>   </OMBIND>"""));
true

# cdbase attribute
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""<OMBIND cdbase="a.b.com">
>     <OMI>12</OMI>
>     <OMBVAR>
>       <OMV name="x" />
>       <OMV name="y" />
>     </OMBVAR>
>     <OMSTR>hello world</OMSTR>
>   </OMBIND>"""));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""
> <OMA cdbase="a.b.com"><OMI>4</OMI></OMA>"""));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMI cdbase=\"a.b.com\">4</OMI>"));
"cdbase is not a valid attribute of OMI objects"

# OMOBJ
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMOBJ><OMI>42</OMI></OMOBJ>"));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMOBJ x=\"y\"><OMI>42</OMI></OMOBJ>"));
"x is not a valid attribute of OMOBJ objects"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""
> <OMOBJ version="2.1">
>   <OMSTR>hello</OMSTR>
> </OMOBJ>
> """));
true
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("""
> <OMOBJ version="2.1">
>   <OMSTR>hello</OMSTR>
>   <OMSTR>world</OMSTR>
> </OMOBJ>
> """));
"OMOBJ contents: must be precisely one object"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMOBJ>3.14159</OMOBJ>"));
"OMOBJ contents: must be an OM element"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMOBJ><OMI>3.5</OMI></OMOBJ>"));
"OMOBJ contents: OMI contents: 3.5 is not an integer"

# Not yet implemented objects
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OME />"));
"OME contents: not implemented"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMATTR />"));
"OMATTR contents: not implemented"
gap> MitM_IsValidOMRec(MitM_XMLToOMRec("<OMR />"));
"OMR contents: not implemented"

# Contrived errors that don't use XML input
gap> MitM_IsValidOMRec("hello");
"<tree> must be an OM record"
gap> MitM_IsValidOMRec(rec());
"Invalid XML: an object must have a name"
gap> MitM_IsValidOMRec(rec(name := "Peter Rabbit"));
"Peter Rabbit is not a valid OM object name"
gap> MitM_IsValidOMRec(rec(name := "OMOBJ", os := "Linux"));
"Invalid XML: os should not exist"
gap> MitM_IsValidOMRec(rec(name := "OMOBJ",
>                          attributes := rec(version := "Linux<Ubuntu>")));
"version attribute of OMOBJ object: XML strings cannot contain '<'"
gap> MitM_IsValidOMRec(rec(name := "OMV",
>                          attributes := rec(name := "Tom & Jerry")));
"name attribute of OMV object: there is a '&' character without a closing ';'"
gap> MitM_IsValidOMRec(rec(name := "OMSTR", content := ["Tom & Jerry"]));
"OMSTR contents: there is a '&' character without a closing ';'"
