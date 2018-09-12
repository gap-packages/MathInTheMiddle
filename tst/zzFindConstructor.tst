#
gap> SetInfoLevel(InfoWarning, 0);; SetInfoLevel(InfoGlobal, 0);;
gap> MitM_FindConstructors();;
gap> G := Group((1,2,3),(4,5));;
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(G)).result = G;
true
gap> R := RightCoset(G, (1,2));;
gap> MitM_OMRecToGAP(MitM_GAPToOMRec(R)).result = R;
true

#
