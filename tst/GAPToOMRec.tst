# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);
Integers[x1,x2,x3,x4]
gap> MitM_GAPToOMRec(R) =
> OMA(OMS(MitM_cdbase, "lib", "PolynomialRing"),
>     OMS(MitM_cdbase, "lib", "Integers"),
>     OMA(OMS(MitM_cdbase, "prim", "ListConstr"),
>         OMSTR("x1"),
>         OMSTR("x2"),
>         OMSTR("x3"),
>         OMSTR("x4")));
true

# Permutations
gap> MitM_GAPToOMRec( (1,5,4) ) =
> OMA(OMS(MitM_cdbase, "prim", "PermConstr"),
>     OMI(5), OMI(2), OMI(3), OMI(1), OMI(4));
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_GAPToOMRec(D) =
>   OMA(OMS(MitM_cdbase, "lib", "DihedralGroup"),
>       OMS(MitM_cdbase, "lib", "IsPermGroup"),
>       OMI(10));
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToXML(MitM_GAPToOMRec(Q)) = """<OMA>
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="QuaternionGroup" />
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="IsPermGroup" />
> <OMI>8</OMI>
> </OMA>""";
true

# An integer
gap> MitM_OMRecToXML(MitM_GAPToOMRec(27));
"<OMI>27</OMI>"

# A float
gap> MitM_GAPToXML(3.141592654);
"<OMF dec=\"3.1415926540000001\" />"

# Records
gap> r :=
> rec(
>   assembly := "Flins, France",
>   range := 210,
>   style := "5-door hatchback"
> );;
gap> Print(MitM_GAPToXML(r), "\n");
<OMA>
<OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="RecConstr" />
<OMSTR>assembly</OMSTR>
<OMSTR>Flins, France</OMSTR>
<OMSTR>range</OMSTR>
<OMI>210</OMI>
<OMSTR>style</OMSTR>
<OMSTR>5-door hatchback</OMSTR>
</OMA>

# Polynomials
gap> p := PolynomialByExtRep( RationalFunctionsFamily(FamilyObj(1)),
>                             [[2,1], 1, [1,1,3,1], 3] );
3*x1*x3+x2
gap> MitM_OMRecToXML(MitM_GAPToOMRec(p)) = """<OMA>
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
> </OMA>""";
true

# Two strings together in a list
# Note: I'm not sure this will ever come up in GAP or OpenMath, and perhaps it
#       should be prohibited.  FromStream.gi will treat it as one string.
# gap> r := rec(name := "OMTWOSTRINGS", content := ["hello", "world"]);;
# gap> MitM_OMRecToXML(r);
# "<OMTWOSTRINGS>\nhello\nworld\n</OMTWOSTRINGS>"

# OMRecToOMOBJRec
gap> MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec([29..31]))) =
> """<OMOBJ version="2.0">
> <OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMI>29</OMI>
> <OMI>30</OMI>
> <OMI>31</OMI>
> </OMA>
> </OMOBJ>""";
true

# Finite field elements: internal rep
gap> z := Z(13, 3) ^ 1452;
Z(13^3)^1452
gap> IsInternalRep(z);
true
gap> IsCoeffsModConwayPolRep(z);
false
gap> xml := MitM_OMRecToXML(MitM_GAPToOMRec(z));;
gap> xml = """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="FFEConstr" />
> <OMI>13</OMI>
> <OMI>3</OMI>
> <OMI>6</OMI>
> <OMI>1</OMI>
> <OMI>2</OMI>
> </OMA>""";
true
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = z;
true

# Finite field elements: Conway rep
gap> z := Z(3,12) ^ 100;
1+z5+z6+2z8+z10+z11
gap> IsInternalRep(z);
false
gap> IsCoeffsModConwayPolRep(z);
true
gap> xml := MitM_OMRecToXML(MitM_GAPToOMRec(z));;
gap> xml = """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="FFEConstr" />
> <OMI>3</OMI>
> <OMI>12</OMI>
> <OMI>1</OMI>
> <OMI>0</OMI>
> <OMI>0</OMI>
> <OMI>0</OMI>
> <OMI>0</OMI>
> <OMI>1</OMI>
> <OMI>1</OMI>
> <OMI>0</OMI>
> <OMI>2</OMI>
> <OMI>0</OMI>
> <OMI>1</OMI>
> <OMI>1</OMI>
> </OMA>""";
true
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = z;
true

# Characters
gap> MitM_RoundTripGAP('a');
rec( result := 'a', success := true )
gap> MitM_GAPToXML('a') = """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="CharConstr" />
> <OMSTR>a</OMSTR>
> </OMA>""";
true
