function counterfactuals

cS = rfm1_bc1.Const;

c0S = const_bc1(cS.setNo, cS.expNo);
tgS = var_load_bc1(c0S.vCalTargets, c0S);
frac_sV = tgS.schoolS.frac_scM(:, cS.iCohort);

paramS = var_load_bc1(c0S.vRfmParameters, c0S);
calResultS = var_load_bc1(c0S.vRfmSolution, c0S);
outS = calResultS.solBaseS;

% Check solution
out2S = rfm1_bc1.solve(true, frac_sV, paramS, cS);
checkLH.approx_equal(outS.frac_sqM, out2S.frac_sqM, 1e-4, []);

% Recompute without conditioning on IQ
out2S = rfm1_bc1.solve(false, frac_sV, paramS, cS);

fprintf('E(IQ | s) baseline:    ');
fprintf('%8.2f', outS.iqMean_sV);
fprintf('\n');
fprintf('E(IQ | s) no IQ:       ');
fprintf('%8.2f', out2S.iqMean_sV);
fprintf('\n');

fprintf('\nE(y | s) baseline:    ');
fprintf('%8.2f', outS.yMean_sV);
fprintf('\n');
fprintf('E(y | s) no IQ:       ');
fprintf('%8.2f', out2S.yMean_sV);
fprintf('\n');
% keyboard;

end