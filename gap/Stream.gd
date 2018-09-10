#! @Arguments stream
#! @Returns
#!   a record
#! @Description
#!   Attempts to read a single OpenMath object from an input stream.  The object
#!   should be enclosed in <?scscp start ?> and <?scscp end ?> tags.
#!   As output, this function returns a record containing some of the following
#!   components, which describe the outcome of the conversion attempt:
#!     * <C>success</C>: a boolean describing whether the request was
#!       successfully received by the server;
#!     * <C>result</C>: body of the information sent by the server (only if
#!       <C>success = true</C>);
#!     * <C>error</C>: human-readable string saying what went wrong (only if
#!       <C>success = false</C>).
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

#! @Arguments in_stream, out_stream
#! @Returns
#!   a string or <K>fail</K>
#! @Description
#!   Accepts an SCSCP connection from a client, by receiving messages from the
#!   client using <A>in_stream</A> and sending messages to the client via
#!   <A>out_stream</A>.  Returns a string containing the version number if the
#!   connection was initiated successfully, and <K>fail</K> otherwise.  This
#!   handshaking protocol is described in Section 5.1 of the SCSCP specification
#!   version 1.3
DeclareGlobalFunction("MitM_SCSCPServerHandshake");

#! @Arguments in_stream, out_stream
#! @Returns
#!   a boolean
#! @Description
#!   Initiates an SCSCP connection with a server, by receiving messages from the
#!   server using <A>in_stream</A> and sending messages to the server via
#!   <A>out_stream</A>.  Returns <K>true</K> if the connection was initiated
#!   successfully, and <K>false</K> otherwise.  This handshaking protocol is
#!   described in Section 5.1 of the SCSCP specification version 1.3
DeclareGlobalFunction("MitM_SCSCPClientHandshake");

BindGlobal("MitM_SCSCPVersions", ["1.3"]);
