# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);;
gap> r := MitM_GAPToOMRec(R);;
gap> x := MitM_OMRecToGAP(r);;
gap> x.success;
true
gap> x.result = R;
true

# Permutations
gap> MitM_OMRecToGAP(MitM_GAPToOMRec((1,5,4))).result = (1,5,4);
true

# Booleans
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(true)).result = true;
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(false)).result = false;
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(fail)).result = fail;
true

# Lists
gap> v := [1,2,3];; r := MitM_GAPToOMRec([1,2,3]);;
gap> MitM_OMRecToGAP(r).result = v;
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(D)).result = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(Q)).result = Q;
true

# An integer
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(27)).result = 27;
true

# An invalid record
gap> MitM_OMRecToGAP(rec());
Error, no method found! For debugging hints type ?Recovery from NoMethodFound
Error, no 1st choice method found for `MitM_OMRecToGAP' on 1 arguments

# An OMV variable
gap> banana := 12;;
gap> v := MitM_XMLToOMRec("<OMV name=\"banana\" />");;
gap> MitM_OMRecToGAP(v).result = banana;
true

# Negative hex integer
gap> v := MitM_XMLToOMRec("<OMI>-x3421AB</OMI>");;
gap> MitM_OMRecToGAP(v).result;
-3416491

# Ints with spaces
gap> MitM_XMLToGAP("<OMI>3  </OMI>").result;
3
gap> MitM_XMLToGAP("<OMI>   \n3 2 </OMI>").result;
32

# floats
gap> v := MitM_XMLToOMRec("<OMF dec=\"32.02\" />");;
gap> MitM_OMRecToGAP(v).result;
32.02
gap> v := MitM_XMLToOMRec("<OMF hex=\"0123456789ABCDEF\" />");;
gap> MitM_OMRecToGAP(v).success;
false
gap> MitM_OMRecToGAP(v).error;
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
gap> MitM_OMRecToGAP(v).result;
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
gap> MitM_OMRecToGAP(v).result(1) = "bana";
true

# OMS
gap> v := MitM_XMLToOMRec("<OMS cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"cd \"you\" not supported"
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="lib" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v).error;
Error, Variable: 'GroXYZup' must have a value
Error, Could not evaluate string.

gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="abc" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v).error;
"cd \"abc\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib2\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
"cd \"lib2\" not supported"
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v).error;
Error, Variable: 'LadIDaPerMuTAtIOnSuPeRfAiL' must have a value
Error, Could not evaluate string.


# OMS for Group function
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"Group\" />");;
gap> Group = MitM_OMRecToGAP(v).result;
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
gap> MitM_OMRecToGAP(v).result((1,2,3),(2,3)) = Group((1,2,3),(2,3));
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
gap> MitM_OMRecToGAP(a).result;
'M'
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="nothing" cd="lib" name="CharInt"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
"OMA contents: cdbase \"nothing\" is not supported"
gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="xyz"/> 
>   <OMI>77</OMI>
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
Error, Variable: 'xyz' must have a value
Error, Could not evaluate string.

gap> a := MitM_XMLToOMRec("""<OMA>
>   <OMS cdbase="https://www.gap-system.org/mitm/" cd="lib" name="CharInt"/> 
>   <OMF hex="0123456789ABCDEF" />
> </OMA>""");;
gap> MitM_OMRecToGAP(a).error;
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
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = Z(3,12) ^ 100;
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
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(xml)).result = Group((1,2,3));
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
gap> MitM_OMRecToGAP(MitM_XMLToOMRec("<OMSTR></OMSTR>")).result;
""

# MitM_get_allowed_heads
# This will probably change too much to test atm
# gap> Set(MitM_Content(MitM_get_allowed_heads()),
# >        r-> [MitM_CD(r), MitM_Name(r)]) = [
# > [ "lib", "MitM_Evaluate" ],
# > [ "scscp1", "symbol_set" ],
# > [ "scscp_transient_1", "MitM_Evaluate" ] ];
# true

# Bad names in known CDs
gap> xml := """<OMS cd="scscp2" name="madeup" />""";;
gap> MitM_XMLToGAP(xml).error;
"name \"madeup\" not supported"
gap> xml := StringFormatted("""<OMS cdbase="{}" cd="prim" name="madeup" />""",
>                           MitM_cdbase);;
gap> MitM_XMLToGAP(xml).error;
"OMS name \"madeup\" not a GAP primitive function"

# MitM_Evaluate
gap> MitM_Evaluate(OMSTR("hello")) = OMSTR("hello");
true

# Using a variable
gap> xyz := 2;;
gap> r := OMA(OMS(MitM_cdbase, "lib", "Float"), OMV("xyz"));;
gap> MitM_OMRecToGAP(r).result = 2.0;
true
