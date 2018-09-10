# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);
Integers[x1,x2,x3,x4]
gap> MitM_GAPToOMRec(R) =
> rec(
>   content :=
>     [
>       rec(
>           attributes :=
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/"
>                 , name := "PolynomialRing" ), name := "OMS" ),
>       rec(
>           attributes :=
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/"
>                 , name := "Integers" ), name := "OMS" ),
>       rec(
>           content :=
>             [
>               rec(
>                   attributes :=
>                     rec( cd := "prim",
>                       cdbase := "https://www.gap-system.org/mitm/",
>                       name := "ListConstr" ), name := "OMS" ),
>               rec( content := [ "x1" ], name := "OMSTR" ),
>               rec( content := [ "x2" ], name := "OMSTR" ),
>               rec( content := [ "x3" ], name := "OMSTR" ),
>               rec( content := [ "x4" ], name := "OMSTR" ) ], name := "OMA" )
>      ], name := "OMA" );
true

# Permutations
gap> MitM_GAPToOMRec( (1,5,4) ) =
> rec( 
>   content := 
>     [ 
>       rec( 
>           attributes := 
>             rec( cd := "prim", cdbase := "https://www.gap-system.org/mitm/"
>                 , name := "PermConstr" ), name := "OMS" ), 
>       rec( content := [ "5" ], name := "OMI" ), 
>       rec( content := [ "2" ], name := "OMI" ), 
>       rec( content := [ "3" ], name := "OMI" ), 
>       rec( content := [ "1" ], name := "OMI" ), 
>       rec( content := [ "4" ], name := "OMI" ) ], name := "OMA" );
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_GAPToOMRec(D) =
> rec( 
>   content := 
>     [ 
>       rec( 
>           attributes := 
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/",
>               name := "DihedralGroup" ), name := "OMS" ), 
>       rec( 
>           attributes := 
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/",
>               name := "IsPermGroup" ), name := "OMS" ), 
>       rec( content := [ "10" ], name := "OMI" ) ], name := "OMA" );
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
gap> r := rec(name := "OMTWOSTRINGS", content := ["hello", "world"]);;
gap> MitM_OMRecToXML(r);                                             
"<OMTWOSTRINGS>\nhello\nworld\n</OMTWOSTRINGS>"

# OMRecToOMOBJRec
gap> MitM_OMRecToXML(MitM_OMRecToOMOBJRec(MitM_GAPToOMRec([29..31]))) =
> """<OMOBJ>
> <OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
> <OMI>29</OMI>
> <OMI>30</OMI>
> <OMI>31</OMI>
> </OMA>
> </OMOBJ>""";
true
