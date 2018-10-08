#
gap> SetInfoLevel(InfoWarning, 0);; SetInfoLevel(InfoGlobal, 0);; SetInfoLevel(InfoMitMConstructors, 0);;
gap> MitM_FindConstructors();;
gap> G := Group((1,2,3),(4,5));;
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(G)).result = G;
true
gap> R := RightCoset(G, (1,2));;
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(R)).result = R;
true

# Fixed bug related to empty strings
gap> G := First(NormalSubgroups(SymmetricGroup(5)), IsTrivial);
Group(())
gap> MitM_OMRecToGAP(MitM_XMLToOMRec(MitM_OMRecToXML(MitM_GAPToOMRec(G)))) =
> rec(success := true, result := G);
true
