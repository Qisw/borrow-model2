function outS = college_hours(tgS, cS)
% Calibration targets: hours in college

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Annual hours for total time endowment that is split between work and leisure
outS.timeEndow = cS.dataS.timeEndow;


%% Allocate outputs

outS.hoursMean_qcM = nan([nIq, cS.nCohorts]);
outS.hoursMean_ycM = nan([nYp, cS.nCohorts]);
outS.hoursMean_cV = nan([cS.nCohorts, 1]);


%% NLSY79 and 97

for ic = [tgS.icNlsy79, tgS.icNlsy97]
   if ic == tgS.icNlsy79
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy79_targets_load(cS);
   elseif ic == tgS.icNlsy97
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy97_targets_load(cS);
   else
      error('Invalid');
   end

   outS.hoursMean_qcM(:, ic) = n79S.mean_hours_byafqt ./ outS.timeEndow;
   outS.hoursMean_ycM(:, ic) = n79S.mean_hours_byinc ./ outS.timeEndow;

   % outS.hoursMean_cV(ic) = n79S.mean_hours ./ outS.timeEndow;
end


%%  Implied
% Average hours across all students
% Where possible set from hours by q or y (for consistency

for iCohort = 1 : cS.nCohorts
   if isnan(tgS.schoolS.frac_sycM(1, 1, iCohort))  ||  isnan(outS.hoursMean_ycM(1,iCohort))
      % Set to 20 hours per week (based on vague data). With 1/3 of students working
      outS.hoursMean_cV(iCohort) = cS.dataS.hoursPerWeekDefault * 52 ./ outS.timeEndow;
   else
      % Set from hours by yp
      mass_yV = sum(tgS.schoolS.frac_sycM(cS.iCD : cS.nSchool, :, iCohort), 1);
      outS.hoursMean_cV(iCohort) = sum(outS.hoursMean_ycM(:,iCohort) .* mass_yV(:)) ./ sum(mass_yV);
      
      % Alternative calculation should give same result
      mass_qV = sum(tgS.schoolS.frac_sqcM(cS.iCD : cS.nSchool, :, iCohort), 1);
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