InstallGlobalFunction(MitM_ATPToRec,
function(atp)
    local i, res;

    res := rec();

    for i in [1,3..Length(atp.content)-1] do
        res.( atp.content[i].attributes.name ) :=
            EvalString(MitM_OMRecToGAPFuncNC(atp.content[i+1]).result);
    od;
    return res;
end);

InstallGlobalFunction(MitM_RecToATP,
function(r)
    return rec( name := "OMATP"
              , content := Concatenation(
                           List( NamesOfComponents(r)
                               , n -> [ OMS("scscp1", n)
                                      , MitM_GAPToOMRec(r.(n)) ] ) ) );
end);

InstallGlobalFunction(OMOBJ,
function(content)
    return Objectify( MitM_OMRecType
                    , rec( name := "OMOBJ"
                         , attributes := rec( version := "2.0" )
                         , content := content ) );
end);

InstallGlobalFunction(OMA,
function(oms, args...)
    return Objectify( MitM_OMRecType
                    , rec( name := "OMA"
                         , content := Concatenation( [ oms ], args ) ) );
end);

InstallGlobalFunction(OMS,
function(args...)
    local res;

    res := rec( name := "OMS"
              , attributes := rec( ) );

    if Length(args) = 2 then
        res.attributes.cd := args[1];
        res.attributes.name := args[2];
    elif Length(args) = 3 then
        res.attributes.cdbase := args[1];
        res.attributes.cd := args[2];
        res.attributes.name := args[3];
    else
        return fail;
    fi;
    return Objectify(MitM_OMRecType, res);
end);

InstallGlobalFunction(MitM_SimpleOMS,
obj_name -> OMS(MitM_cdbase, "lib", obj_name));

InstallGlobalFunction(OMATTR,
function(attr, content)
    return Objectify( MitM_OMRecType
                    , rec( name := "OMATTR"
                         , content := [ MitM_RecToATP(attr)
                                      , content ] ) );
end);

InstallGlobalFunction(OMSTR,
function(string)
    if IsEmptyString(string) then
        return Objectify( MitM_OMRecType
                        , rec( name := "OMSTR"
                             , content := [ ] ) );
    else
        return Objectify( MitM_OMRecType
                        , rec( name := "OMSTR"
                             , content := [ string ] ) );
    fi;
end);

InstallGlobalFunction(OMI,
function(int)
    return Objectify( MitM_OMRecType
                    , rec( name := "OMI"
                         , content := [ String(int) ] ) );
end);

InstallGlobalFunction(OMF,
function(float)
    return Objectify( MitM_OMRecType
                    , rec( name := "OMF"
                         , attributes := rec( dec := String(float) ) ) );
end);

InstallGlobalFunction(OME,
function(oms, content)
    return Objectify( MitM_OMRecType
                    , rec( name := "OME"
                         , content := Concatenation( [oms], content ) ) );
end);

InstallMethod(ViewString, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if r!.name = "OMS" then
        if IsBound(r!.attributes.cdbase) then
            return StringFormatted( "OMS(cd=\"{}\", cdbase=\"{}\", name=\"{}\")"
                                  , r!.attributes.cd, r!.attributes.cdbase, r!.attributes.name );
        else
            return StringFormatted( "OMS(cd=\"{}\", name=\"{}\")"
                                  , r!.attributes.cd, r!.attributes.name );
        fi;
    elif r!.name = "OMA" then
        return StringFormatted( "OMA({})"
                              , JoinStringsWithSeparator(List(r!.content, ViewString), ",") );
    elif r!.name = "OMSTR" then
        return StringFormatted( "OMSTR(\"{}\")", r!.content[1] );
    elif r!.name = "OMI" then
        return StringFormatted( "OMI({})", r!.content[1] );
    elif r!.name = "OMF" then
        # TODO: this is not really right yet
        return StringFormatted( "OMF({})", r!.attributes.dec );
    else
        return StringFormatted( "ViewString for {} not implemented", r!.name );
    fi;
end);

InstallMethod(ViewObj, "for an omrec",
              [MitM_OMRecRep],
function(r)
    Print(ViewString(r));
end);

InstallMethod( MitM_Tag, "for an omrec",
               [MitM_OMRecRep],
r -> r!.name);

InstallMethod(MitM_Attributes, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if IsBound(r!.attributes) then
        return r!.attributes;
    else
        return rec();
    fi;
end);

InstallMethod(MitM_CD, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if r!.name = "OMS" then
        return r!.attributes.name;
    else
        return fail;
    fi;
end);

InstallMethod(MitM_CD, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if r!.name = "OMS" then
        return r!.attributes.cd;
    else
        return fail;
    fi;
end);

InstallMethod(MitM_CDBase, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if r!.name = "OMS" and IsBound(r!.attributes.cdbase) then
        return r!.attributes.cdbase;
    else
        return fail;
    fi;
end);

InstallMethod(MitM_Content, "for an omrec",
              [MitM_OMRecRep],
function(r)
    if IsBound(r!.content) then
        return r!.content;
    else
        return fail;
    fi;
end);


