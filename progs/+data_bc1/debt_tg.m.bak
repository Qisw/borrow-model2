function debtS = debt_tg(tgS, cS)
% Construct debt targets

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);



%% Aggregate debt

% Average debt across all students
% Not at end of college but across all enrolled students
debtS.debtMean_cV = nan([cS.nCohorts, 1]);

% Trends in student aid
loadS = var_load_bc1(cS.vStudentDebtData, cS);

% Take average debt at year 2 in college 
%  Early cohorts have 0 debt (year 1)
yearCollegeV = cS.cohortS.yearStartCollegeV + 2;

% Detrend
[~, detrendV] = data_bc1.detrending_factors(yearCollegeV, cS.setNo);

yrIdxV = max(1, yearCollegeV - loadS.yearV(1) + 1);
debtS.debtMean_cV = loadS.avgDebtV(yrIdxV) ./ detrendV;

validateattributes(debtS.debtMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
   'size', [cS.nCohorts, 1]})




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




%% NLSY79

for ic = [tgS.icNlsy79, tgS.icNlsy97]
   if ic == tgS.icNlsy79
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy79_targets_load(cS);
      % Detrend using this factor
      nlsyFactor = tgS.nlsyCpiFactor;
   elseif ic == tgS.icNlsy97
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy97_targets_load(cS);
      % Detrend using this factor
      nlsyFactor = tgS.nlsy97CpiFactor;
   else
      error('Invalid');
   end


   % Fraction in debt at end of college (dropouts, grads)
   debtS.debtFracEndOfCollege_scM(:,ic) = [n79S.dropouts_share_with_loans; n79S.grads_share_with_loans];

   % Mean debt at end of college (conditional on being in debt)
   debtS.debtMeanEndOfCollege_scM(:,ic) = ...
      [n79S.mean_dropouts_loans; n79S.mean_grads_loans] ./ nlsyFactor;
   % Make not conditional 
   debtS.debtMeanEndOfCollege_scM(:,ic) = ...
      debtS.debtMeanEndOfCollege_scM(:,ic) .* debtS.debtFracEndOfCollege_scM(:,ic);


   % By IQ
   debtS.fracGrads_qcM(:,ic) = n79S.grads_share_with_loans_byafqt;
   % Not conditional mean
   debtS.meanGrads_qcM(:,ic) = n79S.grads_mean_loans_byafqt .* debtS.fracGrads_qcM(:,ic) ...
      ./ nlsyFactor;

   % End of college
   debtS.debtFracEndOfCollege_qcM(:,ic) = n79S.share_with_loans_byafqt;
   debtS.debtMeanEndOfCollege_qcM(:,ic) = n79S.mean_loans_byafqt(:) .* debtS.debtFracEndOfCollege_qcM(:,ic) ...
      ./ nlsyFactor;



   % By yP
   debtS.fracGrads_ycM(:,ic) = n79S.grads_share_with_loans_byinc;
   debtS.meanGrads_ycM(:,ic) = n79S.grads_mean_loans_byinc .* debtS.fracGrads_ycM(:,ic) ...
      ./ nlsyFactor;


   debtS.debtFracEndOfCollege_ycM(:,ic) = n79S.share_with_loans_byinc;
   debtS.debtMeanEndOfCollege_ycM(:,ic) = n79S.mean_loans_byinc(:) .* debtS.debtFracEndOfCollege_ycM(:,ic) ...
      ./ nlsyFactor;
end



%% Output check

validateattributes(debtS.debtFracEndOfCollege_scM(~isnan(debtS.debtFracEndOfCollege_scM)), {'double'}, ...
   {'nonempty', 'real', 'positive', '<', 0.8})
validateattributes(debtS.debtMeanEndOfCollege_scM(~isnan(debtS.debtMeanEndOfCollege_scM)), {'double'}, ...
   {'nonempty', 'real',  'positive', '<', 2e4 ./ cS.unitAcct})
validateattributes(debtS.debtFracEndOfCollege_qcM(~isnan(debtS.debtFracEndOfCollege_qcM)), {'double'}, ...
   {'nonempty', 'real', 'positive', '<', 2e4 ./ cS.unitAcct,  '<', 1})


end