# Get a record from an object
DeclareAttribute("MitM_OMRecObj", IsObject);

# Get a string from a record
DeclareGlobalFunction("MitM_StringOMRec");

# Shortcut to make a simple OMS from a GAP object
DeclareGlobalFunction("MitM_SimpleOM");

# Do everything and print an object's XML
DeclareGlobalFunction("MitM_Print");
