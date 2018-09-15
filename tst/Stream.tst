# Just an integer not in an OMOBJ
gap> stream := InputTextString("""
> dog
> DOG
> <?scscp start ?>
> <OMI>12</OMI>
> <?scscp end ?>
> lovely!  All done!
> """);;
gap> MitM_ReadSCSCP(stream).error;
"no OMOBJ object found"

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
gap> MitM_OMRecToGAP(MitM_ReadSCSCP(stream).result);
rec( result := 12, success := true )

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
gap> p := MitM_OMRecToGAP(MitM_ReadSCSCP(stream).result);;
gap> ExtRepPolynomialRatFun(p.result);
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
gap> MitM_OMRecToGAP(MitM_ReadSCSCP(stream).result).result;
42

# Unexpected end of stream
gap> stream := InputTextString("""
> dog
> <?scscp start ?>
> <OM
> """);;
gap> MitM_ReadSCSCP(stream).error;
"only one processing instruction found"

# No instruction
gap> stream := InputTextString("hello world");;
gap> MitM_ReadSCSCP(stream).error;
"no processing instruction found"

# Not an SCSCP instruction
gap> stream := InputTextString("<?some protocol ?>");;
gap> MitM_ReadSCSCP(stream).error;
"no SCSCP start instruction found"

# Not an SCSCP end instruction
gap> stream := InputTextString("<?scscp start ?> x <?scscp abc ?>");;
gap> MitM_ReadSCSCP(stream).error;
"no SCSCP end instruction found"

# Client handshaking: successful test
gap> in_stream := InputTextString("""
> <?scscp service_name="gap" service_version="4.10dev"
>         service_id="some_id" scscp_versions="1.0 2.0 1.3" ?>
> <?scscp version="1.3" ?>
> """);;
gap> out_str := "";;
gap> out_stream := OutputTextString(out_str, true);;
gap> MitM_SCSCPClientHandshake(in_stream, out_stream);
true
gap> NormalizeWhitespace(out_str);
gap> out_str;
"<?scscp version=\"1.3\" ?>"

# Server handshaking: successful test
gap> in_stream := InputTextString("<?scscp version=\"1.3\" ?>");;
gap> out_str := "";;
gap> out_stream := OutputTextString(out_str, true);;
gap> MitM_SCSCPServerHandshake(in_stream, out_stream);
"1.3"
gap> expected_output := StringFormatted("""
> <?scscp service_name="gap" service_version="4.10dev"
>         service_id="{}" scscp_versions="1.3" ?>
> <?scscp version="1.3" ?>
> """, String(IO_getpid()));;
gap> NormalizeWhitespace(out_str);
gap> NormalizeWhitespace(expected_output);
gap> out_str = expected_output;
true

# Client handshaking failures
gap> info := InfoLevel(InfoMitMSCSCP);;
gap> SetInfoLevel(InfoMitMSCSCP, 2);
gap> str := "abc";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Initiation failed: no processing instruction received
false
gap> str := "<?hello ?>";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Initiation failed: no SCSCP instruction received
false
gap> str := "<?scscp service_name=\"gap\" ?>";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Initiation failed: bad connection initiation message received
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 2.0" ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Initiation failed: server offers no SCSCP version we know
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: no valid response from server
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp quit reason="not supported version" ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: server quit with following message:
#I  "not supported version"
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: server sent no version number
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp version="2.0" ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: server chose version 2.0, which is not supported
false
gap> str := """<?scscp service_name="gap" service_version="4.10dev"
>                      service_id="some_id" scscp_versions="1.0 1.3" ?>
>              <?scscp version="1.3" ?>""";;
gap> MitM_SCSCPClientHandshake(InputTextString(str), OutputTextNone());
true
gap> SetInfoLevel(InfoMitMSCSCP, info);;

# Server handshaking failures
gap> info := InfoLevel(InfoMitMSCSCP);;
gap> SetInfoLevel(InfoMitMSCSCP, 2);
gap> str := "abc";;
gap> MitM_SCSCPServerHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: no version request from client
fail
gap> str := "<?scscp verararsion=\"1.3\" ?>";;
gap> MitM_SCSCPServerHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: no version request from client
fail
gap> str := """<?scscp version="1.99dev" ?>""";;
gap> MitM_SCSCPServerHandshake(InputTextString(str), OutputTextNone());
#I  Version negotiation failed: client requested 1.99dev, none of which is supported
fail
gap> SetInfoLevel(InfoMitMSCSCP, info);;
