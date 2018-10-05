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

