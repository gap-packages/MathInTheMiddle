# Input error
gap> MitM_XMLToOMRec("<OMI>42</OMI> <OMI>44</OMI>");
Error, There are several top-level objects

# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);
Integers[x1,x2,x3,x4]
gap> tree := MitM_GAPToOMRec(R);;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# Permutations
gap> tree := MitM_GAPToOMRec( (1,5,4) );;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> tree := MitM_GAPToOMRec(D);;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# Quaternion groups
gap> Q := QuaternionGroup(IsPermGroup, 8);;
gap> IsQuaternionGroup(Q);
true
gap> tree := MitM_GAPToOMRec(Q);;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# An integer
gap> tree := MitM_GAPToOMRec(27);;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# Polynomials
gap> p := PolynomialByExtRep( RationalFunctionsFamily(FamilyObj(1)),          
>                             [[2,1], 1, [1,1,3,1], 3] );
3*x1*x3+x2
gap> tree := MitM_GAPToOMRec(p);;
gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree)) = tree;
true

# Two strings together in a list
# Note: I'm not sure this will ever come up in GAP or OpenMath, and perhaps it
#       should be prohibited.  XMLToOMRec interprets it as a single string.
# gap> tree := rec(name := "OMTWOSTRINGS", content := ["hello", "world"]);
# rec( content := [ "hello", "world" ], name := "OMTWOSTRINGS" )
# gap> MitM_XMLToOMRec(MitM_OMRecToXML(tree));
# rec( content := [ "\nhello\nworld\n" ], name := "OMTWOSTRINGS" )

# Comments
gap> MitM_XMLToGAP("<OMI> 3 <!-- hello world -->2 </OMI>").result;
32
