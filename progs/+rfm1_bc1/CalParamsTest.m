function CalParamsTest
% Only syntax testing is required. The class just does housekeeping.

cS = rfm1_bc1.Const;

paramS = rfm1_bc1.CalParams;
paramS.initialize_random;
paramS.validate;
paramS.weight_matrix(cS);

pv = paramS.pvector;

end