#
# MathInTheMiddle: Math-in-the-Middle functionality for GAP
#
# Declarations
#

BindGlobal("MitM_cdbase",
           "https://www.gap-system.org/mitm/");

#! @Description
#! Start the MitM SCSCP Server
DeclareGlobalFunction("StartMitMServer");

#! @Description
#! Handle an SCSCP connection
DeclareGlobalFunction("MitM_SCSCPHandler");

BindGlobal("MitM_DefaultServerOptions", rec(
    hostname := "localhost",
    port := 26133,
    queue := 5 )
);

DeclareInfoClass("InfoMitMServer");

