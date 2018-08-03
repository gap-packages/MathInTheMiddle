#############################################################################
##
#W  xmltree.gd          OpenMath Package              Andrew Solomon
#W                                                    Marco Costantini
##
#Y  Copyright (C) 1999, 2000, 2001, 2006
#Y  School Math and Comp. Sci., University of St.  Andrews, Scotland
#Y  Copyright (C) 2004, 2005, 2006 Marco Costantini
##
##  The main function in this file converts the OpenMath XML into a tree
##  (using the function ParseTreeXMLString from package GapDoc) and
##  parses it.
##

BindGlobal( "OMTempVars",
	        rec( OMBIND := rec()
               , OMREF := rec() ) );
MakeReadWriteGlobal("OMTempVars"); 

BindGlobal( "OMIsNotDummyLeaf",
            node -> not (node.name in ["PCDATA", "XMLCOMMENT"] ) );

DeclareGlobalVariable("OMObjects");

DeclareGlobalFunction("OMParseXmlObj");
DeclareGlobalFunction("OMgetObjectXMLTree");
DeclareGlobalFunction("OMParseTreeXMLString");
