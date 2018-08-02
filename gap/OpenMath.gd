#!
#! @Chapter OpenMath
#!
#! We define an abstract syntax representation of openmath objects.
#!
DeclareCategory("IsOpenMath", IsObject);

BindGlobal( "OpenMathFamily", NewFamily("OpenMathFamily") );
DeclareRepresentation("IsOpenMathRep", IsOpenMath and IsPositionalObjectRep, []);
BindGlobal( "OpenMathType", NewType(OpenMathFamily, IsOpenMathRep));

DeclareProperty("IsOpenMathOMS", IsOpenMath);
DeclareProperty("IsOpenMathOMV", IsOpenMath);
DeclareProperty("IsOpenMathOMI", IsOpenMath);
DeclareProperty("IsOpenMathOMB", IsOpenMath);
DeclareProperty("IsOpenMathOMSTR", IsOpenMath);
DeclareProperty("IsOpenMathOMF", IsOpenMath);
DeclareProperty("IsOpenMathOMA", IsOpenMath);
DeclareProperty("IsOpenMathOMBIND", IsOpenMath);
DeclareProperty("IsOpenMathOMVAR", IsOpenMath);
DeclareProperty("IsOpenMathOMATTR", IsOpenMath);
DeclareProperty("IsOpenMathOMATP", IsOpenMath);
DeclareProperty("IsOpenMathOMForeign", IsOpenMath);

DeclareAttribute("ContentDictBase", IsOpenMath);
DeclareAttribute("ContentDict", IsOpenMath);
DeclareAttribute("Name", IsOpenMath);

DeclareGlobalFunction("OMA");




DeclareOperation("MitM_EncodeToJsonStream", [ IsOutputStream, IsObject ]);
DeclareOperation("MitM_EncodeToJsonString", [ IsObject ] );


