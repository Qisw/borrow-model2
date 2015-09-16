function costS = coll_cost_tg(tgS, cS)
% College cost targets
% Scaled to be stationary

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

costS.pMean_cV = nan([cS.nCohorts, 1]);
costS.pStd_cV  = nan([cS.nCohorts, 1]);
% costS.pNobs_cV = nan([cS.nCohorts, 1]);
costS.pMean_qcM = nan([nIq, cS.nCohorts]);
costS.pMean_ycM = nan([nYp, cS.nCohorts]);


%% Time series

% Means are available for all cohorts (constant prices)
loadS = var_load_bc1(cS.vCollCosts, cS);

for iCohort = 1 : cS.nCohorts
   % Year from which college costs are taken
   cYear = helper_bc1.year_from_age(cS.dataS.collCostAge, cS.bYearV(iCohort));
   [~, dFactor] = data_bc1.detrending_factors(cYear, cS.setNo);
   costS.pMean_cV(iCohort) = loadS.tuitionV(loadS.yearV == cYear) ./ dFactor;
end

% HS&B data, from gradpred, year 2 in college; men
% %  Mean is fairly close to Herrington series
% costS.pMean_cV(icHSB) = 3892 ./ hsbCpiFactor ./ cS.unitAcct;
% costS.pStd_cV(icHSB)  = 4397 ./ hsbCpiFactor ./ cS.unitAcct;
% % costS.nObs_cV(icHSB)  = 1609;
% Take ratio of std / mean
hsbStdToMean = 4397 / 3892;

% Assume std/mean stays constant over time
   % not any more (2015 july 7)
costS.pStd_cV(tgS.icNlsy79) = hsbStdToMean .* costS.pMean_cV(tgS.icNlsy79);

validateattributes(costS.pMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   '>', 100 ./ cS.unitAcct, '<', 1e4 ./ cS.unitAcct, 'size', [cS.nCohorts, 1]})


%%  NLSY79
% Not clear how to scale that consistently with the time series

% Mean p by IQ
% NELS (gradpred, Table 17)
% pMeanV = [3550; 3362; 3449; 4119];
% costS.pMean_qcM(:,icHSB) = pMeanV(:) ./ hsbCpiFactor;

% Need to construct by yp (if used)

end