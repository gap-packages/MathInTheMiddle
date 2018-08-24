# Get a record from an object
DeclareAttribute("MitM_GAPToOMRec", IsObject);

# Get a string from a record
DeclareGlobalFunction("MitM_OMRecToXML");

# Shortcut to make a simple OMS from a GAP object
DeclareGlobalFunction("MitM_SimpleOMS");

# Do everything and print an object's XML
DeclareGlobalFunction("MitM_Print");
