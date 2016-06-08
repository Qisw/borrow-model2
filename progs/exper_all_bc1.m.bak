function exper_all_bc1(runStr, setNo)
% Run all experiments that do not require recalibration
%{
Need to first calibrate model for all cohorts!

IN
   runStr
      which experiments to run
      [] is the same as 'all'
%}

cS = const_bc1(setNo);

if isempty(runStr)
   runStr = 'all';
end

iCohortV = cS.cohortS.activeIdxV(:)';

% Calibrate time varying parameters for other cohorts
if strcmp(runStr, 'all')  ||  strcmp(runStr, 'timeseries')
   for iCohort = iCohortV
      if ~isnan(cS.expS.bYearExpNoV(iCohort))
         calibr_bc1.calibr('fminsearch', setNo, cS.expS.bYearExpNoV(iCohort));
      end
   end
end
   

% Counterfactuals
if strcmp(runStr, 'all')  ||  strcmp(runStr, 'decomp')
   expNoV = cS.expS.decomposeExpNoM(:, iCohortV);
   for expNo2 = expNoV(:)'
      if ~isnan(expNo2)
         exper_bc1(setNo, expNo2);
      end
   end
end


% Cumulative changes for decomposition
if strcmp(runStr, 'all')  ||  strcmp(runStr, 'cumul')
   expNoV = cS.expS.decomposeCumulExpNoM(:, iCohortV);
   for expNo2 = expNoV(:)'
      if ~isnan(expNo2)
         exper_bc1(setNo, expNo2);
      end
   end
end


% Pure comparative statics
if strcmp(runStr, 'all')  ||  strcmp(runStr, 'compstat')
   for expNo2 = cS.expS.compStatExpNoV(:)'
      exper_bc1(setNo, expNo2);
   end
end

end