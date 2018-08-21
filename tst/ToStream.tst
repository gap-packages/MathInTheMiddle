# Polynomial rings
gap> R := PolynomialRing(Integers, [ "x1", "x2", "x3", "x4"]);
Integers[x1,x2,x3,x4]
gap> MitM_OMRecObj(R) =
> rec(
>   content :=
>     [
>       rec(
>           attributes :=
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/lib"
>                 , name := "PolynomialRing" ), name := "OMS" ),
>       rec(
>           attributes :=
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/lib"
>                 , name := "Integers" ), name := "OMS" ),
>       rec(
>           content :=
>             [
>               rec(
>                   attributes :=
>                     rec( cd := "prim",
>                       cdbase := "https://www.gap-system.org/mitm/lib",
>                       name := "ListConstr" ), name := "OMS" ),
>               rec( content := [ "x1" ], name := "OMSTR" ),
>               rec( content := [ "x2" ], name := "OMSTR" ),
>               rec( content := [ "x3" ], name := "OMSTR" ),
>               rec( content := [ "x4" ], name := "OMSTR" ) ], name := "OMA" )
>      ], name := "OMA" );
true

# Permutations
gap> MitM_OMRecObj( (1,5,4) ) =
> rec( 
>   content := 
>     [ 
>       rec( 
>           attributes := 
>             rec( cd := "prim", cdbase := "https://www.gap-system.org/mitm/lib"
>                 , name := "PermConstr" ), name := "OMS" ), 
>       rec( 
>           attributes := 
>             rec( cd := "prim", cdbase := "https://www.gap-system.org/mitm/lib"
>                 , name := "ListEncoding" ), name := "OMS" ), 
>       rec( content := [ 5 ], name := "OMI" ), 
>       rec( content := [ 2 ], name := "OMI" ), 
>       rec( content := [ 3 ], name := "OMI" ), 
>       rec( content := [ 1 ], name := "OMI" ), 
>       rec( content := [ 4 ], name := "OMI" ) ], name := "OMA" );
true

# Dihedral groups
gap> D := DihedralGroup(IsPermGroup, 10);;
gap> IsDihedralGroup(D);
true
gap> MitM_OMRecObj(D) =
> rec( 
>   content := 
>     [ 
>       rec( 
>           attributes := 
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/lib",
>               name := "DihedralGroup" ), name := "OMS" ), 
>       rec( 
>           attributes := 
>             rec( cd := "lib", cdbase := "https://www.gap-system.org/mitm/lib",
>               name := "IsPermGroup" ), name := "OMS" ), 
>       rec( content := [ 10 ], name := "OMI" ) ], name := "OMA" );
true

# An integer
gap> MitM_StringOMRec(MitM_OMRecObj(27));
"<OMI>27</OMI>"
