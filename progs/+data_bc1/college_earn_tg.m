function collEarnS = college_earn_tg(tgS, cS)
% College earnings


%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Average earnings
%  should be 1st 2 years in college
collEarnS.mean_qcM = nan([nIq, cS.nCohorts]);
collEarnS.mean_ycM = nan([nYp, cS.nCohorts]);
collEarnS.mean_cV = nan([cS.nCohorts, 1]);



%% NLSY79 and 97

for ic = [tgS.icNlsy79, tgS.icNlsy97]
   if ic == tgS.icNlsy79
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy79_targets_load(cS);
      dFactor = tgS.nlsyCpiFactor;
   elseif ic == tgS.icNlsy97
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy97_targets_load(cS);
      dFactor = tgS.nlsy97CpiFactor;
   else
      error('Invalid');
   end


   collEarnS.mean_qcM(:, ic) = n79S.median_earnings_2yr_byafqt ./ dFactor;
   collEarnS.mean_ycM(:, ic) = n79S.median_earnings_2yr_byinc ./ dFactor;

   % Average earnings across all students
   collEarnS.mean_cV(ic) = n79S.median_earnings_2yr ./ dFactor;
end



%% Implied

% Where missing: impute from values by yp
for iCohort = 1 : cS.nCohorts
   if isnan(collEarnS.mean_cV(iCohort))  &&  ~isnan(collEarnS.mean_ycM(1,iCohort))
      massV = sum(sum(tgS.schoolS.frac_sqycM(cS.iCD : cS.nSchool, :, :, iCohort), 1), 2);
      massColl_yV = squeeze(massV);
      validateattributes(massColl_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nYp,1]})
      
      collEarnS.mean_cV(iCohort) = sum(massColl_yV .* collEarnS.mean_ycM(:,iCohort)) ./ sum(massColl_yV);

      % Check
      % Alternative calculation
      massV = sum(sum(tgS.schoolS.frac_sqycM(cS.iCD : cS.nSchool, :, :, iCohort), 1), 3);
      massColl_qV = squeeze(massV);
      meanAlt = sum(massColl_qV .* collEarnS.mean_qcM(:,iCohort)) ./ sum(massColl_qV);
      if abs(meanAlt / collEarnS.mean_cV(iCohort) - 1) > 1e-2
         error_bc1('Mean earnings not consistent', cS);
      end
   end
end

end
