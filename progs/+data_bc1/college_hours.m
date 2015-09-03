function outS = college_hours(n79S, tgS, cS)
% Calibration targets: hours in college

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);
[~, icNlsy79] = min(abs(cS.bYearV - 1961));

% Annual hours for total time endowment that is split between work and leisure
% 16 hours per day - study time (Babcock Marks) -> 90 hours per week
% outS.timeEndow = 16 * 365 - 32 * 35.6
% how to set this? +++
outS.timeEndow = 52 * 84;


%% Allocate outputs

outS.hoursMean_qcM = nan([nIq, cS.nCohorts]);
outS.hoursMean_ycM = nan([nYp, cS.nCohorts]);
outS.hoursMean_cV = nan([cS.nCohorts, 1]);


%% NLSY79

outS.hoursMean_qcM(:, icNlsy79) = n79S.mean_hours_byafqt ./ outS.timeEndow;
outS.hoursMean_ycM(:, icNlsy79) = n79S.mean_hours_byinc ./ outS.timeEndow;

% outS.hoursMean_cV(icNlsy79) = n79S.mean_hours ./ outS.timeEndow;


%%  Implied
% Average hours across all students
% Where possible set from hours by q or y (for consistency

for iCohort = 1 : cS.nCohorts
   if isnan(tgS.schoolS.fracEnter_ycM(1,iCohort))  ||  isnan(outS.hoursMean_ycM(1,iCohort))
      % Set to 20 hours per week (based on vague data). With 1/3 of students working
      outS.hoursMean_cV(iCohort) = 20 / 3 * 50 ./ outS.timeEndow;
   else
      % Set from hours by yp
      mass_yV = tgS.schoolS.fracEnter_ycM(:, iCohort) .* cS.pr_ypV;
      outS.hoursMean_cV(iCohort) = sum(outS.hoursMean_ycM(:,iCohort) .* mass_yV(:)) ./ sum(mass_yV);
      
      % Alternative calculation should give same result
      mass_qV = tgS.schoolS.fracEnter_qcM(:, iCohort) .* cS.pr_iqV;
      hoursMean = sum(outS.hoursMean_qcM(:,iCohort) .* mass_qV(:)) ./ sum(mass_qV);
      if abs(outS.hoursMean_cV(iCohort) - hoursMean) / hoursMean > 1e-2
         error_bc1('Mean hours not consistent', cS);
      end
   end
end


%% Output Check

idxV = find(~isnan(outS.hoursMean_qcM(1,:)));
if ~isempty(idxV)
   validateattributes(outS.hoursMean_ycM(:,idxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 1})
   validateattributes(outS.hoursMean_qcM(:,idxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 1})
end
validateattributes(outS.hoursMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [cS.nCohorts, 1]})
      

end