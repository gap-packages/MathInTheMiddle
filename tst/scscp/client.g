LoadPackage("scscp");
GetAllowedHeads("localhost", 26133);
EvaluateBySCSCP("MitM_Evaluate", [ 1 ], "localhost", 26133);
