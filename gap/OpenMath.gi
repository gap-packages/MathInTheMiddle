

MitM_ValidateNode := function(node)
    if not IsBound(node.attributes) then
        Print("Error: no attributes bound\n");
        return fail;
    elif not IsBound(node.attributes.cdbase) then
        Print("Error: no cdbase bound\n");
        return fail;
    elif node.attributes.cdbase <> MitM_cdbase then
        Print("Error: unsupported cdbase\n");
        return fail;
    elif not IsBound(node.attributes.cd) then
        Print("Error: unsupported cdbase\n");
        return fail;
    elif not node.attributes in [ "lib" ] then
        Print("Error: unsupported cd\n");
        return fail;
    fi;
    return true;
end;

EvalREC := rec(
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
                return Int(node.content[1]);
            end,
            
            );

           

# Interprets GAP MathInTheMiddle OpenMath back into GAP objects
InstallMethod(MitM_Decode, [IsRecord],
function(r)
    
end);



