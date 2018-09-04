#!
#! @Chapter OpenMath
#!
#! We define an abstract syntax representation of openmath objects.
#!

DeclareGlobalVariable("MitM_Evaluators");
DeclareGlobalFunction("MitM_OMRecToGAPNC");

#!
#! @Description
#! Converts an OpenMath Record to a GAP Object. Currently only supports a
#! limited number of Math in the Middle interface CDs
DeclareOperation("MitM_OMRecToGAP", [IsObject]);



##
DeclareGlobalVariable("MitM_EvalToFunction");
DeclareGlobalFunction("MitM_OMRecToGAPFuncNC");

DeclareOperation("MitM_OMRecToGAPFunc", [IsObject]);

