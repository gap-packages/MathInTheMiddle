InstallGlobalFunction(MitM_OMRecToXML,
function(r)
    local str, rnam, attributes, content, item;
    str := StringFormatted("<{}", MitM_Tag(r));
    attributes := MitM_Attributes(r);
    if attributes <> fail then
        for rnam in Set(RecNames(attributes)) do
            Append(str, StringFormatted(" {}=\"{}\"",
                                        rnam, attributes.(rnam)));
        od;
    fi;
    if MitM_Content(r) <> fail then
        Append(str, ">");
        content := MitM_Content(r);
        if Length(content) = 1 and not IsRecord(content[1]) then
            Append(str, String(content[1]));
        elif Length(content) > 0 then
            Append(str, "\n");
            for item in content do
                if IsRecord(item) then
                    Append(str, MitM_OMRecToXML(item));
                else
                    # This might not be possible with a proper OMRec, since a
                    # string always appears inside a pair of tags, on its own.
                    Append(str, String(item));
                fi;
                Append(str, "\n");
            od;
        fi;
        Append(str, StringFormatted("</{}>", MitM_Tag(r)));
    else
        Append(str, " />");
    fi;
    return str;
end);
