BindGlobal("MitM_rnams", ["name", "attributes", "content"]);

# OM elements - known as "omel" in the specification
BindGlobal("MitM_OMel", [ "OMS", "OMV", "OMI", "OMB", "OMSTR", "OMF",
                          "OMA", "OMBIND", "OME", "OMATTR", "OMR"]);

#
# ValidXSD: a collection of functions to check some XML string types
#
BindGlobal("MitM_ValidXSD", rec());

MitM_ValidXSD.Empty := function(str)
    if not IsEmpty(str) then
        return "must be empty";
    fi;
    return true;
end;

MitM_ValidXSD.Text := function(str)
    if '<' in str then
        return "XML strings cannot contain '<'";
    elif Number(str, c -> c = '&') > Number(str, c -> c = ';') then
        return "there is a '&' character without a closing ';'";
    fi;
    # Perhaps we could check some other simple XML things?
    return true;
end;

MitM_ValidXSD.NCName := function(str)
    local result, char;
    result := MitM_ValidXSD.Text(str);
    if result <> true then
        return result;
    elif IsEmpty(str) then
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

# Checking ID uniqueness is difficult, but we may want to do it in the future
MitM_ValidXSD.ID := MitM_ValidXSD.Text;

# Validating URIs is difficult, but we may want to do it in the future
MitM_ValidXSD.AnyURI := MitM_ValidXSD.Text;

MitM_ValidXSD.Base64Binary := function(str)
    local len, nreq, i;
    str := ShallowCopy(str);
    RemoveCharacters(str, " \n\t\r"); # ignore whitespace
    len := Length(str);
    if len mod 4 <> 0 then
        return "must have length divisible by 4";
    fi;
    nreq := 0;
    if str[len] = '=' then
        nreq := 1;
        if str[len - 1] = '=' then
            nreq := 2;
            if not str[len - 2] in "AQgw" then
                return "one of [AQgw] must come before '=='";
            fi;
        elif not str[len - 1] in "AEIMQUYcgkosw048" then
            return "one of [AEIMQUYcgkosw048=] must come before '='";
        fi;
    fi;
    for i in [1 .. len - nreq] do
        if str[i] = '=' then
            return "only 1 or 2 '=' characters allowed, and only at the end";
        elif not (IsAlphaChar(str[i]) or IsDigitChar(str[i])
                  or str[i] = '+' or str[i] = '/') then
            return Concatenation("cannot contain character '", str{[i]}, "'");
        fi;
    od;
    return true;
end;

#
# ValidAttr: each object type's valid attributes,
#            along with functions to check their values
#
BindGlobal("MitM_ValidAttr",
rec(
     OMOBJ := rec(cdbase := MitM_ValidXSD.AnyURI,
                  version := MitM_ValidXSD.Text),
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
                    local valid_chars, char, err;
                    if Length(str) <> 16 then
                        return "must be 16 characters long";
                    fi;
                    valid_chars := "0123456789ABCDEF";
                    for char in str do
                        if not char in valid_chars then
                            err := "contains non-hex character '";
                            Add(err, char);
                            Add(err, ''');
                            if char in "abcdef" then
                                Append(err, " (not capital)");
                            fi;
                            return err;
                        fi;
                    od;
                    return true;
                end),
     OMA := rec(cdbase := MitM_ValidXSD.AnyURI),
     OMBIND := rec(cdbase := MitM_ValidXSD.AnyURI),
     OME := rec(),
     OMATTR := rec(cdbase := MitM_ValidXSD.AnyURI),
     OMR := rec(),
     OMBVAR := rec(),
     OMATP := rec(cdbase := MitM_ValidXSD.AnyURI),
     common := rec(id := MitM_ValidXSD.ID)
));

#
# RequiredAttr: a list of required attributes for each object type
#
BindGlobal("MitM_RequiredAttr",
rec(
     OMOBJ := [],
     OMS := ["cd", "name"],
     OMV := ["name"],
     OMI := [],
     OMB := [],
     OMSTR := [],
     OMF := [],
     OMA := [],
     OMBIND := [],
     OME := [],
     OMATTR := [],
     OMR := [],
     OMBVAR := [],
     OMATP := []
));

#
# ValidCont: a function to check content for each object type
#
BindGlobal("MitM_ValidCont",
rec(
     OMOBJ := function(content)
       if Length(content) <> 1 then
         return "must be precisely one object";
       elif not (MitM_OMRec(content[1]) and MitM_Tag(content[1]) in MitM_OMel) then
         return "must be an OM element";
       fi;
       return MitM_IsValidOMRec(content[1]);
     end,

     OMS := MitM_ValidXSD.Empty,

     OMV := MitM_ValidXSD.Empty,

     OMI := function(content)
         local str, pos, valid_chars;
         if not (Length(content) = 1 and IsString(content[1])) then
             return "must be only a string";
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

     OMB := function(content)
         if IsEmpty(content) then
             return true;
         elif not (Length(content) = 1 and IsString(content[1])) then
             return "must be only a string";
         fi;
         return MitM_ValidXSD.Base64Binary(content[1]);
     end,

     OMSTR := function(content)
         if IsEmpty(content) then
             return true;
         elif not (Length(content) = 1 and IsString(content[1])) then
             return "must be only a string";
         fi;
         return MitM_ValidXSD.Text(content[1]);
     end,

     OMF := MitM_ValidXSD.Empty,

     OMA := function(content)
         local item, result;
         if Length(content) = 0 then
             return "must not be empty";
         fi;
         for item in content do
             if not MitM_OMRec(item) then
                 return "must only contain OM elements";
             elif not MitM_Tag(item) in MitM_OMel then
                 return Concatenation("cannot contain ", MitM_Tag(item), " objects");
             fi;
             result := MitM_IsValidOMRec(item);
             if result <> true then
                 return result;
             fi;
         od;
         return true;
     end,

     OMBIND := function(content)
         local item, result;
         if not (Length(content) = 3
                 and ForAll(content, MitM_OMRec)
                 and MitM_Tag(content[1]) in MitM_OMel
                 and MitM_Tag(content[2]) = "OMBVAR"
                 and MitM_Tag(content[3]) in MitM_OMel) then
             return "must be [OM elm, OMBVAR, OM elm] (in that order)";
         fi;
         for item in content do
             result := MitM_IsValidOMRec(item);
             if result <> true then
                 return result;
             fi;
         od;
         return true;
     end,

     OME := function(content) return "not implemented"; end,

     OMATTR := function(content)
         local i, result;
         if Length(content) <> 2 then
             return "must contain precisely two objects";
         elif not (MitM_OMRec(content[1]) and MitM_OMRec(content[1]) = "OMATP") then
             return "first object must be OMATP";
         elif not (MitM_OMRec(content[2]) and MitM_OMRec(content[2]) in MitM_OMel) then
             return "second object must be an OM element";
         fi;
         for i in [1 .. Length(content)] do
             result := MitM_IsValidOMRec(content[i]);
             if result <> true then
                 return result;
             fi;
         od;
         return true;
     end,

     OMR := function(content) return "not implemented"; end,

     OMBVAR := function(content)
         local item, result;
         if IsEmpty(content) then
             return "must not be empty";
         fi;
         for item in content do
             if not (MitM_OMRec(item) and MitM_Tag(item) = "OMV") then
                 return "must only contain OMV objects";
                 # ... or attvar objects in the full spec
             fi;
             result := MitM_IsValidOMRec(item);
             if result <> true then
                 return result;
             fi;
         od;
         return true;
     end,
     
     OMATP := function(content)
         local i, result;
         if Length(content) = 0 then
             return "must not be empty";
         elif Length(content) mod 2 <> 0 then
             return "must contain an even number of objects";
         fi;
         for i in [1, 3 .. Length(content) - 1] do
             if not (MitM_OMRec(content[i]) and MitM_Tag(content[i]) = "OMS") then
                 return StringFormatted("item {} must be an OMS object", i);
             elif not (MitM_OMRec(content[i + 1]) 
                       and MitM_Tag(content[i + 1]) in MitM_OMel) then
                 # TODO: allow OMFOREIGN
                 return StringFormatted("item {} must be an OM element", i + 1);
             fi;
             result := MitM_IsValidOMRec(content[i]);
             if result <> true then
                 return result;
             fi;
             result := MitM_IsValidOMRec(content[i + 1]);
             if result <> true then
                 return result;
             fi;
         od;
         return true;
     end
));

#
# IsValidOMRec: the function we call on an object to check its validity
#
InstallGlobalFunction(MitM_IsValidOMRec,
function(tree)
    local rnam, attr, result;
    # Check that this is a proper object
    if not MitM_OMRec(tree) then
        return "<tree> must be an OM record";
    elif MitM_Tag(tree) = fail then
        return "invalid XML: an object must have a name";
    elif not MitM_Tag(tree) in RecNames(MitM_ValidAttr) then
        return Concatenation(MitM_Tag(tree), " is not a valid OM object name");
    fi;
    for rnam in NamesOfComponents(tree) do
        if not rnam in MitM_rnams then
            return Concatenation("invalid XML: ", rnam, " should not exist");
        fi;
    od;

    # Validate the attributes
    if MitM_Attributes(tree) <> fail then
        for attr in RecNames(MitM_Attributes(tree)) do
            if attr in RecNames(MitM_ValidAttr.(MitM_Tag(tree))) then
                result := MitM_ValidAttr.(MitM_Tag(tree)).(attr)(MitM_Attributes(tree).(attr));
            elif attr in RecNames(MitM_ValidAttr.common) then
                result := MitM_ValidAttr.common.(attr)(MitM_Attributes(tree).(attr));
            else
                return Concatenation(attr, " is not a valid attribute of ",
                                     MitM_Tag(tree), " objects");
            fi;
            if result <> true then
                return StringFormatted("{} attribute of {} object: {}",
                                       attr, MitM_Tag(tree), result);
            fi;
        od;
    else
        if not IsEmpty(MitM_RequiredAttr.(MitM_Tag(tree))) then
            return StringFormatted("{} objects must have the {} attribute",
                                   MitM_Tag(tree), MitM_RequiredAttr.(MitM_Tag(tree))[1]);
        fi;
    fi;

    # Check required attributes
    for attr in MitM_RequiredAttr.(MitM_Tag(tree)) do
        if not attr in RecNames(MitM_Attributes(tree)) then
            return Concatenation(MitM_Tag(tree), " objects must have the ",
                                 attr, " attribute");
        fi;
    od;

    # Check antirequisite attributes - just one of these
    if MitM_Tag(tree) = "OMF" then
        if MitM_Attributes(tree) = fail
               or not (IsBound(MitM_Attributes(tree).dec)
                       or IsBound(MitM_Attributes(tree).hex)) then
            return "OMF objects must have either the dec or the hex attribute";
        elif IsBound(MitM_Attributes(tree).dec) and IsBound(MitM_Attributes(tree).hex) then
            return "OMF objects cannot have both the dec and the hex attribute";
        fi;
    fi;

    # Validate the content
    if MitM_Content(tree) <> fail then
        result := MitM_ValidCont.(MitM_Tag(tree))(MitM_Content(tree));
    else
        result := MitM_ValidCont.(MitM_Tag(tree))([]);
    fi;
    if result <> true then
        return Concatenation(MitM_Tag(tree), " contents: ", result);
    fi;
    return true;
end);
