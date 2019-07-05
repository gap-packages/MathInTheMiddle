#
# MathInTheMiddle: Math-in-the-Middle functionality for GAP
#
# Declarations
#

BindGlobal("MitM_cdbase",
           "https://www.gap-system.org/mitm/");


DeclareGlobalVariable("MitM_SCSCPHandlers");

DeclareGlobalFunction("MitM_HandleSCSCP");

DeclareGlobalFunction("MitM_TerminateProcedure");
DeclareGlobalFunction("MitM_CompleteProcedure");

#! @Description
#! Start the MitM SCSCP Server
DeclareGlobalFunction("StartMitMServer");

#! @Description
#! Handle an SCSCP connection
DeclareGlobalFunction("MitM_SCSCPHandler");

#! @Description
#! Connect to an MitM server, and return a stream
DeclareGlobalFunction("StreamToMitMServer");

#! @Description
#! Send a GAP object to an MitM server, via a stream
DeclareGlobalFunction("SendObjToMitMServer");

#! @Arguments obj
#! @Returns
#!   an OMRec object
#! @Description
#!   If <A>obj</A> is an OMRec object (which may be an OMA describing a function
#!   call), this function returns an OMRec which describes a procedure call
#!   (4.1.1 in the SCSCP specification).
DeclareGlobalFunction("MitM_ProcedureCall");

DeclareGlobalFunction("GetAllowedHeads");

BindGlobal("MitM_DefaultServerOptions", rec(
    hostname := "localhost",
    port := 26133,
    queue := 5 )
);

DeclareInfoClass("InfoMitMObjectify");
DeclareInfoClass("InfoMitMServer");
DeclareInfoClass("InfoMitMConstructors");

# TODO: During Development we want this to be verbose
SetInfoLevel(InfoMitMObjectify, 15);
SetInfoLevel(InfoMitMServer, 15);
SetInfoLevel(InfoMitMConstructors, 15);

