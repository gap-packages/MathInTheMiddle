# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);;
gap> r := MitM_GAPToOMRec(R);;
gap> MitM_OMRecToGAP(r) = R;
true
gap> MitM_OMRecToGAPFunc(r) = R;
true

# Permutations
gap> MitM_OMRecToGAP(MitM_GAPToOMRec( (1,5,4) )) = (1,5,4);
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec((1,5,4))) = (1,5,4);
true

# Lists
gap> v := [1,2,3];; r := MitM_GAPToOMRec([1,2,3]);;
gap> MitM_OMRecToGAP(r) = v;
true
gap> MitM_OMRecToGAPFunc(r) = v;
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(D)) = D;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(D)) = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(Q)) = Q;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(Q)) = Q;
true

# An integer
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(27)) = 27;
true
gap> MitM_OMRecToGAPFunc(MitM_GAPToOMRec(27)) = 27;
true

# An invalid record
gap> MitM_OMRecToGAP(rec());
Error: Invalid XML: an object must have a name
gap> MitM_OMRecToGAPFunc(rec());
Error: Invalid XML: an object must have a name

#
gap> v := MitM_XMLToOMRec("<OMV name=\"banana\" />");;
gap> MitM_OMRecToGAP(v);
"banana"

# Hack
# gap> MitM_OMRecToGAPFunc(v);
# "banana"

#
gap> v := MitM_XMLToOMRec("<OMI>-x3421AB</OMI>");;
gap> MitM_OMRecToGAP(v);
-3416491
gap> MitM_OMRecToGAPFunc(v);
-3416491

# floats
gap> v := MitM_XMLToOMRec("<OMF dec=\"32.02\" />");;
gap> MitM_OMRecToGAP(v);
32.02
gap> MitM_OMRecToGAPFunc(v);
32.02
gap> v := MitM_XMLToOMRec("<OMF hex=\"0123456789ABCDEF\" />");;
gap> MitM_OMRecToGAP(v);
Error, Unsupported encoding for OMF
gap> MitM_OMRecToGAPFunc(v);
Error, Unsupported encoding for OMF

# OMB
gap> v := MitM_XMLToOMRec("<OMB>cheesyworldhello</OMB>");;
gap> MitM_OMRecToGAP(v);
"cheesyworldhello"

# To be fixed later
# gap> MitM_OMRecToGAPFunc(v);
# "cheesyworldhello"
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
gap> MitM_OMRecToGAPFunc(v)(1) = "bana";
true

# OMS
gap> v := MitM_XMLToOMRec("<OMS cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v);
Error, cdbase must be https://www.gap-system.org/mitm/
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"banana\" cd=\"you\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v);
Error, cdbase must be https://www.gap-system.org/mitm/
gap> MitM_OMRecToGAPFunc(v);
Error, cdbase must be https://www.gap-system.org/mitm/
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="lib" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v);
Error, symbol "GroXYZup" not known
gap> v := MitM_XMLToOMRec("""<OMS cdbase="https://www.gap-system.org/mitm/"
>                                 cd="abc" name="GroXYZup" />""");;
gap> MitM_OMRecToGAP(v);
Error, cd "abc" not supported
gap> MitM_OMRecToGAPFunc(v);
Error, cd "abc" not supported
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib2\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v);
Error, cd "lib2" not supported
gap> MitM_OMRecToGAPFunc(v);
Error, cd "lib2" not supported
gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"LadIDaPerMuTAtIOnSuPeRfAiL\" />");;
gap> MitM_OMRecToGAP(v);
Error, symbol "LadIDaPerMuTAtIOnSuPeRfAiL" not known
gap> MitM_OMRecToGAPFunc(v);
Error, Variable: 'LadIDaPerMuTAtIOnSuPeRfAiL' must have a value
Error, Could not evaluate string.

gap> v := MitM_XMLToOMRec("<OMS cdbase=\"https://www.gap-system.org/mitm/\" cd=\"lib\" name=\"Group\" />");;
gap> Group = MitM_OMRecToGAP(v);
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
gap> MitM_OMRecToGAP(v)((1,2,3),(2,3)) = Group((1,2,3),(2,3));
true
gap> MitM_OMRecToGAPFunc(v)((1,2,3),(2,3)) = Group((1,2,3),(2,3));
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
gap> MitM_OMRecToGAP(v);
Error, Only the lambda binding is implemented

#
