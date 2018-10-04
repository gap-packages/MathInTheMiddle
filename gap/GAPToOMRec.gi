InstallMethod(MitM_GAPToOMRec,
"for a dihedral perm group",
[IsPermGroup and IsDihedralGroup],
D -> OMA( MitM_SimpleOMS("DihedralGroup")
        , MitM_SimpleOMS("IsPermGroup")
        , MitM_GAPToOMRec(Size(D)) ) );

InstallMethod(MitM_GAPToOMRec,
"for a quaternion perm group",
[IsPermGroup and IsQuaternionGroup],
Q -> OMA( MitM_SimpleOMS("QuaternionGroup"),
          MitM_SimpleOMS("IsPermGroup"),
          MitM_GAPToOMRec(Size(Q))));

InstallMethod(MitM_GAPToOMRec,
"for an integer",
[IsInt],
i -> OMI(i));

InstallMethod(MitM_GAPToOMRec,
"for a float",
[IsFloat],
v -> OMF(v));

InstallMethod(MitM_GAPToOMRec,
"for a string in string representation",
[IsString and IsStringRep],
s -> OMSTR(s));

InstallMethod(MitM_GAPToOMRec,
"for a char",
[IsChar],
c -> OMA( OMS(MitM_cdbase, "prim", "CharConstr")
        , OMSTR( [c] ) ) );

InstallMethod(MitM_GAPToOMRec,
"for a boolean",
[IsBool],
b -> OMA( OMS( MitM_cdbase, "prim", "BoolConstr" )
        , OMSTR( String(b) ) ) );

InstallMethod(MitM_GAPToOMRec,
"for a record",
[IsRecord],
function(r)
    local content, rnam;
    content := [OMS(MitM_cdbase, "prim", "RecConstr")];
    for rnam in Set(RecNames(r)) do
        Add(content, OMSTR(rnam));
        Add(content, MitM_GAPToOMRec(r.(rnam)));
    od;
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
              "for a permutation",
              [IsPerm],
p -> OMA( OMS(MitM_cdbase, "prim", "PermConstr")
        , List(ListPerm(p), MitM_GAPToOMRec) ) );

InstallMethod(MitM_GAPToOMRec,
"for a polynomial ring",
[IsPolynomialRing],
R -> OMA( MitM_SimpleOMS("PolynomialRing")
        , MitM_GAPToOMRec(LeftActingDomain(R))
        , MitM_GAPToOMRec(List(IndeterminatesOfPolynomialRing(R), String)) ) );

InstallMethod(MitM_GAPToOMRec,
"for a polynomial",
[IsPolynomial],
p -> OMA( MitM_SimpleOMS("PolynomialByExtRep")
        , OMA( MitM_SimpleOMS("RationalFunctionsFamily")
             , OMA( MitM_SimpleOMS("FamilyObj"), MitM_GAPToOMRec(1) ) ) ) );

InstallMethod(MitM_GAPToOMRec,
"for the ring of integers",
[IsIntegers],
I -> MitM_SimpleOMS("Integers"));

InstallMethod(MitM_GAPToOMRec,
"for a list",
[IsList],
function(L)
    local content, item;
    content := [ OMS(MitM_cdbase
                     , "prim"
                     , "ListConstr") ];
    for item in L do
        Add(content, MitM_GAPToOMRec(item));
    od;
    return CallFuncList(OMA, content);
end);

InstallMethod(MitM_GAPToOMRec,
"for a finite field element",
[IsFFE],
function(elm)
    local content, char, deg, log, coef;
    content := [];
    Add(content, OMS( MitM_cdbase
                    , "prim"
                    , "FFEConstr"));
    char := Characteristic(elm);
    deg := DegreeFFE(elm);
    Add(content, MitM_GAPToOMRec(char));
    Add(content, MitM_GAPToOMRec(deg));
    if IsInternalRep(elm) then
        log := LogFFE(elm, Z(char, deg));
        elm := FFECONWAY.ZNC(char, deg) ^ log;
    fi;
    for coef in elm![1] do
        Add(content, MitM_GAPToOMRec(IntFFE(coef)));
    od;
    return CallFuncList(OMA, content);
end);

# TODO: This is a hack. We look for functions that create objects using
#       `Objectify` by essentially grepping through their source (so this
#       only works for GAP-level functions) and designating any function
#       a constructor that calls Objectify.
#
#       As a first test we wrap these functions in a constructor-memoiser
MitM_C___Wrapper := function(n, callee)
    return function(args...)
        local obj, omacont, a, m;
        obj := CallFuncList(callee, args);

        omacont := [ OMS(MitM_cdbase, "lib", n) ];
        for a in args do
            m := ApplicableMethod(MitM_GAPToOMRec, [ a ]);
            if m <> fail then
                Add(omacont, m(a));
            else
                # CANT DO
                return obj;
            fi;
        od;
        # This will of course only work with attribute storing objects
        SetMitM_GAPToOMRec(obj, CallFuncList(OMA, omacont) );
        return obj;
    end;
end;

InstallGlobalFunction(MitM_FindConstructors,
function()
    local n, v, j, fun, res, a, meths, mpos, mres;

    res := [];
    for n in NamesGVars() do
        if IsBoundGlobal(n) then
            v := ValueGlobal(n);
            if IsOperation(v) then
                for a in [1..6] do
                    meths := METHODS_OPERATION(v, a);
                    j := 0;
                    while j + a + 2 < Length(meths) do
                        fun := meths[j + a + 2];
                        if PositionSublist(String(fun), "Objectify") <> fail then
                            meths[j + a + 2] := MitM_C___Wrapper(n, fun);
                            CHANGED_METHODS_OPERATION(v, a);
                            Add(res, rec( type := "oper", name := n, value := fun, operation := v ));
                        fi;
                        j := j + (BASE_SIZE_METHODS_OPER_ENTRY + a);
                    od;
                od;
            fi;
            if IsFunction(v) then
                if PositionSublist(String(v), "Objectify") <> fail then
                    MakeReadWriteGlobal(n);
                    UnbindGlobal(n);
                    BindGlobal(n, MitM_C___Wrapper(n, v));
                    Add(res, rec( type := "gvar", name := n, value := v ));
                fi;
            fi;
        fi;
    od;
    return res;
end);
