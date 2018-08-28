InstallGlobalFunction(MitM_ReadSCSCPStream,
function(stream)
    local str;
    # Get first processing instruction
    pi := MitM_ReadXMLPIStream(stream);
    # It should be an SCSCP start instruction
    pi := SplitString(pi, "", " \n\r\t");
    
end);

InstallGlobalFunction(MitM_ReadXMLPIStream,
function(stream)
    local lastchar, char, pi, len;
    # Wait for the first tag
    char := fail;
    repeat
        lastchar := char;
        char := CharInt(ReadByte(stream));
        if char = fail then Error("ah"); fi;
    until lastchar = '<' and char = '?';
    pi := "";
    len := 0;
    repeat
        char := CharInt(ReadByte(stream));
        len := len + 1;
        pi[len] := char;
    until char = '?';
    if CharInt(ReadByte(stream)) = '>' then
        Remove(pi);
        return pi;
    else
        return "misplaced '?' symbol";
    fi;
end);
