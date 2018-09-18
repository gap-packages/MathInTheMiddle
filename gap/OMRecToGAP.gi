#
# Interprets GAP MathInTheMiddle OpenMath into GAP functions
#

# Make records indicating success or failure
InstallGlobalFunction(MitM_Error,
function(str...)
    return rec(success := false, error := Concatenation(str));
end);

InstallGlobalFunction(MitM_Result,
function(obj)
    return rec(success := true, result := obj);
end);

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
     BoolConstr := "({args...} -> EvalString(args[1]))",
     CharConstr := "({args...} -> args[1][1])",
     FFEConstr := "({args...} -> Sum([0..args[2]-1], i -> args[i+3] * Z(args[1], args[2]) ^ i))",
) );

SCSCP_get_allowed_heads := function()
    return [];
end;


BindGlobal("MitM_CDDirectory",
rec( ( "default" ) := function(node)
       if node.attributes.cd = "scscp2" then
           if node.attributes.name = "get_allowed_heads" then
               return MitM_Result("SCSCP_get_allowed_heads");
           else
               return MitM_Error("name \"", node.attributes.name, "\" not supported");
           fi;
       else
           return MitM_Error("cd \"", node.attributes.cd, "\" not supported");
       fi;
     end,
     ( MitM_cdbase ) := function(node)
         local name;
         name := node.attributes.name;
         if node.attributes.cd = "prim" then
             if not name in RecNames(MitM_GAP_PrimitivesFunc) then
                 return MitM_Error("OMS name \"", name,
                                   "\" not a GAP primitive function");
             fi;
             return MitM_Result(MitM_GAP_PrimitivesFunc.(name));
         elif node.attributes.cd = "lib" then
             return MitM_Result(node.attributes.name);
         else
             return MitM_Error("cd \"", node.attributes.cd
                               , "\" not supported");
         fi;
     end,
) );

# Evaluators for OpenMath objects
InstallValue(MitM_EvalToFunction, rec(
     OMOBJ := function(node)
         return MitM_OMRecToGAPFuncNC(node.content[1]);
     end,

     OMS := function(node)
         local name, sym;

         if (not IsBound(node.attributes.cdbase)) then
             return MitM_CDDirectory.("default")(node);
         elif IsBound(MitM_CDDirectory.(node.attributes.cdbase)) then
             return MitM_CDDirectory.(node.attributes.cdbase)(node);
         else
             return MitM_Error("cdbase \"", node.attributes.cdbase
                               , "\" is not supported");
         fi;
     end,

     OMV := node -> MitM_Result(StringFormatted("\"{}\"",
                                                node.attributes.name)),
     OMI := function(node)
         local v;
         v := ShallowCopy(node.content[1]);
         RemoveCharacters(v, WHITESPACE);
         if Position(node.content[1], 'x') <> fail then
             RemoveCharacters(v, "x");
             return MitM_Result(String(IntHexString(v)));
         else
             return MitM_Result(v);
         fi;
     end,

     OMB := node -> MitM_Result(StringFormatted("\"{}\"", node.content[1])),

     OMSTR := function(node)
         local str;
         if IsEmpty(node.content) then
             str := "";
         else
             str := node.content[1];
         fi;
         return MitM_Result(Concatenation("\"", str, "\""));
     end,

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

     OMATTR := function(node)
         return MitM_OMRecToGAPFuncNC(node.content[2]);
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{[2..Length(node.content)]},
                               MitM_OMRecToGAPNC), "\n");
     end,

#     OMR := function(node)
#     end,
    ) );
