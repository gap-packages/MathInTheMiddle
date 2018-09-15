InstallGlobalFunction(MitM_OMRecToOMOBJRec,
r -> rec(name := "OMOBJ", content := [r]));

InstallGlobalFunction(MitM_SimpleOMS,
obj_name -> rec(name := "OMS", attributes := rec(cdbase := MitM_cdbase,
                                                 cd := "lib",
                                                 name := obj_name)));

InstallMethod(MitM_GAPToOMRec,
"for a dihedral perm group",
[IsPermGroup and IsDihedralGroup],
D -> rec(name := "OMA", content := [MitM_SimpleOMS("DihedralGroup"),
                                    MitM_SimpleOMS("IsPermGroup"),
                                    MitM_GAPToOMRec(Size(D))]));

InstallMethod(MitM_GAPToOMRec,
"for a quaternion perm group",
[IsPermGroup and IsQuaternionGroup],
Q -> rec(name := "OMA", content := [MitM_SimpleOMS("QuaternionGroup"),
                                    MitM_SimpleOMS("IsPermGroup"),
                                    MitM_GAPToOMRec(Size(Q))]));

InstallMethod(MitM_GAPToOMRec,
"for an integer",
[IsInt],
i -> rec(name := "OMI", content := [String(i)]));

InstallMethod(MitM_GAPToOMRec,
"for a string in string representation",
[IsString and IsStringRep],
s -> rec(name := "OMSTR", content := [s]));

InstallMethod(MitM_GAPToOMRec,
"for a char",
[IsChar],
c -> rec(name := "OMA",
         content := [rec(name := "OMS",
                         attributes := rec(cdbase := MitM_cdbase,
                                           cd := "prim",
                                           name := "CharConstr")),
                     rec(name := "OMSTR",
                         content := [[c]])]));

InstallMethod(MitM_GAPToOMRec,
"for a boolean",
[IsBool],
function(b)
    local content;
    content := [rec(name := "OMS",
                    attributes := rec(cdbase := MitM_cdbase,
                                      cd := "prim",
                                      name := "BoolConstr")),
                rec(name := "OMSTR",
                    content := [ String(b) ])];
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
"for a permutation",
[IsPerm],
function(p)
    local content;
    content := [rec(name := "OMS",
                    attributes := rec(cdbase := MitM_cdbase,
                                      cd := "prim",
                                      name := "PermConstr"))];
    Append(content, List(ListPerm(p), MitM_GAPToOMRec));
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
"for a polynomial ring",
[IsPolynomialRing],
function(R)
    local content;
    content := [MitM_SimpleOMS("PolynomialRing"),
                MitM_GAPToOMRec(LeftActingDomain(R)),
                MitM_GAPToOMRec(List(IndeterminatesOfPolynomialRing(R), String))];
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
"for a polynomial",
[IsPolynomial],
function(p)
    local content;
    content := [MitM_SimpleOMS("PolynomialByExtRep"),
                rec(name := "OMA",
                    content := [MitM_SimpleOMS("RationalFunctionsFamily"),
                                rec(name := "OMA",
                                    content := [MitM_SimpleOMS("FamilyObj"),
                                                MitM_GAPToOMRec(1)])]),
                MitM_GAPToOMRec(ExtRepPolynomialRatFun(p))];
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
"for the ring of integers",
[IsIntegers],
I -> MitM_SimpleOMS("Integers"));

InstallMethod(MitM_GAPToOMRec,
"for a list",
[IsList],
function(L)
    local content, item;
    content := [rec(name := "OMS",
                    attributes := rec(cdbase := MitM_cdbase,
                                      cd := "prim",
                                      name := "ListConstr"))];
    for item in L do
        Add(content, MitM_GAPToOMRec(item));
    od;
    return rec(name := "OMA", content := content);
end);

InstallMethod(MitM_GAPToOMRec,
"for a finite field element",
[IsFFE],
function(elm)
    local content, char, deg, log, coef;
    content := [];
    Add(content, rec(name := "OMS",
                     attributes := rec(cdbase := MitM_cdbase,
                                       cd := "prim",
                                       name := "FFEConstr")));
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
    return rec(name := "OMA", content := content);
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

        omacont := [ rec( name := "OMS"
                        , attributes := rec( cd := "lib"
                                           , cdbase := MitM_cdbase
                                           , name := n ) ) ];

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
        SetMitM_GAPToOMRec(obj, rec( name := "OMA"
                                   , content := omacont ) );
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
