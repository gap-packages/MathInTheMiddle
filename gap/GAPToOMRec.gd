# Get a record from an object
DeclareAttribute("MitM_GAPToOMRec", IsObject);

# Wrap an object inside an OMOBJ
DeclareGlobalFunction("MitM_OMRecToOMOBJRec");

# Shortcut to make a simple OMS from a GAP object
DeclareGlobalFunction("MitM_SimpleOMS");

# Override GAP's Objectify to store how an
# object was constructed.
DeclareGlobalFunction("MitM_FindConstructors");

# For Objects that are not attribute storing, we
# keep a hash table of constructor info.
DeclareGlobalVariable("MitM_ObjectConstructorStore");

