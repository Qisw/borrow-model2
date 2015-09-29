function [pvec, pGroupS] = pvector_default(cS)
% Defaults: which params are calibrated?
%{
Only set calBase and calNever here
Experiments can override with calExper

OUT
   pGroupS
      struct with info on groups of params
      e.g., lists all params related to HS graduation

Checked: 2015-Aug-20
%}

symS = helper_bc1.symbols;

% Collection of calibrated parameters
pvec = pvectorLH(30, cS.doCalValueV);


%% Preferences

% Discount factor
pvec.change('prefBeta', '\beta', 'Discount factor', 0.98, 0.8, 1.1, cS.calNever);
% Curvature of u(c) at work
pvec.change('workSigma', '\varphi_{w}', 'Curvature of utility', 2, 1, 5, cS.calNever);
% Weight on u(c) at work. To prevent overconsumption
pvec.change('prefWtWork', '\omega_{w}', 'Weight on u(c) at work', 3, 1, 20, cS.calBase);
% Same for college. Normalize to 1
pvec.change('prefWt', '\omega_{c}', 'Weight on u(c)', 1, 0.01, 1.1, cS.calNever);
% Curvature of u(c) in college
pvec.change('prefSigma', '\varphi_{c}', 'Curvature of utility', 2, 1, 5, cS.calNever);
% Curvature of u(leisure) in college
pvec.change('prefRho', '\varphi_{l}', 'Curvature of utility', 2, 1, 5, cS.calNever);
% Weight on leisure
pvec.change('prefWtLeisure', '\omega_{l}', 'Weight on leisure', 0.5, 0.01, 5, cS.calBase);


% % Parental preferences
% pvec.change('puSigma', '\varphi_{p}', 'Curvature of parental utility', 0.35, 0.1, 5, cS.calBase);
% % Time varying: to match transfer data
% pvec.change('puWeightMean', '\mu_{p}', 'Weight on parental utility', 1, 0.001, 2, cS.calBase);
% pvec.change('puWeightStd',  '\sigma_{p}', 'Std of weight on parental utility', 0, 0.001, 2, cS.calBase);
% pvec.change('alphaPuM', '\alpha_{p,m}', 'Correlation, $\omega_{p},m$', 0, -5, 5, cS.calBase);


% Pref shock at entry. For numerical reasons only. 
%  was Fixed.
pvec.change('prefScaleEntry', '\gamma', 'Preference shock at college entry', 0.2, 0.05, 0.5, cS.calNever);
% Pref for working as HSG. Includes leisure. No good scale.
%  Calibrate in experiment to match schooling average
pvec.change('prefHS', '\bar{\eta}', 'Preference for HS', 0, -5, 40, cS.calBase);
% If not 0: prefHS(j) varies from prefHS - 0.5*dPrefHS to prefHS + 0.5*dPrefHS
pvec.change('dPrefHS', '\Delta\bar{\eta}', 'Range of HS preference', 0, 0, 5, cS.calNever);


%% Default: endowments
% Best to keep same order as in param_derived

% College costs
pvec.change('pMean', '\mu_{\tau}', 'Mean of $\tau$', ...
   (5e3 ./ cS.unitAcct), (-5e3 ./ cS.unitAcct), (1.5e4 ./ cS.unitAcct), cS.calBase);
pvec.change('pStd', '\sigma_{\tau}', 'Std of $\tau$', 2e3 ./ cS.unitAcct, ...
   5e2 ./ cS.unitAcct, 1e4 ./ cS.unitAcct, cS.calBase);

% Parental income (log) (no longer relevant)
% This will be taken directly from data (so not calibrated)
%  but is calibrated for other cohorts
pvec.change('logYpMean', '\mu_{y}', 'Mean of $\log(y_{p})$', ...
   log(5e4 ./ cS.unitAcct), log(5e3 ./ cS.unitAcct), log(5e5 ./ cS.unitAcct), cS.calNever);
% Assumed time invariant
pvec.change('logYpStd', '\sigma_{y}', 'Std of $\log(y_{p})$', 0.3, 0.05, 0.6, cS.calNever);
% Endowment correlations
% pvec.change('alphaPY', '\alpha_{\tau,y}', 'Correlation, $\tau,y$', 0.3, -5, 5, cS.calBase);


% Transfers (LOG!)
pvec.change('logZMean', '\mu_{z}', 'Mean of $\ln z$', ...
   log(5e3 ./ cS.unitAcct), log(1e3 ./ cS.unitAcct), log(1e4 ./ cS.unitAcct), cS.calBase);
pvec.change('logZStd', '\sigma_{z}', 'Std of $\ln z$', log(2e3 ./ cS.unitAcct), ...
   log(1e2 ./ cS.unitAcct), log(5e3 ./ cS.unitAcct), cS.calBase);
% pvec.change('alphaZP', '\alpha_{\tau,z}', 'Correlation, $\tau,z$', 0.4, -5, 5, cS.calBase);
pvec.change('alphaZY', '\alpha_{m,z}', 'Correlation, $m,z$', 0.4, -5, 5, cS.calBase);


% Ability signal
% pvec.change('alphaPM', '\alpha_{\tau,m}', 'Correlation, $\tau,m$', 0.4, -5, 5, cS.calBase);
pvec.change('alphaMY', '\alpha_{y,m}', 'Correlation, $y,m$', 0.5, -5, 5, cS.calBase);
pvec.change('alphaMZ', '\alpha_{m,z}', 'Correlation, $m,z$', 0.5, -5, 5, cS.calBase);


% IQ
pvec.change('alphaQY', '\alpha_{q,y}', 'Correlation, $q,y$', 0.5, -5, 5, cS.calBase);
pvec.change('alphaQZ', '\alpha_{q,z}', 'Correlation, $q,z$', 0.5, -5, 5, cS.calBase);
pvec.change('alphaQM', '\alpha_{q,m}', 'Correlation, $q,m$', 0.5, -5, 5, cS.calBase);


% Ability
pvec.change('alphaAY', '\alpha_{a,y}', 'Correlation, $a,y$', 1, -5, 5, cS.calBase);
pvec.change('alphaAZ', '\alpha_{a,z}', 'Correlation, $a,z$', 0, -5, 5, cS.calBase);
pvec.change('alphaAM', '\alpha_{a,m}', 'Correlation, $a,m$', 1, -5, 5, cS.calBase);
pvec.change('alphaAQ', '\alpha_{a,q}', 'Correlation, $a,q$', 0, -5, 5, cS.calBase);


% pvec.change('sigmaIQ', '\sigma_{IQ}', 'Std of IQ noise',  0.35, 0.2, 2, cS.calBase);


%% Default: schooling

% Prob of HSG
symStr = symS.retrieve('probGradHs');
pvec.change('probHsgMin', [symStr, '^0'], 'Prob of HSG', 0.6, 0.1, 0.95, cS.calBase);
pvec.change('probHsgMult', [symStr, '^1'], 'Prob of HSG', 0.5, 0.1, 3, cS.calBase);
pvec.change('probHsgOffset', [symStr, '^2'], 'Prob of HSG', 0.1, -3, 1, cS.calBase);
% pvec.change('probHsgInter',  [symStr, '^0'], 'Prob HSG intercept', 0.8, 0.1, 0.95, cS.calBase);
% pvec.change('probHsgSlope',  [symStr, '^1'], 'Prob HSG slope', 0.1, 0.01, 0.9, cS.calBase);
% List of params related to HSG
pGroupS.hsGradParamV = {'probHsgMin', 'probHsgMult', 'probHsgOffset'};


% Parameters governing probGrad(a)
   % One of these has to be time varying
pvec.change('prGradMin', '\pi_{0}', 'Min $\pi_{a}$', 0.1, 0.01, 0.5, cS.calBase);
pvec.change('prGradMax', '\pi_{1}', 'Max $\pi_{a}$', 0.8, 0.7, 0.99, cS.calBase);
pvec.change('prGradMult', '\pi_{a}', 'In $\pi_{a}$', 0.7, 0.1, 5, cS.calBase);
% Governs how steep the curve is. Don't allow too low. Algorithm will get stuck
pvec.change('prGradExp', '\pi_{b}', 'In $\pi_{a}$',  1, 0.3, 5, cS.calBase);
pvec.change('prGradPower', '\pi_{c}', 'In $\pi_{a}$', 1, 0.1, 2, cS.calNever);
pvec.change('prGradABase', 'a_{0}', 'In $\pi_{a}$', 0, 0, 0.3, cS.calNever);
% List of params related to college graduation
pGroupS.collGradParamV = {'prGradMin', 'prGradMax',  'prGradMult',  'prGradExp',  'prGradPower',  'prGradABase'};

% If student makes it past period 2, probability of graduating in 4 rather than 5 years
% Fixed to match average duration of 4.5 years (should be time varying +++)
pvec.change('probGradFour', symS.retrieve('probGradFour'), 'Prob of graduating in 4 years', ...
   0.5, 0.1, 0.9, cS.calNever);

% nCohorts = length(cS.bYearV);
pvec.change('wCollMean', 'w_{c}', 'College wage', ...
   2e4 ./ cS.unitAcct, 5e3 ./ cS.unitAcct, 1e5 ./ cS.unitAcct, cS.calBase);

% Free college consumption and leisure
% Specified as: how much does the highest m type get? The lowest m type gets 0
% In between: linear in m
pvec.change('cCollMax', [symS.retrieve('cColl'), '_{max}'], 'Max free consumption', ...
   0,  0,  1e4 ./ cS.unitAcct, cS.calBase);
pvec.change('lCollMax', [symS.retrieve('lColl'), '_{max}'], 'Max free leisure', ...
   0, 0, 0.5, cS.calBase);


%% Defaults: work

% Earnings are determined by phi(s) * (a - aBar)
%  phi(s) taken from gradpred
pvec.change('phiHSG', '\phi_{HSG}', 'Return to ability, HSG', 0.155,  0.02, 0.2, cS.calNever);
pvec.change('phiCG',  '\phi_{CG}',  'Return to ability, CG',  0.194, 0.02, 0.2, cS.calNever);

% Scale factors of lifetime earnings (log)
pvec.change('eHatCD', [symS.retrieve('pvEarnSchool'), '_{CD}'], 'Log skill price CD', 0, -3, 1, cS.calBase);
% Lifetime earnings premium (discounted to work start) for lowest ability
%  Should be < 0 for HSG (going to college raises earnings)
pvec.change('dEHatHSD', ['d', symS.retrieve('pvEarnSchool'), '_{HSD}'], 'Skill price gap HSD', ...
   -0.15, -1, 0, cS.calBase);
pvec.change('dEHatHSG', ['d', symS.retrieve('pvEarnSchool'), '_{HSG}'], 'Skill price gap HSG', -0.1, -1, 0, cS.calBase);
%  Should be > 0 for CG
pvec.change('dEHatCG',  ['d', symS.retrieve('pvEarnSchool'), '_{CG}'],  'Skill price gap CG',   0.1, 0, 2, cS.calBase);
% pvec.change('eHatCG',  '\hat{e}_{CG}',  'Log skill price CG',  -1, -4, 1, cS.calBase);

%% Other

% Gross interest rate
pvec.change('R', 'R', 'Interest rate', cS.R, 1, 1.1, cS.calNever);


end