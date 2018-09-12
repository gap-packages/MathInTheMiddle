#
gap> MitM_TypesToJson("types.json");;
exporting operations...   done
exporting global functions...   done
collecting global variable references...   done
gap> json := JsonStreamToGap(InputTextFile("types.json"));;

#
