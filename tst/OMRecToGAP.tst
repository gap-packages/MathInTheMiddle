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
