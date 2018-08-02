

InstallMethod( MitM_EncodeToJsonMLStream, "for a stream and an integer",
               [ IsOutputStream, IsInt ],
function( stream, int )
    GapToJsonStream( [ "OMI", String(int) ] );
end);

InstallMethod( MitM_EncodeToJsonMLStream, "for a stream and a string",
               [ IsOutputStream, IsString ],
function( stream, str )
    GapToJsonStream( [ "OMS", String(str) ] );
end);


