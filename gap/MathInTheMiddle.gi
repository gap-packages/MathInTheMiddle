#
# MathInTheMiddle: Maths-in-the-Middle functionality for GAP
#
# Implementations
#
#
#
## HOW TO USE THIS TOOL
#
# WARNING: At the moment this tool requires my custom
#          patches to GAP, which should be available in the
#          type-information branch in
#          https://github.com/markuspf/gap
#          The current plan is to integrate the type information
#          tools into GAP in the near future.
#
# * Load into GAP using Read("gaptypes.g");
# * Alternatively, run gap -q gaptypes.g
#
# In either case, you will get a file gaptypes_ugly.json, which
# contains one long string of json. I usually pretty-print it with
#
#    cat gaptypes_ugly.json | python -mjson.tool > gaptypes.g
#

# Operations
# Types of Installed Methods ( with filters )

LoadPackage("json");
LoadPackage("io");

BindGlobalConstant("MITM_debug", true);

# Returns the first global variable that this is assigned
# to
GVarNameForObject := function( obj )
    local n, res;
    return "Markus fix this you lazy git";

    n := NameFunction(obj);
    if IsBoundGlobal(n) and ValueGlobal(n) = obj then
        return n;
    else
        for n in NamesGVars() do
            if IsBoundGlobal(n) then
                if ValueGlobal(n) = obj then
                    return n;
                fi;
            fi;
        od;
    fi;
    return "";
end;

FindFilterId := function( filter )
    local i;

    if IsFilter(filter) then
        for i in [1..Length(FILTERS)] do
            if FILTERS[i] = filter then
                return i;
            fi;
        od;
    else
        Error("not a filter");
    fi;
    return fail;
end;

FindOperationId := function( oper )
    local i;

    if IsOperation(oper) then
        for i in [1..Length(OPERATIONS)/2] do
            if OPERATIONS[2*i - 1] = oper then
                return 2*i - 1;
            fi;
        od;
        return fail;
    else
        Error("not an operation");
    fi;
    return fail;
end;

FiltersForOperation := function( oper )
    local res, res2, filts, opid, fset, flags;

    res := [];
    opid := FindOperationId(oper);

    filts := OPERATIONS[opid + 1];

    for fset in filts do
        res2 := [];
        for flags in fset do
            Add(res2, List(TRUES_FLAGS(flags), x -> FILTERS[x]));
        od;
        Add(res, res2);
    od;

    return res;
end;

GAPAndFilterUnpack := function(t)
    local res;

    res := [];

    if IsOperation(t) then
        if (IsInt(FLAG1_FILTER(t)) and IsInt(FLAG2_FILTER(t)))
        then
            Add(res, NameFunction(t));
        else
            Append(res, GAPAndFilterUnpack(FLAG1_FILTER(t)));
            Append(res, GAPAndFilterUnpack(FLAG2_FILTER(t)));
        fi;
    fi;
    return res;
end;

GAPFilterToFilterType := function(fid)
    if INFO_FILTERS[fid] in FNUM_CATS then
        return "GAP_Category";
    elif INFO_FILTERS[fid] in FNUM_REPS then
        return "GAP_Representation";
    elif INFO_FILTERS[fid] in FNUM_ATTS then
        return "GAP_Attribute";
    elif INFO_FILTERS[fid] in FNUM_PROS then
        return "GAP_Property";
    elif INFO_FILTERS[fid] in FNUM_TPRS then
        return "GAP_TrueProperty";
    else
        return "GAP_Filter";
    fi;
end;


GAPFilterInfo := function(res, name, f)
    local lres, ff, i;

    lres := rec();
    i := FindFilterId(f);
    if i = fail then
        Print("Cannot find filter ", name, " ", f);
    else

    lres.type := GAPFilterToFilterType(i);
    # if the filter is an attribute and FLAG1_FILTER of the filter
    # is not equal to it, then this is a tester.
    ff := TRUES_FLAGS(WITH_IMPS_FLAGS(FLAGS_FILTER(f)));
    ff := List(ff, function(f)
                  if IsBound(FILTERS[f]) then
                      return GVarNameForObject(FILTERS[f]);
                  else
                      if ___debug___ then
                          Error("Unable to find a global variable name for");
                      fi;
                      return "<<unknown>>";
                  fi;
              end);
    if lres.type = "GAP_Attribute" then
        if (FLAG1_FILTER(f)) <> 0 and (FLAG1_FILTER(f) <> i) then
            lres.testerfor := GVarNameForObject(FILTERS[FLAG1_FILTER(f)]);
        fi;
        lres.filters := ff;
    elif lres.type = "GAP_Property" then
        lres.filters := ff;
    else
        lres.implied := ff;
    fi;
    lres.name := name;
    lres.name_func := NameFunction(FILTERS[i]);
    Add(res, lres);
    fi;
end;

GAPTypesInfoByGlobalVariables := function()
    local name, names, n, obj, res, lres, f;

    res := [ rec( name := "IsObject", type := "GAP_Category", implied := [] ) ];

    names := NamesGVars();
    for name in names do
        if IsBoundGlobal(name) then
            obj := ValueGlobal(name);

            if IsFilter(obj) then
                GAPFilterInfo(res, name, obj);
            else
            fi;
        fi;
    od;
end;

# Make GAP Type graph as a record
GAPTypesInfo := function()
    local res, lres, i, j, f, ff, a, meths, mpos, objs, m, mres, n, t, notcovered, v;

    objs := NewDictionary(IsObject, true);
    res := [ rec( name := "IsObject", type := "GAP_Category", implied := [] ) ];

    Print("exporting filters...\n");
    for i in [1..Length(FILTERS)] do
        if IsBound(FILTERS[i]) then
            lres := rec();
            f := FILTERS[i];

            lres.type := GAPFilterToFilterType(i);
            # Attributes and Properties are exported below
            if lres.type in [ "GAP_Attribute", "GAP_Property" ] then
                # if the filter is an attribute and FLAG1_FILTER of the filter
                # is not equal to it, then this is a tester.
                if lres.type = "GAP_Attribute" then
                    if (FLAG1_FILTER(f)) <> 0 and (FLAG1_FILTER(f) <> i) then
                        lres.testerfor := NameFunction(FILTERS[FLAG1_FILTER(f)]);
                    fi;
                elif lres.type = "GAP_Property" then
                    lres.filters := ff;
                else
                fi;
            else
                AddDictionary(objs, f, lres);
                ff := TRUES_FLAGS(WITH_IMPS_FLAGS(FLAGS_FILTER(FILTERS[i])));
                ff := List(ff, function(f)
                              if IsBound(FILTERS[f]) then
                                  return NameFunction(FILTERS[f]);
                              else
                                  return "<<unknown>>";
                              fi;
                          end);
                lres.implied := ff;
                if IsBound(FILTERS_LOCATIONS[i]) then
                    lres.location := FILTERS_LOCATIONS[i];
                fi;
                lres.name := (NameFunction(FILTERS[i]));
                Add(res, lres);
            fi;
        fi;
    od;
    Print("   done\n");
    Print("exporting attributes...\n");
    for i in [1..Length(ATTRIBUTES)] do
        lres := rec();

	      if LookupDictionary(objs, ATTRIBUTES[i][3]) <> fail then
		        Print("obj: ", ATTRIBUTES[i][1], " ", ATTRIBUTES[i][3]," already there \n");
 	      else
        	  AddDictionary(objs, ATTRIBUTES[i][3], lres);
	      fi;

	      if FLAG1_FILTER(ATTRIBUTES[i][3]) = 0 then
        	  lres.type := "GAP_Attribute";
	      else
		        lres.type := "GAP_Property";
	      fi;

        lres.filters := GAPAndFilterUnpack(ATTRIBUTES[i][2]);

        lres.name      := NameFunction(ATTRIBUTES[i][3]);
        lres.location  := ATTRIBUTES[i][7];
        Add(res, lres);
    od;
    Print("   done\n");
    Print("exporting operations...\n");
    for i in [1..Length(OPERATIONS)/2] do
        lres := rec();
        AddDictionary(objs, OPERATIONS[2*i - 1], lres);
        lres.type := "GAP_Operation";
        lres.name := NameFunction(OPERATIONS[2*i - 1]);
        lres.locations := OPERATIONS_LOCATIONS[2*i];
        lres.filters := FiltersForOperation(OPERATIONS[2*i - 1]);
        lres.filters := List(lres.filters, x->List(x,y -> List(y,NameFunction)));

        lres.methods := rec( 0args := [], 1args := [], 2args := [],
                             3args := [], 4args := [], 5args := [],
                             6args := [] );

        for a in [1..6] do
            meths := METHODS_OPERATION(OPERATIONS[2*i - 1], a);

            for j in [1..Int(Length(meths)/(a + 4))] do
                mpos := (j - 1) * (a + 4) + 1;
                mres := rec( filters := List([1..a],
                                             argnum ->
                                                    List(TRUES_FLAGS(meths[mpos + argnum]), x -> NameFunction(FILTERS[x]))
                                            ),
                             rank := meths[mpos + a + 2],
                             comment := meths[mpos + a + 3]
                           );

                # Methods are not bound to global variables directly (usually...)
                # but some methods might be global functions
                AddDictionary(objs, meths[mpos + a + 1], mres);

                Add(lres.methods.(Concatenation(String(a),"args")), mres);
            od;
        od;

        Add(res, lres);
    od;
    Print("   done\n");
    Print("exporting global functions...\n");
    for f in [1..Length(GLOBAL_FUNCTION_NAMES)] do
        lres := rec();
        lres.type := "GAP_Function";
        lres.name := GLOBAL_FUNCTION_NAMES[f];
        lres.location := rec();
        AddDictionary(objs, ValueGlobal(GLOBAL_FUNCTION_NAMES[f]), lres);
        Add(res, lres);
    od;
    Print("   done\n");
    Print("collecting global variable references...\n");
    notcovered := [];
    for n in NamesGVars() do
        if IsBoundGlobal(n) then
            v := ValueGlobal(n);
            t := LookupDictionary(objs, v);
            if t <> fail then
                if IsBound(t.aka) then
                    Add(t.aka, n);
                else
                    t.aka := [n];
                fi;
            else
                v := ValueGlobal(n);
                if IsFilter(v) then
                    lres := rec();
                    lres.type := "GAP_AndFilter";
                    ff := FLAGS_FILTER(v);
                    if ff <> false then
                        ff := TRUES_FLAGS(FLAGS_FILTER(v));
                        ff := List(ff, function(f)
                                      if IsBound(FILTERS[f]) then
                                          return NameFunction(FILTERS[f]);
                                      else
                                          return "<<unknown>>";
                                      fi;
                                  end);
                        lres.conjunction_of := ff;
                        lres.name := (NameFunction(v));
                        lres.aka := [n];
                                        AddDictionary(objs, v, lres);
                        Add(res, lres);
                    else
                #        Print("strange: ", n, " ", v);
                    fi;
                else
                    Add(notcovered, n);
                fi;
            fi;
        fi;
    od;
    Print("   done\n");
    return [res, notcovered];
end;


# Write the graph of type info to JSon file
GAPTypesToJson := function(file)
    local fd, n, typeinfo;

    fd := IO_File(file, "w");
    if fd = fail then
        Error("Opening file ", file, "failed.");
    fi;
    typeinfo := GAPTypesInfo();
    n := IO_Write(fd, GapToJsonString(typeinfo[1]));
    IO_Close(fd);

    return n;
end;

GAPTypesToJson("gaptypes.json");
QUIT_GAP(0);

#
## HOW TO USE THIS TOOL
#
# WARNING: At the moment this tool requires my custom
#          patches to GAP, which should be available in the
#          type-information branch in
#          https://github.com/markuspf/gap
#          The current plan is to integrate the type information
#          tools into GAP in the near future.
#
# * Load into GAP using Read("gaptypes.g");
# * Alternatively, run gap -q gaptypes.g
#
# In either case, you will get a file gaptypes_ugly.json, which
# contains one long string of json. I usually pretty-print it with
#
#    cat gaptypes_ugly.json | python -mjson.tool > gaptypes.g
#

# Operations
# Types of Installed Methods ( with filters )

LoadPackage("json");
LoadPackage("io");

___debug___ := true;


# Returns the first global variable that this is assigned
# to
GVarNameForObject := function( obj )
    local n, res;
    return "Markus fix this you lazy git";

    n := NameFunction(obj);
    if IsBoundGlobal(n) and ValueGlobal(n) = obj then
        return n;
    else
        for n in NamesGVars() do
            if IsBoundGlobal(n) then
                if ValueGlobal(n) = obj then
                    return n;
                fi;
            fi;
        od;
    fi;
    return "";
end;

FindFilterId := function( filter )
    local i;

    if IsFilter(filter) then
        for i in [1..Length(FILTERS)] do
            if FILTERS[i] = filter then
                return i;
            fi;
        od;
    else
        Error("not a filter");
    fi;
    return fail;
end;

FindOperationId := function( oper )
    local i;

    if IsOperation(oper) then
        for i in [1..Length(OPERATIONS)/2] do
            if OPERATIONS[2*i - 1] = oper then
                return 2*i - 1;
            fi;
        od;
        return fail;
    else
        Error("not an operation");
    fi;
    return fail;
end;

FiltersForOperation := function( oper )
    local res, res2, filts, opid, fset, flags;

    res := [];
    opid := FindOperationId(oper);

    filts := OPERATIONS[opid + 1];

    for fset in filts do
        res2 := [];
        for flags in fset do
            Add(res2, List(TRUES_FLAGS(flags), x -> FILTERS[x]));
        od;
        Add(res, res2);
    od;

    return res;
end;

GAPAndFilterUnpack := function(t)
    local res;

    res := [];

    if IsOperation(t) then
        if (IsInt(FLAG1_FILTER(t)) and IsInt(FLAG2_FILTER(t)))
        then
            Add(res, NameFunction(t));
        else
            Append(res, GAPAndFilterUnpack(FLAG1_FILTER(t)));
            Append(res, GAPAndFilterUnpack(FLAG2_FILTER(t)));
        fi;
    fi;
    return res;
end;

GAPFilterToFilterType := function(fid)
    if INFO_FILTERS[fid] in FNUM_CATS then
        return "GAP_Category";
    elif INFO_FILTERS[fid] in FNUM_REPS then
        return "GAP_Representation";
    elif INFO_FILTERS[fid] in FNUM_ATTS then
        return "GAP_Attribute";
    elif INFO_FILTERS[fid] in FNUM_PROS then
        return "GAP_Property";
    elif INFO_FILTERS[fid] in FNUM_TPRS then
        return "GAP_TrueProperty";
    else
        return "GAP_Filter";
    fi;
end;


GAPFilterInfo := function(res, name, f)
    local lres, ff, i;

    lres := rec();
    i := FindFilterId(f);
    if i = fail then
        Print("Cannot find filter ", name, " ", f);
    else

    lres.type := GAPFilterToFilterType(i);
    # if the filter is an attribute and FLAG1_FILTER of the filter
    # is not equal to it, then this is a tester.
    ff := TRUES_FLAGS(WITH_IMPS_FLAGS(FLAGS_FILTER(f)));
    ff := List(ff, function(f)
                  if IsBound(FILTERS[f]) then
                      return GVarNameForObject(FILTERS[f]);
                  else
                      if ___debug___ then
                          Error("Unable to find a global variable name for");
                      fi;
                      return "<<unknown>>";
                  fi;
              end);
    if lres.type = "GAP_Attribute" then
        if (FLAG1_FILTER(f)) <> 0 and (FLAG1_FILTER(f) <> i) then
            lres.testerfor := GVarNameForObject(FILTERS[FLAG1_FILTER(f)]);
        fi;
        lres.filters := ff;
    elif lres.type = "GAP_Property" then
        lres.filters := ff;
    else
        lres.implied := ff;
    fi;
    lres.name := name;
    lres.name_func := NameFunction(FILTERS[i]);
    Add(res, lres);
    fi;
end;

GAPTypesInfoByGlobalVariables := function()
    local name, names, n, obj, res, lres, f;

    res := [ rec( name := "IsObject", type := "GAP_Category", implied := [] ) ];

    names := NamesGVars();
    for name in names do
        if IsBoundGlobal(name) then
            obj := ValueGlobal(name);

            if IsFilter(obj) then
                GAPFilterInfo(res, name, obj);
            else
            fi;
        fi;
    od;
end;

# Make GAP Type graph as a record
GAPTypesInfo := function()
    local res, lres, i, j, f, ff, a, meths, mpos, objs, m, mres, n, t, notcovered, v;

    objs := NewDictionary(IsObject, true);
    res := [ rec( name := "IsObject", type := "GAP_Category", implied := [] ) ];

    Print("exporting filters...\n");
    for i in [1..Length(FILTERS)] do
        if IsBound(FILTERS[i]) then
            lres := rec();
            f := FILTERS[i];

            lres.type := GAPFilterToFilterType(i);
            # Attributes and Properties are exported below
            if lres.type in [ "GAP_Attribute", "GAP_Property" ] then
                # if the filter is an attribute and FLAG1_FILTER of the filter
                # is not equal to it, then this is a tester.
                if lres.type = "GAP_Attribute" then
                    if (FLAG1_FILTER(f)) <> 0 and (FLAG1_FILTER(f) <> i) then
                        lres.testerfor := NameFunction(FILTERS[FLAG1_FILTER(f)]);
                    fi;
                elif lres.type = "GAP_Property" then
                    lres.filters := ff;
                else
                fi;
            else
                AddDictionary(objs, f, lres);
                ff := TRUES_FLAGS(WITH_IMPS_FLAGS(FLAGS_FILTER(FILTERS[i])));
                ff := List(ff, function(f)
                              if IsBound(FILTERS[f]) then
                                  return NameFunction(FILTERS[f]);
                              else
                                  return "<<unknown>>";
                              fi;
                          end);
                lres.implied := ff;
                if IsBound(FILTERS_LOCATIONS[i]) then
                    lres.location := FILTERS_LOCATIONS[i];
                fi;
                lres.name := (NameFunction(FILTERS[i]));
                Add(res, lres);
            fi;
        fi;
    od;
    Print("   done\n");
    Print("exporting attributes...\n");
    for i in [1..Length(ATTRIBUTES)] do
        lres := rec();

	      if LookupDictionary(objs, ATTRIBUTES[i][3]) <> fail then
		        Print("obj: ", ATTRIBUTES[i][1], " ", ATTRIBUTES[i][3]," already there \n");
 	      else
        	  AddDictionary(objs, ATTRIBUTES[i][3], lres);
	      fi;

	      if FLAG1_FILTER(ATTRIBUTES[i][3]) = 0 then
        	  lres.type := "GAP_Attribute";
	      else
		        lres.type := "GAP_Property";
	      fi;

        lres.filters := GAPAndFilterUnpack(ATTRIBUTES[i][2]);

        lres.name      := NameFunction(ATTRIBUTES[i][3]);
        lres.location  := ATTRIBUTES[i][7];
        Add(res, lres);
    od;
    Print("   done\n");
    Print("exporting operations...\n");
    for i in [1..Length(OPERATIONS)/2] do
        lres := rec();
        AddDictionary(objs, OPERATIONS[2*i - 1], lres);
        lres.type := "GAP_Operation";
        lres.name := NameFunction(OPERATIONS[2*i - 1]);
        lres.locations := OPERATIONS_LOCATIONS[2*i];
        lres.filters := FiltersForOperation(OPERATIONS[2*i - 1]);
        lres.filters := List(lres.filters, x->List(x,y -> List(y,NameFunction)));

        lres.methods := rec( 0args := [], 1args := [], 2args := [],
                             3args := [], 4args := [], 5args := [],
                             6args := [] );

        for a in [1..6] do
            meths := METHODS_OPERATION(OPERATIONS[2*i - 1], a);

            for j in [1..Int(Length(meths)/(a + 4))] do
                mpos := (j - 1) * (a + 4) + 1;
                mres := rec( filters := List([1..a],
                                             argnum ->
                                                    List(TRUES_FLAGS(meths[mpos + argnum]), x -> NameFunction(FILTERS[x]))
                                            ),
                             rank := meths[mpos + a + 2],
                             comment := meths[mpos + a + 3]
                           );

                # Methods are not bound to global variables directly (usually...)
                # but some methods might be global functions
                AddDictionary(objs, meths[mpos + a + 1], mres);

                Add(lres.methods.(Concatenation(String(a),"args")), mres);
            od;
        od;

        Add(res, lres);
    od;
    Print("   done\n");
    Print("exporting global functions...\n");
    for f in [1..Length(GLOBAL_FUNCTION_NAMES)] do
        lres := rec();
        lres.type := "GAP_Function";
        lres.name := GLOBAL_FUNCTION_NAMES[f];
        lres.location := rec();
        AddDictionary(objs, ValueGlobal(GLOBAL_FUNCTION_NAMES[f]), lres);
        Add(res, lres);
    od;
    Print("   done\n");
    Print("collecting global variable references...\n");
    notcovered := [];
    for n in NamesGVars() do
        if IsBoundGlobal(n) then
            v := ValueGlobal(n);
            t := LookupDictionary(objs, v);
            if t <> fail then
                if IsBound(t.aka) then
                    Add(t.aka, n);
                else
                    t.aka := [n];
                fi;
            else
                v := ValueGlobal(n);
                if IsFilter(v) then
                    lres := rec();
                    lres.type := "GAP_AndFilter";
                    ff := FLAGS_FILTER(v);
                    if ff <> false then
                        ff := TRUES_FLAGS(FLAGS_FILTER(v));
                        ff := List(ff, function(f)
                                      if IsBound(FILTERS[f]) then
                                          return NameFunction(FILTERS[f]);
                                      else
                                          return "<<unknown>>";
                                      fi;
                                  end);
                        lres.conjunction_of := ff;
                        lres.name := (NameFunction(v));
                        lres.aka := [n];
                                        AddDictionary(objs, v, lres);
                        Add(res, lres);
                    else
                #        Print("strange: ", n, " ", v);
                    fi;
                else
                    Add(notcovered, n);
                fi;
            fi;
        fi;
    od;
    Print("   done\n");
    return [res, notcovered];
end;


# Write the graph of type info to JSon file
GAPTypesToJson := function(file)
    local fd, n, typeinfo;

    fd := IO_File(file, "w");
    if fd = fail then
        Error("Opening file ", file, "failed.");
    fi;
    typeinfo := GAPTypesInfo();
    n := IO_Write(fd, GapToJsonString(typeinfo[1]));
    IO_Close(fd);

    return n;
end;

GAPTypesToJson("gaptypes.json");
QUIT_GAP(0);

InstallGlobalFunction(MITM_InstallMitMCDHandlers,
function()
    local cd;

    for cd in ["grp", "trans"] do
        OMsymRecord.(cd) := rec()
    od;
end);


