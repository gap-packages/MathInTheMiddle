# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);;
gap> r := MitM_GAPToOMRec(R);;
gap> x := MitM_OMRecToGAPFunc(r);;
gap> x.success;
true
gap> x.result = R;
true

# Permutations
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec((1,5,4))).result = (1,5,4);
true

# Booleans
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(true)).result = true;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(false)).result = false;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(fail)).result = fail;
true

# Lists
gap> v := [1,2,3];; r := MitM_GAPToOMRec([1,2,3]);;
gap> MitM_OMRecToGAPFunc(r).result = v;
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(D)).result = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(Q)).result = Q;
true

# An integer
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(27)).result = 27;
true

# An invalid record
gap> MitM_OMRecToGAPFunc(rec());
rec( error := "invalid XML: an object must have a name", success := false )

# An OMV variable
gap> banana := 12;;
gap> v := MitM_XMLToOMRec("<OMV name=\"banana\" />");;
gap> MitM_OMRecToGAPFunc(v);
rec( result := "banana", success := true )

# Negative hex integer
gap> v := MitM_XMLToOMRec("<OMI>-x3421AB</OMI>");;
gap> MitM_OMRecToGAPFunc(v).result;
-3416491

# Ints with spaces
gap> MitM_XMLToGAP("<OMI>3  </OMI>").result;
3
gap> MitM_XMLToGAP("<OMI>   \n3 2 </OMI>").result;
32

# floats
gap> v := MitM_XMLToOMRec("<OMF dec=\"32.02\" />");;
gap> MitM_OMRecToGAPFunc(v).result;
32.02
gap> v := MitM_XMLToOMRec("<OMF hex=\"0123456789ABCDEF\" />");;
gap> MitM_OMRecToGAPFunc(v).success;
false
gap> MitM_OMRecToGAPFunc(v).error;
"OMF: hex encoding not supported"

# Records
gap> specifications := MitM_XMLToGAP("""
> <OMA>
>   <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="RecConstr" />
>   <OMSTR>style</OMSTR>
>   <OMSTR>5-door hatchback</OMSTR>
>   <OMSTR>range</OMSTR>
>   <OMI>21 0</OMI>
>   <OMSTR>assembly</OMSTR>
>   <OMSTR>Flins, France</OMSTR>
> </OMA>
> """);;
gap> specifications.result =
> rec(
>   assembly := "Flins, France",
>   range := 210,
>   style := "5-door hatchback"
> );
true

# OMB
gap> v := MitM_XMLToOMRec("<OMB>cheesyworldhello</OMB>");;
gap> MitM_OMRecToGAPFunc(v).result;
"cheesyworldhello"

# OMBIND
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="lambda" />
>    <OMBVAR>
>      <OMV name="v"/>
>    </OMBVAR> <!--Random comment-->
>    <OMB>bana</OMB>
>  </OMBIND>
> """);;
gap> MitM_OMRecToGAPFunc(v).result(1) = "bana";
true

# OMS
gap> v := MitM_XMLToOMRec("<OMS cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAPFunc(v).error;
"cd \"you\" not supported"
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="lib" name="GroXYZup" />""");;
gap> MitM_OMRecToGAPFunc(v).error;
Error, Variable: 'GroXYZup' must have a value
Error, Could not evaluate string.

gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="abc" name="GroXYZup" />""");;
gap> MitM_OMRecToGAPFunc(v).error;
"cd \"abc\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib2\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAPFunc(v).error;
"cd \"lib2\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAPFunc(v).error;
Error, Variable: 'LadIDaPerMuTAtIOnSuPeRfAiL' must have a value
Error, Could not evaluate string.


# OMS for Group function
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"Group\" />");;
gap> Group = MitM_OMRecToGAPFunc(v).result;
true

# OMBIND
gap> v := MitM_XMLToOMRec("""
>  <OMBIND>
>    <OMS cdbase="https://www.gap-system.org/mitm/"
>         cd="prim"
>         name="lambda" />
>    <!-- Start OMBVAR here-->
>    <OMBVAR>
>      <OMV name="x" />
>      <OMV name="y" /> 
>    </OMBVAR>
>    <!-- End OMBVAR? here-->
>    <OMA>
>      <OMS cdbase="https://www.gap-system.org/mitm/"
>           cd="lib"
>           name="Group"/> 
>      <OMV name="x"/>  
>      <OMV name="y"/>
>    </OMA>
>  </OMBIND>
> """);;
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
gap> MitM_OMRecToGAPFunc(v).error;
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
gap> MitM_OMRecToGAPFunc(v).error;
"OMBIND contents: OMA contents: cd \"afs\" not supported"

# OMA
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="CharInt"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAPFunc(a).result;
'M'
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="nothing" cd="lib" name="CharInt"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAPFunc(a).error;
"OMA contents: cdbase \"nothing\" is not supported"
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="xyz"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAPFunc(a).error;
Error, Variable: 'xyz' must have a value
Error, Could not evaluate string.

gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="CharInt"/> 
>   <OMF hex="0123456789ABCDEF" />
> </OMA>""");;
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
gap> z := MitM_OMRecToGAPFunc(MitM_XMLToOMRec(xml)).result = Z(13, 3) ^ 1452;
true

# Finite field elements: Conway rep
gap> xml := """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="FFEConstr" />
> <OMI>3</OMI>
> <OMI>12</OMI>
> <OMI>1</OMI>
> <OMI>0</OMI>
> <OMI>0</OMI> <!-- comment here -->
> <OMI>0</OMI>
> <OMI>0</OMI>
> <OMI>1</OMI>
> <OMI>1<!-- and here --></OMI>
> <OMI>0</OMI>
> <OMI>2</OMI>
> <OMI>0</OMI>
> <OMI>1</OMI>
> <OMI>1</OMI>
> </OMA>""";;
gap> MitM_OMRecToGAPFunc(MitM_XMLToOMRec(xml)).result = Z(3,12) ^ 100;
true

# OMATTR
gap> xml := """<OMATTR>
> <OMATP>
>   <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="Size" />
>   <OMI>15</OMI>
> </OMATP>
> <OMA>
>   <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="Group" />
> <OMA>
>   <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="ListConstr" />
>   <OMA>
>     <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="PermConstr" />
>       <OMI>2</OMI>
>       <OMI>3</OMI>
>       <OMI>1</OMI>
>     </OMA>
>   </OMA>
> </OMA>
> </OMATTR>""";;
gap> MitM_OMRecToGAPFunc(MitM_XMLToOMRec(xml)).result = Group((1,2,3));
true

# Characters
gap> xml := """<OMA>
> <OMS cd="prim" cdbase="https://www.gap-system.org/mitm/" name="CharConstr" />
> <OMSTR>a</OMSTR>
> </OMA>""";;
gap> MitM_XMLToGAP(xml).result;
'a'

# Strings
gap> MitM_RoundTripGAP("hello world").result;
"hello world"
gap> MitM_XMLToGAP("<OMSTR></OMSTR>").result;
""
gap> MitM_OMRecToGAPFunc(MitM_XMLToOMRec("<OMSTR></OMSTR>")).result;
""
