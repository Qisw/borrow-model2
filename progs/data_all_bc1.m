function data_all_bc1(setNo)
%{
Only results_all writes to preamble
Results are stored where they are not overwritten by results_all
%}

cS = const_bc1(setNo);
saveFigures = 1;

% % Cpi data
% data_bc1.cpi_load(setNo);


%% CPS data

% Cohort earnings profiles
go_cpsbc;

% Diagnostic plot: detrending factors versus median cps wage
data_bc1.median_wage_show(saveFigures, setNo);
% Construct cohort earnings profiles. Constant prices. Not detrended.
data_bc1.cohort_earnings_profiles(setNo);
data_bc1.cohort_schooling(setNo);
cd(cS.progDir);


%% Other data

% College costs by year
data_bc1.coll_costs(setNo); 
% Student debt by year
data_bc1.student_debt(setNo);
data_bc1.borrow_limits(setNo);

% Make calibration targets
data_bc1.cal_targets(setNo);
% data_bc1.cal_targets_check(setNo);


%% Show

% Data plots: college costs, cpi
data_bc1.plots(saveFigures, setNo);
data_bc1.cohort_schooling_show(saveFigures, setNo);

% Summarize data targets
for iCohort = 1 : cS.nCohorts
   data_bc1.target_summary(iCohort, setNo);
end

data_bc1.data_summary(setNo);

% data_bc1.cohort_earn_profiles_show(saveFigures, setNo);

% Correlation IQ, yp over time
data_bc1.corr_iq_yp(setNo);

% Entry rates by [q,y], selected studies
data_bc1.qy_entry(saveFigures, setNo);
% Same by [q, y] separately
data_bc1.marginal_entry_rates('iq', saveFigures, setNo);
data_bc1.marginal_entry_rates('yp', saveFigures, setNo);

   
end