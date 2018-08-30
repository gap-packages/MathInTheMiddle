# Read an integer
gap> stream := InputTextString("""
> dog
> DOG
> <?scscp start ?>
> <OMI>12</OMI>
> <?scscp end ?>
> lovely!  All done!
> """);;
gap> MitM_ReadSCSCP(stream);
12

# A whole polynomial
gap> stream := InputTextString("""
> ignore these words!!! <?scscp start ?><OMA>
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="PolynomialByExtRep" />
> <OMA>
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="RationalFunctionsFamily" />
> <OMA>
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="FamilyObj" />
> <OMI>1</OMI>
> </OMA>
> </OMA>
> <OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMI>2</OMI>
> <OMI>1</OMI>
> </OMA>
> <OMI>1</OMI>
> <OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMI>1</OMI>
> <OMI>1</OMI>
> <OMI>3</OMI>
> <OMI>1</OMI>
> </OMA>
> <OMI>3</OMI>
> </OMA>
> </OMA>
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
