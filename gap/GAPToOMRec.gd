# Get a record from an object
DeclareAttribute("MitM_GAPToOMRec", IsObject);

# Wrap an object inside an OMOBJ
DeclareGlobalFunction("MitM_OMRecToOMOBJRec");

# Shortcut to make a simple OMS from a GAP object
DeclareGlobalFunction("MitM_SimpleOMS");

# Do everything and print an object's XML
DeclareGlobalFunction("MitM_Print");
