#
# MathInTheMiddle: Maths-in-the-Middle functionality for GAP
#
# Type export to JSON for consumation by MMT import
#
# TODO: We need at some point advertise our abilities via
#       OpenMath directly

# Returns the first global variable that is assigned to obj
InstallGlobalFunction(GVarNameForObject,
function( obj )
    local n, res;

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
end);

# Returns a list of all global variables that are assigned to obj
InstallGlobalFunction(GVarNamesForObject,
function( obj )
    local n, res;

    res := [];

    for n in NamesGVars() do
        if IsBoundGlobal(n) then
            if ValueGlobal(n) = obj then
                Add(res, n);
            fi;
        fi;
    od;
    return res;
end);

InstallGlobalFunction( GAPAndFilterUnpack, function(t)
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
end);

# Make GAP Type graph as a record
InstallGlobalFunction(GAPTypesInfo, function()
    local res, lres, i, j, f, ff, a, meths, mpos, objs, m, mres, n, t, notcovered, v, op, loc,
          flags, flagslist;

    objs := NewDictionary(IsObject, true);
    res := [ rec( name := "IsObject", type := "Category", implied := [] ) ];

    Print("exporting operations...\c");
    for i in [1..Length(OPERATIONS)] do
        op := OPERATIONS[i];

        lres := rec();
        AddDictionary(objs, op, lres);

        lres.type := TypeOfOperation(op);
        lres.name := NameFunction(op);

        # Locations in which this operation is declared
        # There can be multiple locations with different filters
        # We convert the GAP representation as a list of pairs
        # into a list of records for the export
        lres.locations := List( GET_DECLARATION_LOCATIONS(op)
                              , x -> rec( file := x[1], line := x[2] ) );

        # This is way too complicated
        # if IsAttribute(op) then
        # elif IsProperty(op) then
        # else
        lres.filters := [];

        # This is a list if argument filters for every declaration
        # for op
        flagslist := GET_OPER_FLAGS(op);
        if flagslist = fail then
        # TODO, and filter? Synonym?
            Print("Op: ", op, " filters need some looking after\n");
        else
            # TODO: clean up
            for flags in flagslist do
                ff := Concatenation(List(flags, x -> List(TRUES_FLAGS(x), z -> FILTERS[z])));
                ff := List(ff, NameFunction);
            od;
        fi;
        lres.methods := rec( 0args := [], 1args := [], 2args := [],
                             3args := [], 4args := [], 5args := [],
                             6args := [] );

        for a in [1..6] do
            meths := METHODS_OPERATION(op, a);

            for j in [1..Int(Length(meths)/(a + 4))] do
                mpos := (j - 1) * (a + 4) + 1;
                mres := rec( filters := List( [1..a]
                                            , argnum -> List(TRUES_FLAGS(meths[mpos + argnum])
                                                            , x -> NameFunction(FILTERS[x]) ) ),
                             rank := meths[mpos + a + 2],
                             comment := meths[mpos + a + 3] );
                # Methods are not bound to global variables directly (usually...)
                # but some methods might be global functions
                AddDictionary(objs, meths[mpos + a + 1], mres);

                Add(lres.methods.(Concatenation(String(a),"args")), mres);
            od;
        od;

        Add(res, lres);
    od;
    Print("   done\n");

    Print("exporting global functions...\c");
    for f in [1..Length(GLOBAL_FUNCTION_NAMES)] do
        lres := rec();
        lres.type := "Function";
        lres.name := GLOBAL_FUNCTION_NAMES[f];
        lres.location := rec();
        AddDictionary(objs, ValueGlobal(GLOBAL_FUNCTION_NAMES[f]), lres);
        Add(res, lres);
    od;
    Print("   done\n");

    Print("collecting global variable references...\c");
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
end);

# Write the graph of type info to JSon file
InstallGlobalFunction(GAPTypesToJson, function(file)
    local fd, n, typeinfo;

    fd := IO_File(file, "w");
    if fd = fail then
        Error("Opening file ", file, "failed.");
    fi;
    typeinfo := GAPTypesInfo();
    n := IO_Write(fd, GapToJsonString(typeinfo[1]));
    IO_Close(fd);

    return n;
end);

