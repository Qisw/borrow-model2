function cal_targets(setNo)
% Make and save calibration targets
%{
All targets are in model units
Not all cohorts have all targets

All dollar figures are scaled to be stationary

Checked: +++
%}

fprintf('\nMaking calibration targets \n');

cS = const_bc1(setNo);
% nYp = length(cS.ypUbV);
% nIq = length(cS.iqUbV);


%% Detrending factors for micro datasets

% *** CPI
cpiS = econ_lh.CpiLH(cS.cpiBaseYear);
cpiYearV = 1920 : 2010;
cpiV = cpiS.retrieve(cpiYearV);

% HS&B cohort = NLSY79 cohort
[~, tgS.icNlsy79] = min(abs(cS.bYearV - 1961));
icHSB = tgS.icNlsy79;
tgS.icHSB = icHSB;
validateattributes(icHSB, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive'})

% HS&B detrending factor (HS&B data are in year 2000 prices), most for around 1982. 
% DIVIDE by this factor
[~, dFactor] = data_bc1.detrending_factors(1982, setNo);
hsbCpiFactor = cpiV(cpiYearV == 2000) ./ cpiV(cpiYearV == cS.cpiBaseYear) .* dFactor;
tgS.hsbCpiFactor = hsbCpiFactor;
validateattributes(hsbCpiFactor, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})

% Divide by this for nlsy results provided by Chris
% Assume that college variables (earnings, etc) occur in 1982
[~, dFactor] = data_bc1.detrending_factors(1982, setNo);
tgS.nlsyCpiFactor = cpiV(cpiYearV == 2010) ./ cpiV(cpiYearV == cS.cpiBaseYear) .* dFactor;

% NLSY97 cohort
[~, tgS.icNlsy97] = min(abs(cS.bYearV - 1979));
tgS.nlsy97CpiFactor = cpiV(cpiYearV == 2010) ./ cpiV(cpiYearV == cS.cpiBaseYear) .* dFactor;

%  Load file with all NLSY79 targets
n79S = data_bc1.nlsy79_targets_load(cS);


%% Sub-functions

tgS.schoolS = data_bc1.school_targets(tgS, cS);

% Joint distribution IQ, yq
tgS.qyS = data_bc1.qy_targets(tgS, cS);

% Lifetime earnings 
tgS.pvEarn_scM = data_bc1.earn_tg(tgS, cS);

tgS.debtS = data_bc1.debt_tg(tgS, cS);

tgS.hoursS = data_bc1.college_hours(tgS, cS);

tgS.collEarnS = data_bc1.college_earn_tg(tgS, cS);

tgS.transferS = data_bc1.transfer_tg(tgS, cS);

tgS.finShareS = data_bc1.finshare_tg(cS);

% Parental income
% We actually use medians to avoid outlier effects
% No longer needed
tgS.ypS = data_bc1.yp_targets(n79S, tgS, cS);

% College costs
tgS.costS = data_bc1.coll_cost_tg(tgS, cS);



%% Borrowing limits

% Borrowing limits at start of each year in college
% detrended, expressed as min assets (<= 0)
tgS.kMin_acM = var_load_bc1(cS.vBorrowLimits, cS);
n1 = size(tgS.kMin_acM, 1);

validateattributes(tgS.kMin_acM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<=', 0, ...
   'size', [n1, cS.nCohorts]})


%% Save


var_save_bc1(tgS, cS.vCalTargets, cS);


end


