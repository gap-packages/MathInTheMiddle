InstallGlobalFunction(MitM_XMLToOMRec,
function(str)
    local tree;
    tree := ParseTreeXMLString(str);
    
    # Strip out unnecessary contents recursively
    tree := MitM_SimplifiedTree(tree);
    
    # Get a single object
    if Length(tree.content) > 1 then
        Error("There are several top-level objects");
    fi;
    tree := tree.content[1];
    
    return tree;
end);

InstallGlobalFunction(MitM_SimplifiedTree,
function(tree)
    local out, item, len, data;
    if tree.name = "PCDATA" then
        # content should be a string
        if IsEmpty(NormalizedWhitespace(tree.content)) then
            return fail;
        fi;
        return tree.content;
    elif tree.name = "XMLCOMMENT" then
        return fail;
    fi;
    out := rec();
    out.name := tree.name;
    if IsBound(tree.attributes) and not IsEmpty(RecNames(tree.attributes)) then
        out.attributes := tree.attributes;
    fi;
    if tree.content <> 0 then
        out.content := [];
        len := 0;
        for item in tree.content do
            # item should be a record
            data := MitM_SimplifiedTree(item);
            if data <> fail then
                if len>0 and IsString(data) and IsString(out.content[len]) then
                    Append(out.content[len], data);
                else
                    len := len + 1;
                    out.content[len] := data;
                fi;
            fi;
        od;
    fi;
    return out;
end);
