InstallGlobalFunction(MitM_ReadSCSCP,
function(stream)
    local get, pi;
    # Get first processing instruction
    get := MitM_ReadToPI(stream);
    pi := get.pi;
    # It should be an SCSCP start instruction
    if pi = fail then
        return fail;
    fi;
    pi := SplitString(pi, "", " \n\r\t");
    if pi[1] <> "scscp" or pi[2] <> "start" or Length(pi) > 2 then
        return fail;
    fi;
    # Read to the end instruction
    get := MitM_ReadToPI(stream);
    pi := get.pi;
    if pi = fail then
        return fail;
    fi;
    pi := SplitString(pi, "", " \n\r\t");
    if pi[1] <> "scscp" or pi[2] <> "end" or Length(pi) > 2 then
        return fail;
    fi;
    # Turn the in-between stuff into an obj
    return MitM_OMRecToGAP(MitM_XMLToOMRec(get.pre));
end);

InstallGlobalFunction(MitM_ReadToPI,
function(stream)
    local pre, len, char, byte, error, lastchar, pi;
    pre := "";
    len := 0;
    char := fail;
    repeat
        byte := ReadByte(stream);
        if byte = fail then
            return rec(success := false, pre := pre,
                       error := "stream ended before an XML PI was found");
        fi;
        lastchar := char;
        char := CharInt(byte);
        len := len + 1;
        pre[len] := char;
    until lastchar = '<' and char = '?';
    Remove(pre);
    Remove(pre);
    pi := "";
    len := 0;
    repeat
        byte := ReadByte(stream);
        if byte = fail then
            return rec(success := false, pre := pre, pi := pi,
                       error := "stream ended in middle of XML PI");
        elif byte = 60 then
            return rec(success := false, pre := pre, pi := pi,
                       error := "'<' character illegal inside XML PI");
        fi;
        lastchar := char;
        char := CharInt(byte);
        len := len + 1;
        if len > 4092 then # max length 4094 including "<?"
            return rec(success := false, pre := pre, pi := pi,
                       error := "XML PI cannot be longer than 4094 characters");
        fi;
        pi[len] := char;
    until lastchar = '?' and char = '>';
    Remove(pi);
    Remove(pi);
    return rec(success := true, pre := pre, pi := pi);
end);
