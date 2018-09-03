# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);
Integers[x1,x2,x3,x4]
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(R)) = R;
true

# Permutations
gap> MitM_OMRecToGAP(MitM_GAPToOMRec( (1,5,4) )) = (1,5,4);
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(D)) = D;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(Q)) = Q;
true

# An integer
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(27)) = 27;
true
