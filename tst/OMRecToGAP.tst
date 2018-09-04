# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);;
gap> r := MitM_GAPToOMRec(R);;
gap> MitM_OMRecToGAP(r) = R;
true
gap> EvalString(MitM_OMRecToGAPFunc(r)) = R;
true

# Permutations
gap> MitM_OMRecToGAP(MitM_GAPToOMRec( (1,5,4) )) = (1,5,4);
true
gap> EvalString( MitM_OMRecToGAPFunc( MitM_GAPToOMRec( (1,5,4) ) ) )  = (1,5,4);
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(D)) = D;
true
gap> EvalString(MitM_OMRecToGAPFunc(MitM_GAPToOMRec(D))) = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(Q)) = Q;
true
gap> EvalString(MitM_OMRecToGAPFunc(MitM_GAPToOMRec(Q))) = Q;
true

# An integer
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(27)) = 27;
true
gap> EvalString(MitM_OMRecToGAPFunc(MitM_GAPToOMRec(27))) = 27;
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
gap> MitM_OMRecToGAPFunc(v);
"banana"

#
gap> v := MitM_XMLToOMRec("<OMI>-x3421AB</OMI>");;
gap> MitM_OMRecToGAP(v);
-3416491
gap> MitM_OMRecToGAPFunc(v);
"-3416491"

# floats
gap> v := MitM_XMLToOMRec("<OMF dec=\"32.02\" />");;
gap> MitM_OMRecToGAP(v);
32.02
gap> MitM_OMRecToGAPFunc(v);
"32.020000000000003"
gap> v := MitM_XMLToOMRec("<OMF hex=\"0123456789ABCDEF\" />");;
gap> MitM_OMRecToGAP(v);
Error, Unsupported encoding for OMF
gap> MitM_OMRecToGAPFunc(v);
Error, Unsupported encoding for OMF

#
