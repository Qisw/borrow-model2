function debtS = debt_tg(tgS, cS)
% Construct debt targets

icNlsy79 = tgS.icNlsy79;
nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Load file with all NLSY79 targets
n79S = data_bc1.nlsy79_targets_load(cS);
% Detrend using this factor
nlsyFactor = tgS.nlsyCpiFactor;


%% Allocate outputs

% Fraction with debt at end of college (cd, cg)
debtS.debtFracEndOfCollege_scM = nan([2, cS.nCohorts]);
% Mean debt (not conditional on having debt)
debtS.debtMeanEndOfCollege_scM = nan([2, cS.nCohorts]);

% At end of college
debtS.debtFracEndOfCollege_qcM = nan([nIq, cS.nCohorts]);
debtS.debtMeanEndOfCollege_qcM = nan([nIq, cS.nCohorts]);

% Loans of grads at end of college
debtS.fracGrads_qcM = nan([nIq, cS.nCohorts]);
debtS.meanGrads_qcM = nan([nIq, cS.nCohorts]);
debtS.fracGrads_ycM = nan([nYp, cS.nCohorts]);
debtS.meanGrads_ycM = nan([nYp, cS.nCohorts]);

debtS.debtFracEndOfCollege_ycM = nan([nYp, cS.nCohorts]);
debtS.debtMeanEndOfCollege_ycM = nan([nYp, cS.nCohorts]);

% Average debt across all students
% Not at end of college but across all enrolled students
debtS.debtMean_cV = nan([cS.nCohorts, 1]);



%% NLSY79

% Fraction in debt at end of college (dropouts, grads)
debtS.debtFracEndOfCollege_scM(:,tgS.icNlsy79) = [n79S.dropouts_share_with_loans; n79S.grads_share_with_loans];

% Mean debt at end of college (conditional on being in debt)
debtS.debtMeanEndOfCollege_scM(:,tgS.icNlsy79) = ...
   [n79S.mean_dropouts_loans; n79S.mean_grads_loans] ./ nlsyFactor;
% Make not conditional 
debtS.debtMeanEndOfCollege_scM(:,tgS.icNlsy79) = ...
   debtS.debtMeanEndOfCollege_scM(:,tgS.icNlsy79) .* debtS.debtFracEndOfCollege_scM(:,tgS.icNlsy79);


% By IQ
debtS.fracGrads_qcM(:,icNlsy79) = n79S.grads_share_with_loans_byafqt;
% Not conditional mean
debtS.meanGrads_qcM(:,icNlsy79) = n79S.grads_mean_loans_byafqt .* debtS.fracGrads_qcM(:,icNlsy79) ...
   ./ nlsyFactor;

% End of college
debtS.debtFracEndOfCollege_qcM(:,tgS.icNlsy79) = n79S.share_with_loans_byafqt;
debtS.debtMeanEndOfCollege_qcM(:,tgS.icNlsy79) = n79S.mean_loans_byafqt(:) .* debtS.debtFracEndOfCollege_qcM(:,tgS.icNlsy79) ...
   ./ nlsyFactor;



% By yP
debtS.fracGrads_ycM(:,icNlsy79) = n79S.grads_share_with_loans_byinc;
debtS.meanGrads_ycM(:,icNlsy79) = n79S.grads_mean_loans_byinc .* debtS.fracGrads_ycM(:,icNlsy79) ...
   ./ nlsyFactor;


debtS.debtFracEndOfCollege_ycM(:,tgS.icNlsy79) = n79S.share_with_loans_byinc;
debtS.debtMeanEndOfCollege_ycM(:,tgS.icNlsy79) = n79S.mean_loans_byinc(:) .* debtS.debtFracEndOfCollege_ycM(:,tgS.icNlsy79) ...
   ./ nlsyFactor;


%% Aggregate debt


% Trends in student aid
loadS = var_load_bc1(cS.vStudentDebtData, cS);

% Take average debt at year 2 in college 
%  Early cohorts have 0 debt (year 1)
yearCollegeV = cS.yearStartCollege_cV + 2;

% Detrend
[~, detrendV] = data_bc1.detrending_factors(yearCollegeV, cS.setNo);

yrIdxV = max(1, yearCollegeV - loadS.yearV(1) + 1);
debtS.debtMean_cV = loadS.avgDebtV(yrIdxV) ./ detrendV;

validateattributes(debtS.debtMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
   'size', [cS.nCohorts, 1]})


%% Output check

validateattributes(debtS.debtFracEndOfCollege_scM(~isnan(debtS.debtFracEndOfCollege_scM)), {'double'}, ...
   {'nonempty', 'real', 'positive', '<', 0.8})
validateattributes(debtS.debtMeanEndOfCollege_scM(~isnan(debtS.debtMeanEndOfCollege_scM)), {'double'}, ...
   {'nonempty', 'real',  'positive', '<', 2e4 ./ cS.unitAcct})
validateattributes(debtS.debtFracEndOfCollege_qcM(~isnan(debtS.debtFracEndOfCollege_qcM)), {'double'}, ...
   {'nonempty', 'real', 'positive', '<', 2e4 ./ cS.unitAcct,  '<', 1})


end