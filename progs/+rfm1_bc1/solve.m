function outS = solve(conditionOnIq, frac_sV, paramS, cS)
% Solve model given parameters and school fractions
%{
IN
   conditionOnIq :: logical
      does hh condition on IQ when choosing s?
   frac_sV
      target school fractions
%}

n = cS.nEndow;

% Make blank solution object
outS = rfm1_bc1.Solution;


%% Multivariate Normal object

% Marginals do not matter
mS = randomLH.MultiVarNormal(zeros(n, 1), ones(n,1));
% Make lower triangular weight matrix from calibrated params
wtM = paramS.weight_matrix(cS);
% Implied cov matrix
outS.covM = mS.cov_from_weights(wtM, cS.dbg);
% Draw endowments
rng(251);
randM = mS.draw_given_weights(cS.nSim, wtM, cS.dbg);


%% Compute E(a | other vars)

% Condition on everything but a
idxCondV = 1 : n;
idxCondV(cS.idxA) = [];

% Same without IQ
idxCondNoIqV = 1 : n;
idxCondNoIqV([cS.idxA, cS.idxQ]) = [];

outS.eaV = zeros(cS.nSim, 1);
if conditionOnIq
   % Hh conditions on IQ
   for i1 = 1 : cS.nSim
      outS.eaV(i1) = mS.conditional_distrib(idxCondV, randM(i1, idxCondV), outS.covM, cS.dbg);
   end
else
   % Same without IQ
   for i1 = 1 : cS.nSim
      aMeanV = mS.conditional_distrib(idxCondNoIqV, randM(i1, idxCondNoIqV), outS.covM, cS.dbg);
      outS.eaV(i1) = aMeanV(cS.idxA);
   end
end
validateattributes(outS.eaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nSim, 1]})


%% How much does conditioning on IQ reduce var(a)?

[~, outS.condVarAbil] = mS.conditional_distrib(idxCondV, randM(i1, idxCondV), outS.covM, cS.dbg);
[~, condVarNoIqV] = mS.conditional_distrib(idxCondNoIqV, randM(i1, idxCondNoIqV), outS.covM, cS.dbg);
% Indexing is not quite right here, but it works when idxA = 1
assert(cS.idxA == 1);
outS.condVarAbilNoIq = condVarNoIqV(cS.idxA);

% devVarAbilNoIq = (cS.varAbilNoIqFactor - outS.condVarAbil ./ outS.condVarAbilNoIq) .^ 2;


%% Assign schooling, IQ, yp groups

cumFracSV = cumsum(frac_sV);
cumFracSV(end) = 1;
outS.sClassV = distrib_lh.class_assign(outS.eaV, [], cumFracSV, cS.dbg);
validateattributes(outS.sClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', cS.nSchool})

outS.yClassV = distrib_lh.class_assign(randM(:, cS.idxY), [], cS.yClUbV, cS.dbg);
validateattributes(outS.yClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', length(cS.yClUbV)})

outS.qClassV = distrib_lh.class_assign(randM(:, cS.idxQ), [], cS.qClUbV, cS.dbg);
validateattributes(outS.qClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', length(cS.qClUbV)})


%% Compute frac s,q and frac s,y

outS.frac_sqM = accumarray([outS.sClassV, outS.qClassV], 1) ./ cS.nSim;

outS.frac_syM = accumarray([outS.sClassV, outS.yClassV], 1) ./ cS.nSim;

% Mean q | s
outS.iqMean_sV = accumarray(outS.sClassV, randM(:, cS.idxQ), [cS.nSchool, 1], @mean);
validateattributes(outS.iqMean_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nSchool, 1]})

if cS.dbg > 10
   for iSchool = 1 : cS.nSchool
      sIdxV = find(outS.sClassV == iSchool);
      checkLH.approx_equal(mean(randM(sIdxV, cS.idxQ)), outS.iqMean_sV(iSchool), 1e-5, []);
   end
end


%% Diagnostics
if 1
   corrM = corrcoef(outS.eaV, randM(:, cS.idxA));
   fprintf('Corr a, E(a): %.3f \n', corrM(1,2));
   corrM = corrcoef(randM(:, cS.idxQ),  outS.eaV);
   fprintf('Corr q, E(a): %.3f \n', corrM(1,2));
   corrM = corrcoef(randM(:, cS.idxQ),  outS.sClassV);
   fprintf('Corr q, s: %.3f \n', corrM(1,2));

   fprintf('Regress a on E(a): \n');
   mdl = fitlm(outS.eaV,  randM(:, cS.idxA))
end

end