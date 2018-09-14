InstallGlobalFunction(MitM_OMRecToXML,
function(r)
    local str, rnam, content, item;
    str := StringFormatted("<{}", r.name);
    if IsBound(r.attributes) then
        for rnam in Set(RecNames(r.attributes)) do
            Append(str, StringFormatted(" {}=\"{}\"", 
                                        rnam, r.attributes.(rnam)));
        od;
    fi;
    if IsBound(r.content) then
        Append(str, ">");
        content := r.content;
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
        Append(str, StringFormatted("</{}>", r.name));
    else
        Append(str, " />");
    fi;
    return str;
end);
