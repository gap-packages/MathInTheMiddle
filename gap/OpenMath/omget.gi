#############################################################################
##
#W  omget.g             OpenMath Package               Andrew Solomon
#W                                                     Marco Costantini
##
#Y  Copyright (C) 1999, 2000, 2001, 2006
#Y  School Math and Comp. Sci., University of St.  Andrews, Scotland
#Y  Copyright (C) 2004, 2005, 2006 Marco Costantini
##
##  OMGetObject reads an OpenMath object from an input stream and returns
##  a GAP object. EvalOMString is an analog of EvalString for a string which
##  contains an OpenMath object.
##


#############################################################################
##
#F  OMGetObject( <stream> )
##
##  <stream> is an input stream with an OpenMath object on it.
##  Takes precisely one object off <stream> (using PipeOpenMathObject)
##  and parses it into an XML record.
##
InstallGlobalFunction(OMGetObject, function( stream )
    local fromgap, firstbyte,
          success; # whether PipeOpenMathObject worked

    if IsClosedStream( stream )  then
        Error( "closed stream" );
    elif IsEndOfStream( stream )  then
        Error( "end of stream" );
    fi;

    firstbyte := ReadByte(stream);

    if firstbyte = 24 then
        # Binary encoding
        return GetNextObject( stream, firstbyte );
    else
        # XML encoding
        fromgap := "";
        # Get one OpenMath object from 'stream' and put into 'fromgap',
        # using PipeOpenMathObject

        success := PipeOpenMathObject( stream, fromgap, firstbyte );

        if success <> true  then
            Error( "OpenMath object not retrieved" );
        fi;

        return OMgetObjectXMLTree(fromgap);
    fi;
end);

#############################################################################
##
#F  EvalOMString( <omstr> )
##
##  This function is an analog of EvalString for a string which contains an
##  OpenMath object.
##
InstallGlobalFunction( EvalOMString, function( omstr )
local s, obj;
    s := InputTextString( omstr );
    obj := OMGetObject( s );
    CloseStream( s );
    return obj;
end);
