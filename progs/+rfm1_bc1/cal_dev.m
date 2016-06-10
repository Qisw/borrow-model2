function [dev, outS, out2S] = cal_dev(paramS, tgS, cS)
% Deviation from calibration targets
%{
IN
   paramS :: CalParams
      calibrated parameter object
   tgS
      calibration targets
   cS :: Const
      constants

OUT
   outS :: Solution
      base cohort
   out2S :: Solution
      early cohort
%}

rTime = randomLH.rand_time;


%% Base cohort

conditionOnIq = true;
outS = rfm1_bc1.solve(conditionOnIq, tgS.schoolS.frac_scM(:, cS.iCohort), paramS, cS);


% Deviations

% How much does conditioning on IQ reduce var(a)?
if cS.tgVarAbilRatio
   devVarAbilNoIq = (cS.varAbilNoIqFactor - outS.condVarAbil ./ outS.condVarAbilNoIq) .^ 2;
else
   devVarAbilNoIq = 0;
end

% Minimum correlation (a, q)
% Cov = corr
corrAQ = outS.covM(cS.idxA, cS.idxQ);
devCorrAQ = max(0, cS.minCorrAQ - corrAQ);

[devBaseV, devSQ, devSY] = rfm1_bc1.deviations(outS, tgS, cS.iCohort, cS);


%% Earlier cohort

iCohort = cS.iCohortEarly;
out2S = rfm1_bc1.solve(false, tgS.schoolS.frac_scM(:, iCohort), paramS, cS);

[devEarlyV] = rfm1_bc1.deviations(out2S, tgS, iCohort, cS);



%% Finish up

dev = sum(devBaseV) + sum(devEarlyV) + devVarAbilNoIq + devCorrAQ;
validateattributes(dev, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})

if rTime < 0.1
   fprintf('\nDeviation %.3g \n', dev);
   fprintf('  Dev sq: %.3g    sy: %.3g    early: %.3g    varAbilNoIq: %.3g    corrAQ: %.3g \n',   ...
      devSQ, devSY, sum(devEarlyV), devVarAbilNoIq, devCorrAQ);   
end


end