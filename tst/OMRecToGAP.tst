# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);;
gap> r := MitM_GAPToOMRec(R);;
gap> x := MitM_OMRecToGAP(r);;
gap> x.success;
true
gap> x.result = R;
true
gap> x := MitM_OMRecToGAPFunc(r);;
gap> x.success;
true
gap> x.result = R;
true

# Permutations
gap> MitM_OMRecToGAP(MitM_GAPToOMRec( (1,5,4) )).result = (1,5,4);
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec((1,5,4))).result = (1,5,4);
true

# Booleans
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(true)).result = true;
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(false)).result = false;
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(fail)).result = fail;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(true)).result = true;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(false)).result = false;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(fail)).result = fail;
true

# Lists
gap> v := [1,2,3];; r := MitM_GAPToOMRec([1,2,3]);;
gap> MitM_OMRecToGAP(r).result = v;
true
gap> MitM_OMRecToGAPFunc(r).result = v;
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(D)).result = D;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(D)).result = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(Q)).result = Q;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(Q)).result = Q;
true

# An integer
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(27)).result = 27;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(27)).result = 27;
true

# An invalid record
gap> MitM_OMRecToGAP(rec());
rec( error := "invalid XML: an object must have a name", success := false )
gap> MitM_OMRecToGAPFunc(rec());
rec( error := "invalid XML: an object must have a name", success := false )

# An OMV variable
gap> banana := 12;;
gap> v := MitM_XMLToOMRec("<OMV name=\"banana\" />");;
gap> MitM_OMRecToGAP(v);
rec( result := "banana", success := true )
gap> MitM_OMRecToGAPFunc(v);
rec( result := "banana", success := true )

# Negative hex integer
gap> v := MitM_XMLToOMRec("<OMI>-x3421AB</OMI>");;
gap> MitM_OMRecToGAP(v).result;
-3416491
gap> MitM_OMRecToGAPFunc(v).result;
-3416491

# floats
gap> v := MitM_XMLToOMRec("<OMF dec=\"32.02\" />");;
gap> MitM_OMRecToGAP(v).result;
32.02
gap> MitM_OMRecToGAPFunc(v).result;
32.02
gap> v := MitM_XMLToOMRec("<OMF hex=\"0123456789ABCDEF\" />");;
gap> MitM_OMRecToGAP(v).success;
false
gap> MitM_OMRecToGAP(v).error;
"OMF: hex encoding not supported"
gap> MitM_OMRecToGAPFunc(v).success;
false
gap> MitM_OMRecToGAPFunc(v).error;
"OMF: hex encoding not supported"

# OMB
gap> v := MitM_XMLToOMRec("<OMB>cheesyworldhello</OMB>");;
gap> MitM_OMRecToGAP(v).result;
"cheesyworldhello"
gap> MitM_OMRecToGAPFunc(v).result;
"cheesyworldhello"

# OMBIND
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="lambda" />
>    <OMBVAR>
>    <OMV name="v"/>
>    </OMBVAR>
>    <OMB>bana</OMB>
>  </OMBIND>
> """);;
gap> MitM_OMRecToGAPFunc(v).result(1) = "bana";
true

# OMS
gap> v := MitM_XMLToOMRec("<OMS cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"cdbase must be https://www.gap-system.org/mitm/"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"banana\" cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"cdbase must be https://www.gap-system.org/mitm/"
gap> MitM_OMRecToGAPFunc(v).error;
"cdbase must be https://www.gap-system.org/mitm/"
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="lib" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v).error;
"symbol \"GroXYZup\" not known"
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="prim" name="CrazyEncoding" />""");;
gap> MitM_OMRecToGAP(v).error;
"OMS name \"CrazyEncoding\" not a GAP primitive function"
gap> MitM_OMRecToGAPFunc(v).error;
"OMS name \"CrazyEncoding\" not a GAP primitive function"
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="abc" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v).error;
"cd \"abc\" not supported"
gap> MitM_OMRecToGAPFunc(v).error;
"cd \"abc\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib2\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"cd \"lib2\" not supported"
gap> MitM_OMRecToGAPFunc(v).error;
"cd \"lib2\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"symbol \"LadIDaPerMuTAtIOnSuPeRfAiL\" not known"
gap> MitM_OMRecToGAPFunc(v).error;
"symbol \"LadIDaPerMuTAtIOnSuPeRfAiL\" not known"

# OMS for Group function
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"Group\" />");;
gap> Group = MitM_OMRecToGAP(v).result;
true
gap> Group = MitM_OMRecToGAPFunc(v).result;
true

# OMBIND
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="lambda" />
>    <OMBVAR>
>      <OMV name="x" />
>      <OMV name="y" /> 
>    </OMBVAR>
>    <OMA>
>      <OMS cdbase="https://www.gap-system.org/mitm/"
>           cd="lib"
>           name="Group"/> 
>      <OMV name="x"/>  
>      <OMV name="y"/>
>    </OMA>
>  </OMBIND>
> """);;
gap> MitM_OMRecToGAP(v).result((1,2,3),(2,3)) = Group((1,2,3),(2,3));
true
gap> MitM_OMRecToGAPFunc(v).result((1,2,3),(2,3)) = Group((1,2,3),(2,3));
true
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="SuPeRfAiLlambda" />
>    <OMBVAR>
>      <OMV name="x" />
>      <OMV name="y" /> 
>    </OMBVAR>
>    <OMA>
>      <OMS cdbase="https://www.gap-system.org/mitm/"
>           cd="lib"
>           name="Group"/> 
>      <OMV name="x"/>  
>      <OMV name="y"/>
>    </OMA>
>  </OMBIND>
> """);;
gap> MitM_OMRecToGAP(v).error;
"only the lambda binding is implemented"
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="lambda" />
>    <OMBVAR>
>      <OMV name="x" />
>      <OMV name="y" /> 
>    </OMBVAR>
>    <OMA>
>      <OMS cdbase="https://www.gap-system.org/mitm/"
>           cd="afs"
>           name="Group"/> 
>      <OMV name="x"/>  
>      <OMV name="y"/>
>    </OMA>
>  </OMBIND>
> """);;
gap> MitM_OMRecToGAP(v).error;
"OMBIND contents: OMA contents: cd \"afs\" not supported"

# OMA
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="CharInt"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAP(a).success;
true
gap> MitM_OMRecToGAP(a).result;
'M'
gap> MitM_OMRecToGAPFunc(a).result;
'M'
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="nothing" cd="lib" name="CharInt"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
"OMA contents: cdbase must be https://www.gap-system.org/mitm/"
gap> MitM_OMRecToGAPFunc(a).error;
"OMA contents: cdbase must be https://www.gap-system.org/mitm/"
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="xyz"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
"OMA contents: symbol \"xyz\" not known"
gap> MitM_OMRecToGAPFunc(a).error;
"OMA contents: symbol \"xyz\" not known"
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="CharInt"/> 
>   <OMF hex="0123456789ABCDEF" />
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
"OMA contents: OMF: hex encoding not supported"
gap> MitM_OMRecToGAPFunc(a).error;
"OMA contents: OMF: hex encoding not supported"

# Finite field elements: internal rep
gap> xml := """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="FFEConstr" />
> <OMI>13</OMI>
> <OMI>3</OMI>
> <OMI>6</OMI>
> <OMI>1</OMI>
> <OMI>2</OMI>
> </OMA>""";;
gap> z := MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = Z(13, 3) ^ 1452;
true
gap> z := MitM_OMRecToGAPFunc(MitM_XMLToOMRec(xml)).result = Z(13, 3) ^ 1452;
true

# Finite field elements: Conway rep
gap> xml := """<OMA>
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
> </OMA>""";;
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = Z(3,12) ^ 100;
true
gap> MitM_OMRecToGAPFunc(MitM_XMLToOMRec(xml)).result = Z(3,12) ^ 100;
true
