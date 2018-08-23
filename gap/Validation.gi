# TODO: OMOBJ
# TODO: id attributes of type xsd:ID

BindGlobal("MitM_rnams", ["name", "attributes", "content"]);

BindGlobal("MitM_ValidAttr",
rec(
     OMS := rec(),
     OMV := rec(),
     OMI := rec(),
     OMB := rec(),
     OMSTR := rec(),
     OMF := rec(),
     OMA := rec(),
     OMBIND := rec(),
     OME := rec(),
     OMATTR := rec(),
     OMR := rec()
));

BindGlobal("MitM_RequiredAttr",
rec(
     OMS := [],
     OMV := [],
     OMI := [],
     OMB := [],
     OMSTR := [],
     OMF := [],
     OMA := [],
     OMBIND := [],
     OME := [],
     OMATTR := [],
     OMR := []
));

BindGlobal("MitM_ValidCont",
rec(
     OMS := function(content) return "not implemented"; end,

     OMV := function(content) return "not implemented"; end,

     OMI := function(content)
         local str, pos, valid_chars;
         if not (Length(content) = 1 and IsString(content[1])) then
             return "OMI object must contain only a string";
         fi;
         str := ShallowCopy(content[1]);
         RemoveCharacters(str, " \n\t\r"); # ignore whitespace
         pos := 1;
         if str[pos] = '-' then
             Remove(str, 1);
         fi;
         if str[pos] = 'x' then
             Remove(str, 1);
             valid_chars := "0123456789ABCDEF";
         else
             valid_chars := "0123456789";
         fi;
         if ForAny(str, char -> not char in valid_chars) or Length(str) = 0 then
             return Concatenation(content[1], " is not an integer");
         fi;
         return true;
     end,

     OMB := function(content) return "not implemented"; end,

     OMSTR := function(content) return "not implemented"; end,

     OMF := function(content) return "not implemented"; end,

     OMA := function(content) return "not implemented"; end,

     OMBIND := function(content) return "not implemented"; end,

     OME := function(content) return "not implemented"; end,

     OMATTR := function(content) return "not implemented"; end,

     OMR := function(content) return "not implemented"; end
));

InstallGlobalFunction(MitM_IsValidOMRec,
function(tree)
    local rnam, attr, result;
    # Check that this is a proper object
    if not IsRecord(tree) then
        return "<tree> must be an OM record";
    elif not IsBound(tree.name) then
        return "Invalid XML: an object must have a name";
    elif not tree.name in RecNames(MitM_ValidAttr) then
        return Concatenation(tree.name, " is not a valid OM object name");
    fi;
    for rnam in RecNames(tree) do
        if not rnam in MitM_rnams then
            return Concatenation("Invalid XML: ", rnam, " should not exist");
        fi;
    od;

    # Validate the attributes
    if IsBound(tree.attributes) then
        for attr in RecNames(tree.attributes) do
            if not attr in RecNames(MitM_ValidAttr.(tree.name)) then
                return Concatenation(attr, " is not a valid attribute of ",
                                     tree.name, " objects");
            fi;
            result := MitM_ValidAttr.(tree.name).(attr)(tree.attributes.(attr));
            if result <> true then
                return result;
            fi;
        od;
    else
        if not IsEmpty(MitM_RequiredAttr.(tree.name)) then
            return Concatenation(tree.name, " objects must have the ",
                                 MitM_RequiredAttr.(tree.name)[1], "attribute");
        fi;
    fi;

    # Check required attributes
    for attr in MitM_RequiredAttr.(tree.name) do
        if not attr in tree.attributes.(attr) then
            return Concatenation(tree.name, " objects must have the ",
                                 attr, "attribute");
        fi;
    od;

    # Validate the content
    return MitM_ValidCont.(tree.name)(tree.content);
end);
