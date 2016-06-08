function schoolS = load_project_talent(schoolS, cS)
% Given an xls file with marginal distribution by IQ and YP
% but not the joint
% return the marginals interpolated to cS.iqUbV, cS.ypUbV


%% Load data

iCohort = cS.cohortS.by_name('Project Talent');
bYear = cS.cohortS.bYearV(iCohort);

% CPS school fractions by cohort
cpsS = var_load_bc1(cS.vCohortSchooling, cS);
cpsIdx = find(cpsS.bYearV == bYear);
assert(length(cpsIdx) == 1);

frac_sV = cpsS.frac_scM(:,cpsIdx);
checkLH.prob_check(frac_sV, 1e-6);

schoolS.frac_scM(:, iCohort) = frac_sV;


%% HSD and HSG: Mass(s,q)

hsgTb = readtable('/Users/lutz/Dropbox/borrowing constraints/Calibration targets/data from todd/calibration_targets_pt_hsg.xlsx');

% Rows with marginal by iq
qIdxV = find(~isnan(hsgTb.cum_iq));
% Expecting that no interpolation is needed
checkLH.approx_equal(hsgTb.cum_iq(qIdxV),  cS.iqUbV,  1e-4, []);

% Rows with marginal by yp
yIdxV = find(~isnan(hsgTb.cum_ses));
checkLH.approx_equal(hsgTb.cum_ses(yIdxV),  cS.ypUbV,  1e-4, []);

for iSchool = 1 : cS.iHSG
   if iSchool == cS.iHSD
      numV = hsgTb.num_hsd;
   elseif iSchool == cS.iHSG
      numV = hsgTb.num_hsg;
   else
      error('Invalid');
   end
   
   % Mass(s,q) = n(s,q) / n(s) * frac(s)
   %  Sums to 1 for each cohort (across all [s,q])
   schoolS.frac_sqcM(iSchool, :, iCohort) = numV(qIdxV) ./ sum(numV(qIdxV)) .* frac_sV(iSchool);
   schoolS.frac_sycM(iSchool, :, iCohort) = numV(yIdxV) ./ sum(numV(yIdxV)) .* frac_sV(iSchool);
end


%% Universe HSG
% We have mass HSG, college by [q, y]

% Load each variable and interpolate to common intervals
outS = data_bc1.load_historical_table(...
   '/Users/lutz/Dropbox/borrowing constraints/Calibration targets/data from todd/calibration_targets_pt_coll.xlsx');

% Sums to 1
numHsgPlus_qyM = outS.num_hsg_qyM + outS.num_c_qyM;
schoolS.hsgS.massHsgPlus_qycM(:,:,iCohort) = numHsgPlus_qyM ./ sum(numHsgPlus_qyM(:));
validateattributes(schoolS.hsgS.massHsgPlus_qycM(:,:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'positive', '<', 1})

% Frac enter | HSG
schoolS.hsgS.fracEnter_qycM(:,:,iCohort) = outS.num_c_qyM ./ numHsgPlus_qyM;
validateattributes(schoolS.hsgS.fracEnter_qycM(:,:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'positive', '<', 1})



end