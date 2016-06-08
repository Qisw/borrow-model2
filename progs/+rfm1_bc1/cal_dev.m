function [dev, outS] = cal_dev(paramS, tgS, cS)
% Deviation from calibration targets
%{
IN
   paramS :: CalParams
      calibrated parameter object
   tgS
      calibration targets
   cS
      constants
%}

rTime = randomLH.rand_time;

conditionOnIq = true;
outS = rfm1_bc1.solve(conditionOnIq, tgS.schoolS.frac_scM(:, cS.iCohort), paramS, cS);


%% Deviations

% How much does conditioning on IQ reduce var(a)?
devVarAbilNoIq = (cS.varAbilNoIqFactor - outS.condVarAbil ./ outS.condVarAbilNoIq) .^ 2;


% frac s|q and frac s|y

devM = outS.frac_sqM - tgS.schoolS.frac_sqcM(:,:,cS.iCohort);
devSQ = sum(devM(:) .^ 2);

devM = outS.frac_syM - tgS.schoolS.frac_sycM(:,:,cS.iCohort);
devSY = sum(devM(:) .^ 2);

dev = devSQ + devSY + devVarAbilNoIq;
validateattributes(dev, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})


%% Show
if rTime < 0.1
   fprintf('\nDeviation %.3g \n', dev);
   fprintf('  Dev sq: %.3g    sy: %.3g    varAbilNoIq: %.3g \n',   devSQ, devSY, devVarAbilNoIq);   
end


end