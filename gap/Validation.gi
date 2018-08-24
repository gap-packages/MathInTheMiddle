# TODO: OMOBJ
# TODO: id attributes of type xsd:ID

BindGlobal("MitM_rnams", ["name", "attributes", "content"]);

BindGlobal("MitM_ValidXSD", rec());

MitM_ValidXSD.NCName := function(str)
    local char;
    if IsEmpty(str) then
        return "must not be the empty string";
    elif IsDigitChar(str[1]) or str[1] = '-' or str[1] = '.' then
        return "must start with a letter or underscore";
    fi;
    for char in str do
        if not (IsAlphaChar(char) or IsDigitChar(char)
                or char = '_' or char = '-' or char = '.') then
            return Concatenation("must not contain the character \"",
                                 String(char), "\"");
        fi;
    od;
    return true;
end;

MitM_ValidXSD.AnyURI := function(str)
    # Validating URIs is difficult, but we may want to do it in the future
    return MitM_ValidXSD.NCName(str);
end;
     
BindGlobal("MitM_ValidAttr",
rec(
     OMS := rec(name := MitM_ValidXSD.NCName,
                cd := MitM_ValidXSD.NCName,
                cdbase := MitM_ValidXSD.AnyURI),
     OMV := rec(name := MitM_ValidXSD.NCName),
     OMI := rec(),
     OMB := rec(),
     OMSTR := rec(),
     OMF := rec(dec := function(str)
                   if str = "INF" or str = "-INF" or str = "NaN" then
                       return true;
                   elif Float(str) = fail then
                       return Concatenation(str, " is not a valid float");
                   fi;
                   return true;
                end,
                hex := function(str)
                    local valid_chars, char;
                    if Length(str) <> 16 then
                        return "must be 16 characters long";
                    fi;
                    valid_chars := "0123456789ABCDEF";
                    for char in str do
                        if not char in valid_chars then
                            return "contains non-hex character";
                        fi;
                    od;
                    return true;
                end),
     OMA := rec(),
     OMBIND := rec(),
     OME := rec(),
     OMATTR := rec(),
     OMR := rec()
));

BindGlobal("MitM_RequiredAttr",
rec(
     OMS := ["cd", "name"],
     OMV := ["name"],
     OMI := [],
     OMB := [],
     OMSTR := [],
     OMF := [], # TODO: dec or hex, but not both
     OMA := [],
     OMBIND := [],
     OME := [],
     OMATTR := [],
     OMR := []
));

BindGlobal("MitM_ValidCont",
rec(
     OMS := function(content)
         if not IsEmpty(content) then
             return "OMS object must have empty content";
         fi;
         return true;
     end,

     OMV := function(content)
         if not IsEmpty(content) then
             return "OMV object must have empty content";
         fi;
         return true;
     end,

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

     OMF := function(content)
         if not IsEmpty(content) then
             return "OMF object must have empty content";
         fi;
         return true;
     end,

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
                return StringFormatted("{} attribute of {} object: {}",
                                       attr, tree.name, result);
            fi;
        od;
    else
        if not IsEmpty(MitM_RequiredAttr.(tree.name)) then
            return StringFormatted("{} objects must have the {} attribute",
                                   tree.name, MitM_RequiredAttr.(tree.name)[1]);
        fi;
    fi;

    # Check required attributes
    for attr in MitM_RequiredAttr.(tree.name) do
        if not attr in RecNames(tree.attributes) then
            return Concatenation(tree.name, " objects must have the ",
                                 attr, " attribute");
        fi;
    od;

    # Validate the content
    if IsBound(tree.content) then
        return MitM_ValidCont.(tree.name)(tree.content);
    else
        return MitM_ValidCont.(tree.name)([]);
    fi;
end);
