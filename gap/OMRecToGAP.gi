#
# Interprets GAP MathInTheMiddle OpenMath back into GAP objects
#
InstallMethod(MitM_OMRecToGAP, [IsRecord],
function(r)
    local val;
    val := MitM_IsValidOMRec(r);
    if val <> true then
        return rec(success := false, error := val);
    fi;
    return MitM_OMRecToGAPNC(r);
end);

# Still handles errors, but doesn't run IsValidOMRec
InstallGlobalFunction(MitM_OMRecToGAPNC,
function(r)
    return MitM_Evaluators.(r.name)(r);
end);

# Make records indicating success or failure
InstallGlobalFunction(MitM_Error,
function(str...)
    return rec(success := false, error := Concatenation(str));
end);
InstallGlobalFunction(MitM_Result,
function(obj)
    return rec(success := true, result := obj);
end);

BindGlobal("MitM_GAP_Primitives", rec(
     ListConstr := function(args...)
         return args;
     end,
     PermConstr := function(args...)
         return PermList(args);
     end,
     # TODO: PermBytesConstr
) );

# Evaluators for OpenMath objects
InstallValue(MitM_Evaluators, rec(
     OMS := function(node)
        local name, sym;
        name := node.attributes.name;

        if (not IsBound(node.attributes.cdbase)) or
           (node.attributes.cdbase <> MitM_cdbase) then
            return MitM_Error("cdbase must be ", MitM_cdbase);
        fi;

        if node.attributes.cd = "prim" then
            if not name in RecNames(MitM_GAP_Primitives) then
                return MitM_Error("OMS name \"", name,
                                  "\" not a GAP primitive function");
            fi;
            sym := MitM_GAP_Primitives.(name);
        elif node.attributes.cd = "lib" then
            if not IsBoundGlobal(name) then
                return MitM_Error("symbol \"", name, "\" not known");
            fi;
            sym := ValueGlobal(node.attributes.name);
        else
            return MitM_Error("cd \"", node.attributes.cd, "\" not supported");
        fi;
        return MitM_Result(sym);
     end,

     OMOBJ := function(node)
         return MitM_OMRecToGAPNC(node.content[1]);
     end,

     OMV := function(node)
         return MitM_Result(node.attributes.name);
     end,

     OMI := function(node)
         local v;
         if Position(node.content[1], 'x') <> fail then
             v := ShallowCopy(node.content[1]);
             RemoveCharacters(v, WHITESPACE);
             RemoveCharacters(v, "x");
             return MitM_Result(IntHexString(v));
         else
             return MitM_Result(Int(node.content[1]));
         fi;
     end,

     OMB := function(node)
         return MitM_Result(node.content[1]);
     end,

     OMSTR := function(node)
         return MitM_Result(node.content[1]);
     end,

     OMF := function(node)
         if IsBound(node.attributes.dec) then
             return MitM_Result(Float(node.attributes.dec));
         else
             return MitM_Error("OMF: hex encoding not supported");
         fi;
     end,

     OMA := function(node)
         local sym, args, item, r;

         sym := MitM_OMRecToGAPNC(node.content[1]);
         if sym.success <> true then
             return MitM_Error("OMA contents: ", sym.error);
         fi;
         args := [];
         for item in node.content{[2..Length(node.content)]} do
             r := MitM_OMRecToGAPNC(item);
             if r.success <> true then
                 return MitM_Error("OMA contents: ", r.error);
             else
                 Add(args, r.result);
             fi;
         od;

         return MitM_Result(CallFuncList(sym.result, args));
     end,

     OMBIND := function(node)
         local x;
         x := MitM_OMRecToGAPFuncNC(node);
         if x.success <> true then
             return x;
         fi;
         return MitM_Result(EvalString(x.result));
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{[2..Length(node.content)]},
                               MitM_OMRecToGAPNC), "\n");
     end,
# These are currently not used and not implemented
#     OMATTR := function(node)
#     end,
#
#     OMR := function(node)
#     end,
    ) );

#
# Interprets GAP MathInTheMiddle OpenMath into GAP functions
#
InstallMethod(MitM_OMRecToGAPFunc, [IsRecord],
function(r)
    local val, res;
    val := MitM_IsValidOMRec(r);
    if val <> true then
        return MitM_Error(val);
    fi;
    res := MitM_OMRecToGAPFuncNC(r);
    if res.success <> true then
        return res;
    fi;
    return MitM_Result(EvalString(res.result));
end);

InstallGlobalFunction(MitM_OMRecToGAPFuncNC,
function(r)
    return MitM_EvalToFunction.(r.name)(r);
end);

# Primitives for GAP
BindGlobal("MitM_GAP_PrimitivesFunc", rec(
     ListConstr := "({args...} -> args)",
     PermConstr := "({args...} -> PermList(args))",
     # TODO: PermBytesConstr
) );

# Evaluators for OpenMath objects
InstallValue(MitM_EvalToFunction, rec(
     OMS := function(node)
         local name, sym;

         if (not IsBound(node.attributes.cdbase)) or
             (node.attributes.cdbase <> MitM_cdbase) then
             return MitM_Error("cdbase must be ", MitM_cdbase);
         fi;

         name := node.attributes.name;
         if node.attributes.cd = "prim" then
             if not name in RecNames(MitM_GAP_PrimitivesFunc) then
                 return MitM_Error("OMS name \"", name,
                                   "\" not a GAP primitive function");
             fi;
             sym := MitM_GAP_PrimitivesFunc.(name);
         elif node.attributes.cd = "lib" then
             if not IsBoundGlobal(name) then
                 return MitM_Error("symbol \"", name, "\" not known");
             fi;
             sym := node.attributes.name;
         else
             return MitM_Error("cd \"", node.attributes.cd, "\" not supported");
         fi;
         return MitM_Result(sym);
     end,

     OMV := node -> MitM_Result(StringFormatted("\"{}\"", 
                                                node.attributes.name)),
     OMI := function(node)
         local v;
         if Position(node.content[1], 'x') <> fail then
             v := ShallowCopy(node.content[1]);
             RemoveCharacters(v, WHITESPACE);
             RemoveCharacters(v, "x");
             return MitM_Result(String(IntHexString(v)));
         else
             return MitM_Result(node.content[1]);
         fi;
     end,

     OMB := node -> MitM_Result(StringFormatted("\"{}\"", node.content[1])),

     OMSTR := node -> MitM_Result(Concatenation("\"", node.content[1], "\"")),

     OMF := function(node)
         if IsBound(node.attributes.dec) then
             return MitM_Result(String(Float(node.attributes.dec)));
         else
             return MitM_Error("OMF: hex encoding not supported");
         fi;
     end,

     OMA := function(node)
         local sym, args, item, r;

         sym := MitM_OMRecToGAPFuncNC(node.content[1]);
         if sym.success <> true then
             return MitM_Error("OMA contents: ", sym.error);
         fi;
         args := [];
         for item in node.content{[2..Length(node.content)]} do
             r := MitM_OMRecToGAPFuncNC(item);
             if r.success <> true then
                 return MitM_Error("OMA contents: ", r.error);
             elif item.name = "OMV" then
                 # Interpret string as variable
                 Add(args, EvalString(r.result));
             else
                 Add(args, r.result);
             fi;
         od;
         return MitM_Result(Concatenation(sym.result, "(",
                                          JoinStringsWithSeparator(args, ","),
                                          ")"));
     end,

     OMBIND := function(node)
         local list, val;

         if not (node.content[1].attributes.cd = "prim" and
                 node.content[1].attributes.name = "lambda") then
             return MitM_Error("only the lambda binding is implemented");
         fi;
         list := List(node.content[2].content, x -> x.attributes.name);
         val := MitM_OMRecToGAPFuncNC(node.content[3]);
         if val.success <> true then
             return MitM_Error("OMBIND contents: ", val.error);
         fi;
         return MitM_Result(Concatenation( "function(",
                                           JoinStringsWithSeparator(list, ","),
                                           ") return ", 
                                           val.result,
                                           ";  end" ));
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{[2..Length(node.content)]},
                               MitM_OMRecToGAPNC), "\n");
     end,

# These are currently unused and not implemented
#     OMATTR := function(node)
#     end,

#     OMR := function(node)
#     end,
    ) );
