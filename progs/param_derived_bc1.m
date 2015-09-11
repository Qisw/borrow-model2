function paramS = param_derived_bc1(paramS, cS)
% Derived parameters
%{
Ref cohort

Checked: 2015-Mar-19
%}

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
    'eHatCG',     'earn_tsM',    'pvEarn_asM',  'cPvFactor_sV',  'cFactorV' };
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

% Targets for college costs
%  Does not make sense to take that from another cohort
paramS.costS.tgPMean = tgS.costS.pMean_cV(iCohort);
paramS.costS.tgPStd  = tgS.costS.pStd_cV(iCohort);


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


% All types have the same probability
paramS.prob_jV = ones([cS.nTypes, 1]) ./ cS.nTypes;

% Order is 
%  p, y, z, m
wtM = [1, 0, 0, 0; 
   paramS.alphaPY, 1, 0, 0;
   paramS.alphaZP, paramS.alphaZY, 1, 0;
   paramS.alphaPM, paramS.alphaYM, paramS.alphaMZ, 1]; 

meanV = [paramS.pMean; paramS.logYpMean; paramS.zMean; 0];
stdV  = [paramS.pStd; paramS.logYpStd; paramS.zStd; 1];

% This correctly handles constant endowments
gridM = calibr_bc1.endow_grid(meanV, stdV, wtM, cS);

paramS.pColl_jV      = gridM(:,1);
paramS.yParent_jV    = exp(gridM(:,2));
paramS.transfer_jV = exp(gridM(:,3));
paramS.m_jV          = gridM(:,4);
% paramS.puWeight_jV   = max(0,  gridM(:,4));

% All agents start with 0 assets (bad assumption?)
paramS.k_jV = zeros(cS.nTypes, 1);

if cS.dbg > 10
   % Moments of marginal distributions are checked in test fct for endow_grid
   validateattributes(paramS.yParent_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'positive', 'size', [cS.nTypes, 1]})
   if abs(mean(paramS.m_jV)) > 0.1
      disp(mean(paramS.m_jV));
      error_bc1('Invalid mean m', cS);
   end
   if abs(std(paramS.m_jV) - 1) > 0.05
      disp(std_paramS.m_jV);
      error_bc1('Invalid std m', cS);
   end
%    validateattributes(paramS.puWeight_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0})
end


% ******  Free consumption / leisure in college 
%  Proportional to m. Range 0 to cCollMax
mMin = min(paramS.m_jV);
mMax = max(paramS.m_jV);
if cS.modelS.hasCollCons
   paramS.cColl_jV = (paramS.m_jV - mMin) .* paramS.cCollMax ./ (mMax - mMin);
else
   paramS.cColl_jV = zeros(cS.nTypes, 1);
end
if cS.modelS.hasCollLeisure
   paramS.lColl_jV = (paramS.m_jV - mMin) .* paramS.lCollMax ./ (mMax - mMin);
else
   paramS.lColl_jV = zeros(cS.nTypes, 1);
end



% For now: everyone gets the same college earnings
paramS.wColl_jV = ones([cS.nTypes, 1]) * paramS.wCollMean;
if cS.dbg > 10
   validateattributes(paramS.wColl_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'positive', 'size', [cS.nTypes, 1]})
end


% Parental income classes
paramS.ypClass_jV = distrib_lh.class_assign(paramS.yParent_jV, ...
   paramS.prob_jV, cS.ypUbV, cS.dbg);
if cS.dbg > 10
   validateattributes(paramS.ypClass_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      'positive', '<=', length(cS.ypUbV)})
end



% Range of permitted assets in college (used for approximating value functions)
paramS.kMax = 2e5 ./ cS.unitAcct;


paramS.endowS = calibr_bc1.param_endow(paramS, cS);


%% Ability and IQ

% Equal weighted bins
paramS.prob_aV = ones([cS.nAbil, 1]) ./ cS.nAbil;  

% Pr(a | type)
[paramS.prob_a_jM, paramS.abilGrid_aV] = ...
   calibr_bc1.normal_conditional(paramS.prob_aV, paramS.prob_jV, paramS.m_jV, ...
   paramS.alphaAM, cS.dbg);

if cS.dbg > 10
   check_bc1.prob_matrix(paramS.prob_a_jM,  [cS.nAbil, cS.nTypes],  cS);
   validateattributes(paramS.abilGrid_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nAbil, 1]})
end


% ******  Derived

% Pr(a) = sum over j (pr(j) * pr(a|j))
%  should very close to what was exogenously set
for iAbil = 1 : cS.nAbil
   prob_a_jV = paramS.prob_a_jM(iAbil,:);
   paramS.prob_aV(iAbil) = sum(paramS.prob_jV(:) .* prob_a_jV(:));
end   

if cS.dbg > 10
   check_bc1.prob_matrix(paramS.prob_aV,  [cS.nAbil, 1], cS);   
end



%  IQ params
[paramS.prIq_jM, paramS.pr_qjM, paramS.prJ_iqM] = calibr_bc1.iq_param(paramS, cS);



%% Graduation probs

% Prob of college graduation
paramS.prGrad_aV = pr_grad_a_bc1(1 : cS.nAbil, iCohort, paramS, cS);

if cS.dbg > 10
   validateattributes(paramS.prGrad_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1, 'size', [cS.nAbil, 1]})
end


% Prob(a | j, graduation shock positive)
paramS.prA_jgradM = hh_bc1.prob_a_jgrad(paramS.prGrad_aV, paramS.prob_jV, paramS.prob_a_jM, cS.dbg);



%% Lifetime earnings by [work start age, school, ability]

paramS.earnS = calibr_bc1.param_earn_derived(tgS, paramS, cS);



%% Borrowing limits

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