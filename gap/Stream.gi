InstallGlobalFunction(MitM_SCSCPServerHandshake,
function(in_stream, out_stream)
    local msg, get, pi, client_versions, versions, version;
    # Send connection initiation message (5.1.1)
    msg := Concatenation("<?scscp service_name=\"{}\" service_version=\"{}\" ",
                         "service_id=\"{}\" scscp_versions=\"{}\" ?>");
    msg := StringFormatted(msg,
                           "gap", "4.10dev", String(IO_getpid()),
                           JoinStringsWithSeparator(MitM_SCSCPVersions, " "));
    WriteLine(out_stream, msg);
    # TODO: we are required to support SCSCP v1.0

    # Version negotiation (5.1.2)
    get := MitM_ReadToPI(in_stream);
    if get.success = false then
        Info(InfoMitMSCSCP, 2,
             "Version negotiation failed: no version request from client");
        return fail;
    fi;
    pi := Concatenation("<", get.pi, ">");
    pi := GetSTag(pi, 2);
    if not IsBound(pi.attributes.version) then
        Info(InfoMitMSCSCP, 2,
             "Version negotiation failed: no version request from client");
        return fail;
    fi;
    client_versions := SplitString(pi.attributes.version, "", " \n\r\t");
    versions := Filtered(client_versions, v -> v in MitM_SCSCPVersions);
    if IsEmpty(versions) then
        Info(InfoMitMSCSCP, 2,
             Concatenation("Version negotiation failed: client requested ",
                           Concatenation(client_versions),
                           ", none of which is supported"));
        WriteLine(out_stream,
                  "<?scscp quit reason=\"not supported version\" ?>");
        return fail;
    fi;
    version := Maximum(versions); # choose the highest lexicographically
    WriteLine(out_stream, Concatenation("<?scscp version=\"",
                                        version, "\" ?>"));
    # Successful handshake, now ready for procedure calls
    return version;
end);

InstallGlobalFunction(MitM_SCSCPClientHandshake,
function(in_stream, out_stream)
    local get, pi, start, finish;
    # Get connection initiation message (5.1.1)
    get := MitM_ReadToPI(in_stream);
    if not get.success then
        Info(InfoMitMSCSCP, 2,
             "Initiation failed: no processing instruction received");
        return false;
    fi;
    # Use XML parser to get at the information
    pi := Concatenation("<", get.pi, ">");
    pi := GetSTag(pi, 2);
    if pi.name <> "scscp" then
        Info(InfoMitMSCSCP, 2,
             "Initiation failed: no SCSCP instruction received");
        return false;
    elif Set(RecNames(pi.attributes)) <> ["scscp_versions",
                                          "service_id",
                                          "service_name",
                                          "service_version"] then
        Info(InfoMitMSCSCP, 2,
             "Initiation failed: bad connection initiation message received");
        return false;
    elif not "1.3" in SplitString(pi.attributes.scscp_versions, "", " ") then
        # TODO: we are required to support SCSCP v1.0
        Info(InfoMitMSCSCP, 2,
             "Initiation failed: server offers no SCSCP version we know");
        return false;
    fi;

    # Version negotiation (5.1.2)
    WriteLine(out_stream, "<?scscp version=\"1.3\" ?>");
    get := MitM_ReadToPI(in_stream);
    if not get.success then
        Info(InfoMitMSCSCP, 2,
             "Version negotiation failed: no valid response from server");
        return false;
    elif PositionSublist(get.pi, "quit") <> fail then
        Info(InfoMitMSCSCP, 2,
             "Version negotiation failed: server quit with following message:");
        start := Position(get.pi, '\"');
        finish := Position(get.pi, '\"', start);
        Info(InfoMitMSCSCP, 2, get.pi{[start..finish]});
        return false;
    fi;
    pi := Concatenation("<", get.pi, ">");
    pi := GetSTag(pi, 2);
    if not IsBound(pi.attributes.version) then
        Info(InfoMitMSCSCP, 2,
             "Version negotiation failed: server sent no version number");
        return false;
    elif pi.attributes.version <> "1.3" then
        Info(InfoMitMSCSCP, 2,
             Concatenation("Version negotiation failed: server chose version ",
                           pi.attributes.version,
                           ", which is not supported"));
        return false;
    fi;

    # Successful handshake, now ready for procedure calls
    return true;
end);

InstallGlobalFunction(MitM_ReadSCSCP,
function(stream)
    local get, pi, r;
    # Get first processing instruction
    get := MitM_ReadToPI(stream);
    # It should be an SCSCP start instruction
    if not get.success then
        return fail;
    fi;
    pi := get.pi;
    pi := SplitString(pi, "", " \n\r\t");
    if pi[1] <> "scscp" or pi[2] <> "start" or Length(pi) > 2 then
        return fail;
    fi;
    # Read to the end instruction
    get := MitM_ReadToPI(stream);
    if not get.success then
        return fail;
    fi;
    pi := get.pi;
    pi := SplitString(pi, "", " \n\r\t");
    if pi[1] <> "scscp" or pi[2] <> "end" or Length(pi) > 2 then
        return fail;
    fi;
    # The in-between stuff should be an OMOBJ
    r := MitM_XMLToOMRec(get.pre);
    if r.name <> "OMOBJ" then
        return fail;
    fi;
    # Convert to a GAP object
    return MitM_OMRecToGAP(r);
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
