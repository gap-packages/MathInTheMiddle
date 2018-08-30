#! @Arguments stream
#! @Returns
#!   an object or <K>fail</K>
#! @Description
#!   Attempts to read a single OpenMath object from an input stream.  The object
#!   should be enclosed in <?scscp start ?> and <?scscp end ?> tags.  Returns
#!   the object that was read, or <K>fail</K> if the stream was invalid.
DeclareGlobalFunction("MitM_ReadSCSCP");

#! @Arguments stream
#! @Returns
#!   a record
#! @Description
#!   Reads a stream up to and including an XML processing instruction (PI).
#!   Returns a record with the following components:
#!     * <K>success</K>. a bool indicating whether an instruction was found;
#!     * <K>pre</K>, a string containing the content read before the PI;
#!     * <K>pi</K>, the contents of the PI, excluding "<?" and "?>";
#!     * <K>error</K>, a string saying what went wrong, if anything.
DeclareGlobalFunction("MitM_ReadToPI");
