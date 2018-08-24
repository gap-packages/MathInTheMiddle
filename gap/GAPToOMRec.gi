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
function(i)
    return rec(name := "OMI", content := [String(i)]);
end);

InstallMethod(MitM_GAPToOMRec,
"for a string",
[IsString],
function(s)
    return rec(name := "OMSTR", content := [s]);
end);

InstallMethod(MitM_GAPToOMRec,
"for a permutation",
[IsPerm],
function(p)
    local content;
    content := [rec(name := "OMS",
                    attributes := rec(cdbase := MitM_cdbase,
                                      cd := "prim",
                                      name := "PermConstr")),
                rec(name := "OMS",
                    attributes := rec(cdbase := MitM_cdbase,
                                      cd := "prim",
                                      name := "ListEncoding"))];
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
    
InstallGlobalFunction(MitM_OMRecToXML,
function(r)
    local str, rnam, content, item;
    str := StringFormatted("<{}", r.name);
    if IsBound(r.attributes) then
        for rnam in Set(RecNames(r.attributes)) do
            Append(str, StringFormatted(" {}=\"{}\"", 
                                        rnam, r.attributes.(rnam)));
        od;
    fi;
    if IsBound(r.content) then
        Append(str, ">");
        content := r.content;
        if Length(content) = 1 and not IsRecord(content[1]) then
            Append(str, String(content[1]));
        else
            Append(str, "\n");
            for item in content do
                if IsRecord(item) then
                    Append(str, MitM_OMRecToXML(item));
                else
                    # This might not be possible with a proper OMRec, since a
                    # string always appears inside a pair of tags, on its own.
                    Append(str, String(item));
                fi;
                Append(str, "\n");
            od;
        fi;
        Append(str, StringFormatted("</{}>", r.name));
    else
        Append(str, " />");
    fi;
    return str;
end);

InstallGlobalFunction(MitM_Print,
function(obj)
    Print(MitM_OMRecToXML(MitM_GAPToOMRec(obj)), "\n");
end);
