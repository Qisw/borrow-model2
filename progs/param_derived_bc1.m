function paramS = param_derived_bc1(paramS, cS)
% Derived parameters
%{
Ref cohort

Checked: 2015-Mar-19
%}

setNo = cS.setNo;
nIq = length(cS.iqUbV);
iCohort = cS.iCohort;

% Calibration targets
tgS = var_load_bc1(cS.vCalTargets, cS);


      % %% Adjust for changed nSchool
      % if length(paramS.phi_sV) == 3
      %    paramS.phi_sV = [0.1; paramS.phi_sV];
      %    paramS.eHat_sV = [paramS.eHat_sV(1); paramS.eHat_sV];
      % end


%% Remove unused params
removeV = {'prGradA0', 'prefPhi',    'mGridV',    'k1_jV' ,     'puWeight' ,    'earn_asM' , ...
    'pvEarn_sV' ,    'taxHSzero' ,     'taxHSslope' ,     'tax_jV' ,     'eHatHSG' , ...
    'eHatCG',     'earn_tsM',    'pvEarn_asM',  'cPvFactor_sV',  'cFactorV',  'sigmaIQ' };
for i1 = 1 : length(removeV)
   if isfield(paramS, removeV{i1})
      paramS = rmfield(paramS, removeV{i1});
   end
end


% Fix all parameters that are not calibrated (doCal no in cS.doCalV)
%  also add missing params
paramS = cS.pvector.struct_update(paramS, cS.doCalV);



%% Parameters taken from data, if not calibrated
% only if always taken from data (never calibrated)
% it does not make sense to have params that are sometimes taken from data
% yp targets are currently time invariant (cal_targets), so this is fine for experiments as well

pNameV    = {'logYpMean', 'logYpStd'};
tgNameV   = {'logYpMean_cV', 'logYpStd_cV'};
tgSubStructV = {'ypS',  'ypS'};
byCohortV = [1, 1];
for i1 = 1 : length(pNameV)
   pName = pNameV{i1};
   % Check whether calibrated
   ps = cS.pvector.retrieve(pName);
   if ps.doCal == cS.calNever
      % Not calibrated. Assumes that this is valid for experiments
      tgV = tgS.(tgSubStructV{i1}).(tgNameV{i1});
      if byCohortV(i1) == 1
         tgV = tgV(iCohort);
      end
      paramS.(pName) = tgV;
   end
end


% If not baseline experiment: copy all parameters that were calibrated in baseline but are not 
% calibrated now from baseline params
if cS.expNo ~= cS.expBase
   c0S = const_bc1(cS.setNo, cS.expBase);
   param0S = var_load_bc1(cS.vParams, c0S);
   paramS = cS.pvector.param_copy(paramS, param0S, cS.calBase);
end



%% Preferences: Derived

if cS.ucCurvatureSame == 1
   % Same curvature of preferences work / college
   paramS.workSigma = paramS.prefSigma;
end


% Utility function at work
paramS.utilWorkS = UtilCrraLH(paramS.workSigma, paramS.prefBeta, paramS.prefWtWork);



%% College costs
%{
If not calibrated: copied from base expNo (done above)
But can override by setting collCostExpNo
%}

% Targets for college costs
%  Does not make sense to take that from another cohort
paramS.costS.tgPMean = tgS.costS.pMean_cV(iCohort);
paramS.costS.tgPStd  = tgS.costS.pStd_cV(iCohort);

if ~cS.modelS.hasCollCostHetero
   % Simply set pMean from data
   paramS.pMean = paramS.costS.tgPMean;
   paramS.pStd  = 0;
end

% Take from another experiment
if ~isempty(cS.expS.collCostExpNo)
   c2S = const_bc1(cS.setNo, cS.expS.collCostExpNo);
   param2S = var_load_bc1(c2S.vParams, c2S);
   paramS.pMean = param2S.pMean;
   paramS.pStd  = param2S.pStd;
end

% Change mean college cost
if cS.expS.pMeanChange ~= 0
   paramS.pMean = paramS.pMean + cS.expS.pMeanChange;
end



%% High school graduation

if ~isempty(cS.expS.hsGraduationExpNo)
   % Take all params related to HSG from another experiment
   c2S = const_bc1(setNo, cS.expS.hsGraduationExpNo);
   param2S = var_load_bc1(cS.vParams, c2S);
   for i1 = 1 : length(cS.pGroupS.hsGradParamV)
      pName = cS.pGroupS.hsGradParamV{i1};
      paramS.(pName) = param2S.(pName);
   end
   clear c2S param2S;
end



%% School attainment


% Which cohorts schooling to match (for experiments)
if isempty(cS.expS.schoolFracCohort)
   ic = iCohort;
else
   ic = cS.expS.schoolFracCohort;
end
paramS.schoolS.tgFrac_sV = tgS.schoolS.frac_scM(:, ic);
clear ic;


%% Endowments by type

% Derived
if cS.expS.alphaAmFactor ~= 1
   paramS.alphaAM = paramS.alphaAM .* cS.expS.alphaAmFactor;
end
if cS.expS.alphaAqFactor ~= 1
   paramS.alphaAQ = paramS.alphaAQ .* cS.expS.alphaAqFactor;
end

paramS = calibr_bc1.param_endow(paramS, cS);



%% College Graduation probs

if ~isempty(cS.expS.collGraduationExpNo)
   % Take all params related to college graduation from another experiment
   c2S = const_bc1(setNo, cS.expS.collGraduationExpNo);
   param2S = var_load_bc1(cS.vParams, c2S);
   for i1 = 1 : length(cS.pGroupS.collGradParamV)
      pName = cS.pGroupS.collGradParamV{i1};
      paramS.(pName) = param2S.(pName);
   end
   clear c2S param2S;
end

% Prob of college graduation
paramS.prGrad_aV = calibr_bc1.pr_grad_a(1 : cS.nAbil, paramS, cS);

if cS.dbg > 10
   validateattributes(paramS.prGrad_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1, 'size', [cS.nAbil, 1]})
end


% Prob(a | j, graduation shock positive)
paramS.prA_jgradM = hh_bc1.prob_a_jgrad(paramS.prGrad_aV, paramS.prob_jV, paramS.prob_a_jM, cS.dbg);



%% Lifetime earnings by [work start age, school, ability]

paramS.earnS = calibr_bc1.param_earn_derived(tgS, paramS, cS);



%% Borrowing limits

% Range of permitted assets in college (used for approximating value functions)
paramS.kMax = 2e5 ./ cS.unitAcct;


% Min k at start of each period (detrended)
% kMin_acM = -calibr_bc1.borrow_limits(cS);
% May be taken from base cohort
if isempty(cS.expS.bLimitCohort)
   blCohort = cS.iCohort;
else
   blCohort = cS.expS.bLimitCohort;
end
% blCohort = cS.expS.bLimitBaseCohort * cS.iRefCohort + (1 - cS.expS.bLimitBaseCohort) * iCohort;
paramS.kMin_aV = tgS.kMin_acM(:, blCohort);

if cS.dbg > 10
   validateattributes(paramS.kMin_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '<=', 0, 'size', [max(cS.ageWorkStartM(:)), 1]});
end


%% Preferences: derived (using endowment info)

if ~isempty(cS.expS.prefHsExpNo)
   % prefHS from another experiment
   c2S = const_bc1(cS.setNo, cS.expS.prefHsExpNo);
   param2S = var_load_bc1(c2S.vParams, c2S);
   paramS.prefHS = param2S.prefHS;
   paramS.dPrefHS = param2S.dPrefHS;
   paramS.prefHS_jV = param2S.prefHS_jV;
   clear param2S;
end

% Preference for high school by type
if paramS.dPrefHS > 1e-6
   % prefHS_jV is in prefHS +/- 0.5 * dPrefHS
   mScaledV = paramS.m_jV ./ (mMax - mMin);
   paramS.prefHS_jV = paramS.prefHS - mScaledV .* paramS.dPrefHS;
else
   paramS.prefHS_jV = paramS.prefHS .* ones([cS.nTypes, 1]);
end



end