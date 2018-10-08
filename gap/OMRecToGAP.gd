#!
#! @Chapter OpenMath
#!
#! We define an abstract syntax representation of openmath objects.
#!


#! @Section OMRec
#!
#! @Description
#!   Attempts to convert an OpenMath Record to a GAP Object. Currently only
#!   supports a limited number of Math in the Middle interface CDs.  The
#!   argument <A>r</A> can be obtained from an XML string using
#!   <Ref Func="MitM_XMLToOMRec" />
#!
#!   As output, this function returns a record containing some of the following
#!   components, which describe the outcome of the conversion attempt:
#!     * <C>success</C>: a boolean describing whether the request was
#!       successfully received by the server;
#!     * <C>result</C>: body of the information sent by the server (only if
#!       <C>success = true</C>);
#!     * <C>error</C>: human-readable string saying what went wrong (only if
#!       <C>success = false</C>).
#!
#! @Arguments r
#! @Returns
#!   a record
#!
DeclareGlobalVariable("MitM_Evaluators");
DeclareGlobalVariable("MitM_EvalToFunction");
DeclareGlobalFunction("MitM_OMRecToGAPNC");
DeclareOperation("MitM_OMRecToGAP", [IsObject]);

DeclareGlobalFunction("MitM_Error");
DeclareGlobalFunction("MitM_Result");
