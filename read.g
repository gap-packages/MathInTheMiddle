#
# MathInTheMiddle: Math-in-the-Middle functionality for GAP
#
# Reading the implementation part of the package.
#

# ReadPackage("MathInTheMiddle", "gap/SCSCP/utils.gi");

ReadPackage("MathInTheMiddle", "gap/OpenMath/binread.gi");
ReadPackage("MathInTheMiddle", "gap/OpenMath/pipeobj.gi");

ReadPackage("MathInTheMiddle", "gap/OpenMath/xmltree.gi");
ReadPackage("MathInTheMiddle", "gap/OpenMath/omget.gi");
ReadPackage("MathInTheMiddle", "gap/OpenMath/omput.gi");
# ReadPackage("MathInTheMiddle", "gap/OpenMath/omputxml.gi");

# TCP Streams
ReadPackage("MathInTheMiddle", "gap/SCSCP/xstream.gi");

# ReadPackage("MathInTheMiddle", "gap/SCSCP/server.gi");

# ReadPackage( "MathInTheMiddle", "gap/Server.gi");
# ReadPackage( "MathInTheMiddle", "gap/Export.gi");
ReadPackage( "MathInTheMiddle", "gap/MathInTheMiddle.gi");

ReadPackage( "MathInTheMiddle", "gap/ToStream.gi");
ReadPackage( "MathInTheMiddle", "gap/FromStream.gi");
