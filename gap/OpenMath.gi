

BindGlobal("MitM_Evaluators", rec(
     OMS := function(node)
        local name, sym;

        if not IsBound(node.attributes.name) then
            Print("Error: OMS no name given\n");
            return fail;
        fi;
        name := node.attributes.name;
        if not IsBoundGlobal(name) then
            Print("Error: Symbol not known\n");
            return fail;
        fi;
        sym := ValueGlobal(node.attributes.name);
        return sym;
     end,
     OMA := function(node)
         local sym, args;

         sym := MitM_Decode(node.content[1]);
         args := List(node.content{[2..Length(node.content)]}, MitM_Decode);

         return CallFuncList(sym, args);
     end,
     OMI := function(node)
         if Length(node.content) <> 1 then
             Print("Error: Expecting exactly integer content\n");
         fi;
         return Int(node.content[1]);
     end,
     OMF := function(node)
         if Length(node.content) <> 1 then
             Print("Error: Expecting exactly integer content\n");
         fi;
         return Float(node.content[1]);
     end,
    ) );

BindGlobal("MitM_ValidateNode",
function(node)
    if not IsBound(node.name) then
        Print("Error: no name\n");
        return fail;
    elif not IsBound(MitM_Evaluators.(node.name)) then
        Print("Error: unsupported tag\n");
        return fail;
    elif IsBound(node.attributes) then
        if IsBound(node.attributes.cdbase) then
            if node.attributes.cdbase <> MitM_cdbase then
                Print("Error: unsupported cdbase\n");
                return fail;
            fi;
        fi;
        if IsBound(node.attributes.cd) then
            if not (node.attributes.cd in [ "lib" ]) then
                Print("Error: unsupported cd\n");
                return fail;
            fi;
        fi;
    fi;
    return true;
end);

# Interprets GAP MathInTheMiddle OpenMath back into GAP objects
InstallMethod(MitM_Decode, [IsRecord],
function(r)
    if MitM_ValidateNode(r) <> false then
        return MitM_Evaluators.(r.name)(r);
    else
        Print("Error\n");
    fi;
end);



