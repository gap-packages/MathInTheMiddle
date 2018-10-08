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

InstallMethod(MitM_OMRecToGAP, [MitM_OMRecRep],
function(r)
    local val, res;
    val := MitM_IsValidOMRec(r);
    if val <> true then
        return MitM_Error(val);
    fi;
    res := MitM_OMRecToGAPNC(r);
    if res.success <> true then
        return res;
    fi;
    return MitM_Result(EvalString(res.result));
end);

InstallGlobalFunction(MitM_OMRecToGAPNC,
function(r)
    return MitM_EvalToFunction.(MitM_Tag(r))(r);
end);

# Primitives for GAP
BindGlobal("MitM_GAP_PrimitivesFunc", rec(
     ListConstr := "({args...} -> args)",
     RecConstr := "(function(args...) local r,i; r := rec(); for i in [1,3..Length(args)-1] do r.(args[i]) := args[i+1]; od; return r; end)",
     PermConstr := "({args...} -> PermList(args))",
     # TODO: PermBytesConstr
     BoolConstr := "({args...} -> EvalString(args[1]))",
     CharConstr := "({args...} -> args[1][1])",
     FFEConstr := "({args...} -> Sum([0..args[2]-1], i -> args[i+3] * Z(args[1], args[2]) ^ i))",
) );

MitM_Evaluate := function(node)
    return node;
end;

MitM_get_allowed_heads := function()
    return OMA( OMS( "scscp1", "symbol_set" )
              , OMS( "scscp_transient_1", "MitM_Evaluate" )
              , OMS( "scscp_transient_1", "MitM_Quit" )
              , OMS( MitM_cdbase, "lib", "MitM_Evaluate" ) );
end;

BindGlobal("MitM_CDDirectory",
rec( ( "default" ) := function(node)
       if MitM_CD(node) = "scscp2" then
           if MitM_Name(node) = "get_allowed_heads" then
               return MitM_Result( "MitM_get_allowed_heads" );
           else
               return MitM_Error("name \"", MitM_Name(node), "\" not supported");
           fi;
       elif MitM_CD(node) = "scscp_transient_1" then
           if MitM_Name(node) = "MitM_Evaluate" then
               return MitM_Result("MitM_Evaluate");
           elif MitM_Name(node) = "MitM_Quit" then
               QUIT_GAP(0);
           fi;
       else
           return MitM_Error("cd \"", MitM_CD(node), "\" not supported");
       fi;
     end,
     ( MitM_cdbase ) := function(node)
         local name;
         name := MitM_Attributes(node).name;
         if MitM_CD(node) = "prim" then
             if not name in RecNames(MitM_GAP_PrimitivesFunc) then
                 return MitM_Error("OMS name \"", name,
                                   "\" not a GAP primitive function");
             fi;
             return MitM_Result(MitM_GAP_PrimitivesFunc.(name));
         elif MitM_CD(node) = "lib" then
             return MitM_Result(MitM_Name(node));
         else
             return MitM_Error("cd \"", MitM_CD(node)
                               , "\" not supported");
         fi;
     end,
) );

# Evaluators for OpenMath objects
InstallValue(MitM_EvalToFunction, rec(
     OMOBJ := function(node)
         return MitM_OMRecToGAPNC(MitM_Content(node)[1]);
     end,

     OMS := function(node)
         local name, sym;

         if MitM_CDBase(node) = fail then
             return MitM_CDDirectory.("default")(node);
         elif IsBound(MitM_CDDirectory.(MitM_CDBase(node))) then
             return MitM_CDDirectory.(MitM_CDBase(node))(node);
         else
             return MitM_Error("cdbase \"", MitM_CDBase(node)
                               , "\" is not supported");
         fi;
     end,

     OMV := node -> MitM_Result(StringFormatted("{}",
                                                MitM_Name(node))),
     OMI := function(node)
         local v;
         v := ShallowCopy(MitM_Content(node)[1]);
         RemoveCharacters(v, WHITESPACE);
         if Position(MitM_Content(node)[1], 'x') <> fail then
             RemoveCharacters(v, "x");
             return MitM_Result(String(IntHexString(v)));
         else
             return MitM_Result(v);
         fi;
     end,

     OMB := node -> MitM_Result(StringFormatted("\"{}\"", MitM_Content(node)[1])),

     OMSTR := function(node)
         local str;
         if IsEmpty(MitM_Content(node)) then
             str := "";
         else
             str := MitM_Content(node)[1];
         fi;
         return MitM_Result(StringFormatted("({} -> \"{}\")()", "{}", str));
     end,

     OMF := function(node)
         if IsBound(MitM_Attributes(node).dec) then
             return MitM_Result(String(Float(MitM_Attributes(node).dec)));
         else
             return MitM_Error("OMF: hex encoding not supported");
         fi;
     end,

     OMA := function(node)
         local sym, args, item, r;

         sym := MitM_OMRecToGAPNC(MitM_Content(node)[1]);
         if sym.success <> true then
             return MitM_Error("OMA contents: ", sym.error);
         fi;
         args := [];
         for item in MitM_Content(node){[2..Length(MitM_Content(node))]} do
             r := MitM_OMRecToGAPNC(item);
             if r.success <> true then
                 return MitM_Error("OMA contents: ", r.error);
             elif MitM_Name(item) = "OMV" then
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

         if not (MitM_CD(MitM_Content(node)[1]) = "prim" and
                 MitM_Name(MitM_Content(node)[1]) = "lambda") then
             return MitM_Error("only the lambda binding is implemented");
         fi;
         list := List(MitM_Content(MitM_Content(node)[2]), MitM_Name);
         val := MitM_OMRecToGAPNC(MitM_Content(node)[3]);
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
         return MitM_OMRecToGAPNC(MitM_Content(node)[2]);
     end,

     OME := function(node)
         # TODO: Error handling?
         Print("Error: ", List(MitM_Content(node){[2..Length(MitM_Content(node))]},
                               MitM_OMRecToGAPNC), "\n");
     end,

#     OMR := function(node)
#     end,
    ) );
