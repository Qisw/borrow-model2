function show_params

cS = rfm1_bc1.Const;
nq = length(cS.qClUbV);
ny = length(cS.yClUbV);

c0S = const_bc1(cS.setNo, cS.expNo);
tgS = var_load_bc1(c0S.vCalTargets, c0S);
% frac_sV = tgS.schoolS.frac_scM(:, cS.iCohort);

paramS = var_load_bc1(c0S.vRfmParameters, c0S);
calResultS = var_load_bc1(c0S.vRfmSolution, c0S);


%% Show calibrated parameters

%structLH.show(paramS, 'alpha');
pvector = paramS.pvector;
pStringV = pvector.calibrated_values(paramS, 1);
display_lh.show_string_array(pStringV, 80, cS.dbg);

fprintf('\nConditioning on IQ reduces Var(a | info) from %.2f to %.2f  (factor %.2f) \n', ...
   calResultS.solBaseS.condVarAbilNoIq, calResultS.solBaseS.condVarAbil, ...
   calResultS.solBaseS.condVarAbil ./ calResultS.solBaseS.condVarAbilNoIq);


%% Correlation matrix

fprintf('\nCorrelation matrix of endowments\n');

cM = statsLH.CovMatrix(calResultS.solBaseS.covM, cS.endowNameV);

disp(cM.cell_array('%.2f'))


end