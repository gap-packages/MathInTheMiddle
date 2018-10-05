# ATPToRec
gap> xml := """
> <OMATP>
>   <OMS cd="scscp1" name="call_id" />
>   <OMSTR>symcomp.org:26133:18668:s2sYf1pg</OMSTR>
>   <OMS cd="scscp1" name="option_runtime" />
>   <OMI>300000</OMI>
>   <OMS cd="scscp1" name="option_min_memory" />
>   <OMI>40964</OMI>
>   <OMS cd="scscp1" name="option_max_memory" />
>   <OMI>134217728</OMI>
>   <OMS cd="scscp1" name="option_debuglevel" />
>   <OMI>2</OMI>
>   <OMS cd="scscp1" name="option_return_object" />
>   <OMSTR></OMSTR>
> </OMATP>""";;
gap> r := MitM_XMLToOMRec(xml);;
gap> atprec := MitM_ATPToRec(r);;
gap> atprec = rec(
> call_id := "symcomp.org:26133:18668:s2sYf1pg",
> option_debuglevel := 2,
> option_max_memory := 134217728,
> option_min_memory := 40964,
> option_return_object := "", option_runtime := 300000);
true
gap> Set(MitM_Content(MitM_RecToATP(atprec))) = Set(MitM_Content(r));
true

# OMA function
gap> oma := OMA(OMS(MitM_cdbase, "lib", "Concatenation"),
>               OMSTR("hello"),
>               OMSTR("world"));;
gap> MitM_OMRecToXML(oma) = """<OMA>
> <OMS cd="lib" cdbase="https://www.gap-system.org/mitm/" name="Concatenation" />
> <OMSTR>hello</OMSTR>
> <OMSTR>world</OMSTR>
> </OMA>""";
true

# OMS failures
gap> OMS(1, 2, 3, 4);
fail
gap> OMS(1);
fail
gap> OMS();
fail

# OMATTR
gap> Print(MitM_OMRecToXML(OMATTR(rec(call_id := "abcde"), OMSTR("hello"))),
>          "\n");
<OMATTR>
<OMATP>
<OMS cd="scscp1" name="call_id" />
<OMSTR>abcde</OMSTR>
</OMATP>
<OMSTR>hello</OMSTR>
</OMATTR>

# OME
gap> Print(MitM_OMRecToXML(OME(OMS("scscp1", "error_system_specific"),
>                              [OMSTR("you did something wrong!")])), "\n");
<OME>
<OMS cd="scscp1" name="error_system_specific" />
<OMSTR>you did something wrong!</OMSTR>
</OME>

# MitM_RecToATP function
gap> r := MitM_RecToATP(rec(x := 3, y := 6));
OMATP( rec( x := OMI(3), y := OMI(6) ) )
gap> s := OMATP( rec( x := OMI(3), y := OMI(6) ) );
OMATP( rec( x := OMI(3), y := OMI(6) ) )
gap> r = s;
true
gap> s := OMATP( rec( z := OMI(3), y := OMI(6) ) );
OMATP( rec( y := OMI(6), z := OMI(3) ) )
gap> r = s;
false

# OMRec \< function
gap> OMI(3) < OMI(4);
true
gap> OMI(3) > OMI(4);
false
