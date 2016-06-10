function [devV, devSQ, devSY] = deviations(outS, tgS, iCohort, cS)
% Deviations from cal targets for 1 cohort
%{
IN
   outS :: Solution
   tgS
      calibration targets, from bc1
   iCohort
      cohort index for which to compute deviations
   cS :: Const
OUT
   devV
      vector of deviations; just sum it get a scalar deviation

No test.
%}


%% Joint distribution (s,q) and (s,y)
% Available for later cohorts

if ~isnan(tgS.schoolS.frac_sqcM(1,1,iCohort))
   devM = outS.frac_sqM - tgS.schoolS.frac_sqcM(:,:,iCohort);
   devSQ = 50 .* mean(devM(:) .^ 2);
else
   devSQ = 0;
end

if ~isnan(tgS.schoolS.frac_sycM(1,1,iCohort))
   devM = outS.frac_syM - tgS.schoolS.frac_sycM(:,:,iCohort);
   devSY = 50 .* mean(devM(:) .^ 2);
else
   devSY = 0;
end


%% HS grad rate and college entry rate
% Available for earlier cohorts

if devSY == 0
   % Only compute this if joint distribution not available
   [devEnterY, devHsgY] = dev_enter_hsg('y', outS, tgS, iCohort, cS);
else
   devEnterY = 0;
   devHsgY = 0;
end

if devSQ == 0
   [devEnterQ, devHsgQ] = dev_enter_hsg('y', outS, tgS, iCohort, cS);
else
   devEnterQ = 0;
   devHsgQ = 0;
end


devV = [devSQ, devSY, devEnterY, devEnterQ, devHsgY, devHsgQ];


end


%% Local: deviations from prob enter, prob hsg
% by q or y
function [devEnter, devHsg] = dev_enter_hsg(caseStr, outS, tgS, iCohort, cS)
   switch caseStr
      case 'q'
         % Mass enter / total mass (given q)
         fracEnter_yV = tgS.schoolS.fracEnter_qcM(:, iCohort);
         % Frac at least HSG (given q)
         fracHsg_yV = tgS.schoolS.fracHsg_qcM(:, iCohort);
         modelEnter_yV = outS.fracEnter_qV;
         modelHsg_yV = outS.fracHsg_qV;
      case 'y'
         fracEnter_yV = tgS.schoolS.fracEnter_ycM(:, iCohort);
         fracHsg_yV = tgS.schoolS.fracHsg_ycM(:, iCohort);
         modelEnter_yV = outS.fracEnter_yV;
         modelHsg_yV = outS.fracHsg_yV;
      otherwise
         error('Invalid');
   end
   

   if all(~isnan(fracEnter_yV))
      devEnter = mean((modelEnter_yV - fracEnter_yV) .^ 2);
   else
      devEnter = 0;
   end
   
   
   if all(~isnan(fracHsg_yV))
      % Model: frac enter | y
      devHsg = mean((modelHsg_yV - fracHsg_yV) .^ 2);
   else
      devHsg = 0;
   end
end