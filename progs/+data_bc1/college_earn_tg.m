function collEarnS = college_earn_tg(n79S, tgS, cS)
% College earnings
% Scaled to be stationary

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Average earnings
%  should be 1st 2 years in college
collEarnS.mean_qcM = nan([nIq, cS.nCohorts]);
collEarnS.mean_ycM = nan([nYp, cS.nCohorts]);
collEarnS.mean_cV = nan([cS.nCohorts, 1]);



%% NLSY79

collEarnS.mean_qcM(:, tgS.icNlsy79) = n79S.median_earnings_2yr_byafqt ./ tgS.nlsyCpiFactor;
collEarnS.mean_ycM(:, tgS.icNlsy79) = n79S.median_earnings_2yr_byinc ./ tgS.nlsyCpiFactor;

% Average earnings across all students
collEarnS.mean_cV(tgS.icNlsy79) = n79S.median_earnings_2yr ./ tgS.nlsyCpiFactor;



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
