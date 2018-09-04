# Just an integer not in an OMOBJ
gap> stream := InputTextString("""
> dog
> DOG
> <?scscp start ?>
> <OMI>12</OMI>
> <?scscp end ?>
> lovely!  All done!
> """);;
gap> MitM_ReadSCSCP(stream);
fail

# The same, but in an OMOBJ
gap> stream := InputTextString("""
> dog
> DOG
> <?scscp start ?>
> <OMOBJ>
> <OMI>12</OMI>
> </OMOBJ>
> <?scscp end ?>
> lovely!  All done!
> """);;
gap> MitM_ReadSCSCP(stream);
12

# A whole polynomial
gap> stream := InputTextString("""
> ignore these words!!! <?scscp start ?><OMOBJ>
> <OMA>
>   <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="PolynomialByExtRep" />
>   <OMA>
>     <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="RationalFunctionsFamily" />
>     <OMA>
>       <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="FamilyObj" />
>       <OMI>1</OMI>
>     </OMA>
>   </OMA>
>   <OMA>
>     <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>     <OMA>
>       <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>       <OMI>2</OMI>
>       <OMI>1</OMI>
>     </OMA>
>     <OMI>1</OMI>
>     <OMA>
>       <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>       <OMI>1</OMI>
>       <OMI>1</OMI>
>       <OMI>3</OMI>
>       <OMI>1</OMI>
>     </OMA>
>     <OMI>3</OMI>
>   </OMA>
> </OMA>
> </OMOBJ>
> <?scscp end ?>
> """);;
gap> p := MitM_ReadSCSCP(stream);;
gap> ExtRepPolynomialRatFun(p);
[ [ 2, 1 ], 1, [ 1, 1, 3, 1 ], 3 ]

# ReadToPI errors
gap> stream := InputTextString("abc");;
gap> r := MitM_ReadToPI(stream);;
gap> r.success;
false
gap> r.error;
"stream ended before an XML PI was found"
gap> r.pre;
"abc"
gap> stream := InputTextString("<?scscp uuhhh");;
gap> r := MitM_ReadToPI(stream);;
gap> r.success;
false
gap> r.error;
"stream ended in middle of XML PI"
gap> r.pre;
""
gap> r.pi;
"scscp uuhhh"
gap> stream := InputTextString("<?scscp <OMI>7</OMI> ?>");;
gap> r := MitM_ReadToPI(stream);;
gap> r.success;
false
gap> r.error;
"'<' character illegal inside XML PI"
gap> r.pi;
"scscp "
gap> string := Concatenation("<?", ListWithIdenticalEntries(4089, 'a'), " ?>");;
gap> stream := InputTextString(string);;
gap> MitM_ReadToPI(stream).success;
true
gap> string := Concatenation("<?", ListWithIdenticalEntries(4090, 'a'), " ?>");;
gap> stream := InputTextString(string);;
gap> r := MitM_ReadToPI(stream);;
gap> r.success;
false
gap> r.error;
"XML PI cannot be longer than 4094 characters"

# Successful OMOBJ
gap> stream := InputTextString("""
> <?scscp start ?>
> <OMOBJ version="2.1">
>   <OMI>42</OMI>
> </OMOBJ>
> <?scscp end ?>
> """);;
gap> MitM_ReadSCSCP(stream);
42

# Unexpected end of stream
gap> stream := InputTextString("""
> dog
> <?scscp start ?>
> <OM
> """);;
gap> MitM_ReadSCSCP(stream);
fail

# No instruction
gap> stream := InputTextString("hello world");;
gap> MitM_ReadSCSCP(stream);
fail

# Not an SCSCP instruction
gap> stream := InputTextString("<?some protocol ?>");;
gap> MitM_ReadSCSCP(stream);
fail

# Not an SCSCP instruction
gap> stream := InputTextString("<?scscp start ?> x <?scscp abc ?>");;
gap> MitM_ReadSCSCP(stream);
fail

# Handshaking: successful test
gap> in_stream := InputTextString("""
> <?scscp service_name="gap" service_version="4.10dev"
>         service_id="some_id" scscp_versions="1,0 2.0 1.3" ?>
> <?scscp version="1.3" ?>
> """);;
gap> out_str := "";;
gap> out_stream := OutputTextString(out_str, true);;
gap> MitM_SCSCPHandshake(in_stream, out_stream);
true
gap> NormalizeWhitespace(out_str);
gap> out_str;
"<?scscp version=\"1.3\" ?>"

# Handshaking failures
gap> str := "abc";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := "<?hello ?>";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := "<?scscp service_name=\"gap\" ?>";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 2.0" ?>
> """;;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
> """;;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp quit reason="not supported version" ?>""";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp ?>""";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp version="2.0" ?>""";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp version="1.3" ?>""";;
gap> MitM_SCSCPHandshake(InputTextString(str), OutputTextNone());
true
