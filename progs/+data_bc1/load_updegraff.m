function schoolS = load_updegraff(schoolS, cS)
% Load Updegraff (1936) college entry rates etc
% No info on graduation rates. Can only use CPS to infer the aggregate

%%  Load data

% CPS school fractions by cohort
cpsS = var_load_bc1(cS.vCohortSchooling, cS);

bYear = 1915;
iCohort = find(cS.bYearV == bYear);
if length(iCohort) ~= 1
   error('Not found');
end

% dataFn = 'updegraff_quartiles.csv'; 
% loadS = data_bc1.load_income_iq_college(dataFn, cS.setNo);
loadS = data_bc1.load_historical_table('/Users/lutz/Dropbox/borrowing constraints/Calibration targets/data from todd/calibration_targets_updegraff.xls');


%%  Make fractions
%{ 
These fractions sum 1
Also Interpolate to common intervals
This must respect various constraints
- mass across school groups is mass by [q,y]
- mass of each school group must sum to mass in original data
   this is not possible (without expensive computation)
%}


frac_qyM = cS.pr_iqV * cS.pr_ypV(:)';

% Total no of persons
nTotal = sum(loadS.num_c_qyM(:) + loadS.num_hsd_qyM(:) + loadS.num_hsg_qyM(:));

% Start with HSD
forMidPoints = false;
fracM = loadS.num_hsd_qyM ./ nTotal;
fracHsd = sum(fracM(:));
frac_hsd_qyM = data_bc1.interpolate_qy_matrix(fracM, loadS.iqUbV, loadS.ypUbV, forMidPoints, cS);
% Make sure total mass has not changed
frac_hsd_qyM = frac_hsd_qyM ./ sum(frac_hsd_qyM(:)) .* fracHsd;
% Make sure fraction in higher classes is not negative
min(frac_qyM, frac_hsd_qyM);

% Now interpolate mass hsg + hsd
fracM = (loadS.num_hsd_qyM + loadS.num_hsg_qyM) ./ nTotal;
fracHsg = sum(fracM(:));
frac_hsg_qyM = data_bc1.interpolate_qy_matrix(fracM, ...
   loadS.iqUbV, loadS.ypUbV, forMidPoints, cS);
frac_hsg_qyM = frac_hsg_qyM ./ sum(frac_hsg_qyM(:)) .* fracHsg;
% Cannot be more than total mass in each HSG cell
frac_hsg_qyM = min(frac_hsg_qyM, frac_qyM);

% Fraction college = total - fraction (hsd + hsg)
% fracC = sum(loadS.num_c_qyM(:)) ./ nTotal;
frac_c_qyM = max(0, frac_qyM - frac_hsg_qyM);
% frac_c_qyM = frac_c_qyM ./ sum(frac_c_qyM(:)) .* fracC;

% Fraction HSG = fraction hsd+hsg - fraction hsd
frac_hsg_qyM = max(0, frac_hsg_qyM - frac_hsd_qyM);

% Check that this adds to 1
frac2_qyM = frac_hsd_qyM + frac_hsg_qyM + frac_c_qyM;
check_lh.approx_equal(frac2_qyM, frac_qyM, 1e-2, []);



%%  Directly loaded fields

% % Mass by [s,q,y]. Sums to 1
schoolS.frac_sqycM(cS.iHSD, :,:, iCohort) = frac_hsd_qyM;
schoolS.frac_sqycM(cS.iHSG, :,:, iCohort) = frac_hsg_qyM;

validateattributes(schoolS.frac_sqycM(1 : cS.iHSG, :,:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   '>=', 0, '<=', 1})


%% Implied fields
% No info on graduation rates

% Fraction at least HSG | q or yp
schoolS.fracHsg_qcM(:, iCohort)  = sum(frac_c_qyM + frac_hsg_qyM, 2)  ./ cS.pr_iqV;
schoolS.fracHsg_ycM(:, iCohort)  = sum(frac_c_qyM + frac_hsg_qyM, 1)' ./ cS.pr_ypV;
frac_qyM = cS.pr_iqV(:) * cS.pr_ypV(:)';
schoolS.fracHsg_qycM(:, :, iCohort) = (frac_c_qyM + frac_hsg_qyM) ./ frac_qyM;

% Entry rates (out of HSG)
schoolS.fracEnter_qcM(:,iCohort) = sum(frac_c_qyM, 2) ./ sum(frac_c_qyM + frac_hsg_qyM, 2);
schoolS.fracEnter_ycM(:,iCohort) = sum(frac_c_qyM, 1) ./ sum(frac_c_qyM + frac_hsg_qyM, 1);
schoolS.fracEnter_qycM(:,:,iCohort) = frac_c_qyM ./ (frac_c_qyM + frac_hsg_qyM);

validateattributes(schoolS.fracEnter_qcM(:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   '>=', 0, '<=', 1})
validateattributes(schoolS.fracEnter_ycM(:,iCohort), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   '>=', 0, '<=', 1})

% Mass (HSG+, q, y). Sums to 1 for each cohort
massM = frac_c_qyM + frac_hsg_qyM;
schoolS.massHsgPlus_qycM(:,:,iCohort) = massM ./ sum(massM(:));


%%  School fractions (implied)

frac_sV = zeros(cS.nSchool, 1);
for iSchool = 1 : cS.iHSG
   frac_sV(iSchool) = matrix_lh.sum_all(schoolS.frac_sqycM(iSchool, :,:, iCohort));
end

% Fraction who enters college
fracCollege = 1 - sum(frac_sV(1 : cS.iHSG));

% Graduation rate (CPS)
cpsIdx = find(cpsS.bYearV == bYear);
if length(cpsIdx) ~= 1
   error('Not found');
end
gradRate = cpsS.frac_scM(cS.iCG,cpsIdx) ./ sum(cpsS.frac_scM(cS.iCD : cS.iCG,cpsIdx), 1);

frac_sV(cS.iCD) = fracCollege * (1 - gradRate);
frac_sV(cS.iCG) = fracCollege * gradRate;

check_lh.prob_check(frac_sV, 1e-6);

schoolS.frac_scM(:, iCohort) = frac_sV;


end