function EndowmentsTest

rng(40);
cS = rfm1_bc1.Const;
paramS = rfm1_bc1.CalParams;
paramS.initialize_random;

eS = rfm1_bc1.Endowments(paramS, cS);

eS.covM;

nSim = 1e4;
randM = eS.draw_endowments(nSim);

%% Check conditional mean / variance
for conditionOnIq = [true, false]
   [eaV, condVar] = eS.conditional_distrib_abil(conditionOnIq, randM);

   % Check that E(a) and a are consistent
   dev1 = econLH.regression_test(eaV, randM(:, cS.idxA), ones(size(eaV)), false);
   assert(dev1 < 3);

   % Check conditional variance
   simVar = mean((randM(:, cS.idxA) - eaV) .^ 2);
   checkLH.approx_equal(condVar .^ 0.5, simVar .^ 0.5, 1e-2, []);
end


end