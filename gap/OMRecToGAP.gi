
# Primitives for GAP
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
BindGlobal("MitM_Evaluators", rec(
     OMS := function(node)
        local name, sym;

        if not IsBound(node.attributes.name) then
            Print("Error: OMS no name given\n");
            return fail;
        fi;
        name := node.attributes.name;
        if node.attributes.cd = "prim" then
            sym := MitM_GAP_Primitives.(name);
        else
            if not IsBoundGlobal(name) then
                Print("Error: Symbol \"", name, "\" not known\n");
                return fail;
            fi;
            sym := ValueGlobal(node.attributes.name);
        fi;
        return sym;
     end,

     OMV := function(node)
         return node.name;
     end,

     OMI := function(node)
         if Length(node.content) <> 1 then
             Print("Error: Expecting exactly integer content\n");
         fi;
         return Int(node.content[1]);
     end,

     OMB := function(node)
     end,

     OMSTR := function(node)
         return node.content[1];
     end,

     OMF := function(node)
         if Length(node.content) <> 1 then
             Print("Error: Expecting exactly integer content\n");
         fi;
         return Float(node.content[1]);
     end,

     OMA := function(node)
         local sym, args;

         sym := MitM_OMRecToGAP(node.content[1]);
         args := List(node.content{[2..Length(node.content)]}, MitM_OMRecToGAP);

         return CallFuncList(sym, args);
     end,

     OMBIND := function(node)
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(node.content{ [2..Length(node.content)] }, MitM_OMRecToGAP), "\n");
     end,

     OMATTR := function(node)
     end,

     OMR := function(node)
     end,
    ) );

# Interprets GAP MathInTheMiddle OpenMath back into GAP objects
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

