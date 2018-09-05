#
#
#
# Interprets GAP MathInTheMiddle OpenMath back into GAP objects
#
InstallMethod(MitM_OMRecToGAP, [IsRecord],
function(r)
    local val;

    val := MitM_IsValidOMRec(r);
    if val = true then
        return MitM_Evaluators.(r.name)(r);
    else
        PrintFormatted("Error: {}\n", val);
    fi;
end);

InstallGlobalFunction(MitM_OMRecToGAPNC,
function(r)
    return MitM_Evaluators.(r.name)(r);
end);

BindGlobal("MitM_GAP_Primitives", rec(
     ListConstr := function(args...)
         return args;
     end,
     ListEncoding := function(args...) return "ListEncoding"; end,
     PermConstr := function(args...)
         return PermList(args{[2..Length(args)]});
     end,
) );

# Evaluators for OpenMath objects
InstallValue(MitM_Evaluators, rec(
     OMS := function(node)
        local name, sym;
        name := node.attributes.name;

        if (not IsBound(node.attributes.cdbase)) or
           (node.attributes.cdbase <> MitM_cdbase) then
            Error("cdbase must be ", MitM_cdbase);
        fi;

        if node.attributes.cd = "prim" then
            sym := MitM_GAP_Primitives.(name);
        elif node.attributes.cd = "lib" then
            if not IsBoundGlobal(name) then
                Error("symbol \"", name, "\" not known");
            fi;
            sym := ValueGlobal(node.attributes.name);
        else
            Error("cd \"", node.attributes.cd, "\" not supported");
        fi;
        return sym;
     end,

     OMOBJ := function(node)
         # TODO: this results in multiple validations
         return MitM_OMRecToGAP(node.content[1]);
     end,

     OMV := function(node)
         return node.attributes.name;
     end,

     OMI := function(node)
         local v;
         if Position(node.content[1], 'x') <> fail then
             v := ShallowCopy(node.content[1]);
             RemoveCharacters(v, WHITESPACE);
             RemoveCharacters(v, "x");
             return IntHexString(v);
         else
             return Int(node.content[1]);
         fi;
     end,

     OMB := function(node)
         return StringFormatted("{}", node.content[1]);
     end,

     OMSTR := function(node)
         return node.content[1];
     end,

     OMF := function(node)
         if IsBound(node.attributes.dec) then
             return Float(node.attributes.dec);
         else
             Error("Unsupported encoding for OMF");
         fi;
     end,

     OMA := function(node)
         local sym, args;

         sym := MitM_OMRecToGAPNC(node.content[1]);
         args := List(node.content{[2..Length(node.content)]}, MitM_OMRecToGAPNC);

         return CallFuncList(sym, args);
     end,

     OMBIND := function(node)
         return EvalString(MitM_OMRecToGAPFuncNC(node));
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{ [2..Length(node.content)] }, MitM_OMRecToGAPNC), "\n");
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
    local val;
    val := MitM_IsValidOMRec(r);
    if val = true then
        return EvalString(MitM_EvalToFunction.(r.name)(r));
    else
        PrintFormatted("Error: {}\n", val);
    fi;
end);

InstallGlobalFunction(MitM_OMRecToGAPFuncNC,
function(r)
    return MitM_EvalToFunction.(r.name)(r);
end);

# Primitives for GAP
BindGlobal("MitM_GAP_PrimitivesFunc", rec(
     ListConstr := "({args...} -> args)",
     ListEncoding := {} -> "ListEncoding",
     PermConstr := "({args...} -> PermList(args{[2..Length(args)]}))",
) );

# Evaluators for OpenMath objects
InstallValue(MitM_EvalToFunction, rec(
     OMS := function(node)
         local name, sym;

         if (not IsBound(node.attributes.cdbase)) or
             (node.attributes.cdbase <> MitM_cdbase) then
             Error("cdbase must be ", MitM_cdbase);
         fi;

         name := node.attributes.name;
         if node.attributes.cd = "prim" then
             sym := MitM_GAP_PrimitivesFunc.(name);
         elif node.attributes.cd = "lib" then
             sym := node.attributes.name;
         else
             Error("cd \"", node.attributes.cd, "\" not supported");
         fi;
         return sym;
     end,

     OMV := node -> node.attributes.name,
     OMI := function(node)
         local v;
         if Position(node.content[1], 'x') <> fail then
             v := ShallowCopy(node.content[1]);
             RemoveCharacters(v, WHITESPACE);
             RemoveCharacters(v, "x");
             return String(IntHexString(v));
         else
             return node.content[1];
         fi;
     end,

     OMB := node -> StringFormatted("\"{}\"", node.content[1]),

     OMSTR := node -> Concatenation("\"", node.content[1], "\""),

     OMF := function(node)
         if IsBound(node.attributes.dec) then
             return String(Float(node.attributes.dec));
         else
             Error("Unsupported encoding for OMF");
         fi;
     end,

     OMA := function(node)
         local args;

         args := List(node.content{[2..Length(node.content)]}, MitM_OMRecToGAPFuncNC);
         return Concatenation( MitM_OMRecToGAPFuncNC(node.content[1]),
                               "(", JoinStringsWithSeparator(args, ","), ")" );
     end,

     OMBIND := function(node)
         local sym, vars, body;

         if not (node.content[1].attributes.cd = "prim" and
                 node.content[1].attributes.name = "lambda") then
             Error("Only the lambda binding is implemented");
         fi;
         return Concatenation( "function(",
                               JoinStringsWithSeparator(List(node.content[2].content, x -> x.attributes.name), ","),
                               ") return ", MitM_OMRecToGAPFuncNC(node.content[3]), ";  end" );
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{ [2..Length(node.content)] }, MitM_OMRecToGAPNC), "\n");
     end,

# These are currently unused and not implemented
#     OMATTR := function(node)
#     end,

#     OMR := function(node)
#     end,
    ) );
