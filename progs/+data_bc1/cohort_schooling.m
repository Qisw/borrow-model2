function cohort_schooling(setNo)
% Load schooling by cohort. CPS data
%{
Averages over all available ages. Not good for latest cohort. +++
In calibration, we use "micro" data instead
%}

cS = const_bc1(setNo);

% Allocate outputs
saveS.bYearV = cS.bYearV(1) : cS.bYearV(end);
nBy = length(saveS.bYearV);
saveS.ageRangeV = cS.dataS.cohSchoolAgeRangeV(1) : cS.dataS.cohSchoolAgeRangeV(2);
saveS.frac_scM = nan([cS.nSchool, nBy]);

% Load cps birth year stats
% Not all cohorts have all ages
outS = byear_school_age_stats_cpsbc(saveS.bYearV, saveS.bYearV, saveS.ageRangeV, cS.cpsSetNo);

for iCohort = 1 : nBy
   mass_stM = squeeze(outS.massM(iCohort, :, :));
   tIdxV = find(~isnan(mass_stM(1,:))  &  ~isnan(mass_stM(end,:)));
   mass_sV  = sum(mass_stM(:, tIdxV), 2);
   saveS.frac_scM(:, iCohort) = mass_sV ./ sum(mass_sV);
end

validateattributes(saveS.frac_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 0.05, ...
   '<', 0.8, 'size', [cS.nSchool, nBy]})



var_save_bc1(saveS, cS.vCohortSchooling, cS);


end