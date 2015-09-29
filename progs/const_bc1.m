function cS = const_bc1(setNo, expNo)
% Set constants
%{
Index order: k, age, school, iq, yp, abil, j, cohort
   iq: q
   age: t
   ability: a

Checked: 2015-Mar-18
%}

% Default set and exp numbers
cS.setDefault = 7;
cS.expBase = 1;
if isempty(setNo)
   setNo = cS.setDefault;
end
if nargin < 2
   expNo = cS.expBase;
end
if isempty(expNo)
   expNo = cS.expBase;
end
cS.setNo = setNo;
cS.expNo = expNo;

cS.dbg = 111; 
cS.missVal = -9191;
cS.pauseOnError = 1;
% How often to run full debug mode during calibration?
% Changes on server
cS.dbgFreq = 0.5; 


%% Miscellaneous

% Default model features
cS.modelS = calibr_bc1.Model;

% How many nodes to use on kure
cS.kureS.nNodes = 8;
% Run parallel on kure?
cS.kureS.parallel = 1;
% Profile to use (local: no need to start multiple matlab instances)
cS.kureS.profileStr = 'local';

% When regressing college entry on [iq, yp], use weighted regression?
%  It makes little difference
cS.regrEntryIqYpWeighted = 0;

% 1 = $unitAcct
cS.unitAcct = 1e3;

% params are calibrated never / only for base exper / also for other exper
cS.calNever = 0;
cS.calBase = 1;
cS.calExp = 2;
cS.doCalValueV = [cS.calNever, cS.calBase, cS.calExp];


cS.male = 1;
cS.female = 2;
cS.both = 3;
cS.sexStrV = {'men', 'women', 'both'};

% fzero options for finding EE equation zeros
cS.fzeroOptS = optimset('fzero');
cS.fzeroOptS.TolX = 1e-6;

% fminbnd options for maximizing value functions
cS.fminbndOptS = optimset('fminbnd');
cS.fminbndOptS.TolX = 1e-6;


% Gross interest rate (if not calibrated)
cS.R = 1.04;




%% Default parameters: Demographics, Preferences

cS.cohortS = calibr_bc1.ModelCohorts;

% Cohorts modeled
cS.bYearV = cS.cohortS.bYearV;
% Year to be displayed for each cohort (high school graduation)
cS.cohYearV = cS.cohortS.displayYearV;
% Data sources
% cS.dataSource_cV = {'Updegraff (1936)', 'Project Talent', 'NLSY79', 'NLSY97'};
% Cross sectional calibration for this cohort
cS.iRefCohort = cS.cohortS.by_name('NLSY79');
cS.nCohorts = cS.cohortS.nCohorts;


% Age at model age 1
cS.age1 = 18;
% Last physical age
cS.physAgeLast = 75;
% Retirement age (last age with earnings)
cS.physAgeRetire = 65;

% Is curvature of u(c) the same in college / at work?
cS.ucCurvatureSame = 1;

% Consumption floor
cS.cFloor = 500 ./ cS.unitAcct;
% Leisure floor
cS.lFloor = 0.01;



%% Default: endowments

% Size of ability grid
cS.nAbil = 11;

% Number of types
cS.nTypes = 250;

% IQ groups
cS.iqUbV = (0.25 : 0.25 : 1)';
cS.nIQ = length(cS.iqUbV);

% Parental income classes
cS.ypUbV = (0.25 : 0.25 : 1)';


cS.abilAffectsEarnings = 1;



%% Default: schooling

% College lasts this many periods
% cS.collLength = 4;

cS.iHSD = 1;
cS.iHSG = 2;
cS.iCD = 3;
cS.iCG = 4;
cS.nSchool = cS.iCG;
cS.sLabelV = {'HSD', 'HSG', 'CD', 'CG'};
cS.ageWorkStartM = [1, 1;   1, 1;   3, 3;   5, 6];

% Parental transfers are received for this many periods
cS.ageLastTransfer = 5;


%% Default: other

% Base year for prices
cS.cpiBaseYear = 2010;

% Last year with data for anything
cS.lastDataYear = 2014;
% First year with data for anything (cpi starts in 1913)
cS.firstDataYear = 1913;

% Set no for cps routines
cS.cpsSetNo = 1;

% Data constants
cS.dataS = calibr_bc1.param_data(cS);

% Work
cS.workS = calibr_bc1.param_work(cS);

% Vector of calibrated params
[pvec, cS.pGroupS] = calibr_bc1.pvector_default(cS);

% Formatting info for figures etc
cS.formatS = helper_bc1.formatting(cS);

% Directories
dirS = helper_bc1.directories([], setNo, expNo);
cS = struct_lh.merge(cS, dirS, cS.dbg);
cS.dirS = dirS;


%% Parameter sets
% Each calibrates to a fixed reference cohort

if setNo == 1
   cS.setStr = 'Default';
   cS.iCohort = cS.iRefCohort;
   
elseif setNo == 2
   cS.setStr = 'Ability does not affect earnings';
   cS.abilAffectsEarnings = 0;
   
elseif setNo == 3
   % For testing. Calibrate to another cohort
   cS.setStr = 'Test with another cohort';
   [~, cS.iCohort] = min(abs(cS.bYearV - 1940));
   
elseif setNo == 4
   % Higher curvature of u(c) during college
   % Is curvature of u(c) the same in college / at work?
   cS.ucCurvatureSame = 0;
    % Curvature of u(c) in college
   pvec.change('prefSigma', '\varphi_{c}', 'Curvature of utility', 4, 1, 5, cS.calNever);
   
elseif setNo == 5
   cS.setStr = 'No free college consumption';
   cS.modelS.hasCollCons = false;
   
elseif setNo == 7
   cS.setStr = 'Default';

else
   error('Invalid');
end



% *****  Experiment settings
% Also determines which calibration targets to use
% Changes pvec (handle class)
[expS, cS.tgS, cS.doCalV, cS.iCohort] = calibr_bc1.exp_settings(pvec, cS);


%% Derived constants

if cS.runLocal
   cS.runParallel = true; 
   % For testing
   % cS.runParallel = false;
   cS.nNodes = 4;
   cS.parProfileStr = 'local';
else
   cS.runParallel = cS.kureS.parallel;
   cS.nNodes = cS.kureS.nNodes;
   % Default (empty) for killdevil. Local for kure
   cS.parProfileStr = cS.kureS.profileStr;
   cS.dbgFreq = 0.1;    % Ensure that dbg is always low on the server 
   cS.pauseOnError = 0; 
end


cS.pr_iqV = diff([0; cS.iqUbV]);
cS.pr_ypV = diff([0; cS.ypUbV]);

cS.nCohorts = cS.cohortS.nCohorts;
% Year each cohort start college (age 19)
% cS.yearStartCollege_cV = cS.bYearV + 18;

% Lifespan
cS.ageMax = cS.physAgeLast - cS.age1 + 1;
cS.ageRetire = cS.physAgeRetire - cS.age1 + 1;

% Changes if model does not have college cost hetero
if ~cS.modelS.hasCollCostHetero
   % pMean is directly taken from data
   pvec.calibrate('pMean', cS.calNever);
   pvec.change('pStd', [], [], 0,  0, 1e4 ./ cS.unitAcct, cS.calNever);
%    pvec.change('alphaPY', [], [], 0,  [], [], cS.calNever);
%    pvec.change('alphaPM', [], [], 0,  [], [], cS.calNever);
%    pvec.change('alphaZP', [], [], 0,  [], [], cS.calNever);
end



if ~cS.modelS.hasCollCons
   pvec.change('cCollMax', [], [],  0,  [], [], cS.calNever);
end
if ~cS.modelS.hasCollLeisure
   pvec.change('lCollMax', [], [],  0,  [], [], cS.calNever);
end

if cS.abilAffectsEarnings == 0   
   pvec.change('phiHSG', '\phi_{HSG}', 'Return to ability, HSG', 0,  0.02, 0.2, cS.calNever);
   pvec.change('phiCG',  '\phi_{CG}',  'Return to ability, CG',  0, 0.02, 0.2, cS.calNever);
   pvec.change('eHatCD', [], [], 0, [], [], cS.calNever);
   pvec.change('dEHatHSD', [], [], 0, [], [], cS.calNever);
   pvec.change('dEHatHSG', [], [], 0, [], [], cS.calNever);
   pvec.change('dEHatCG', [], [], 0, [], [], cS.calNever);
end

if cS.ucCurvatureSame == 1
   % Do not calibrate curvature of work utility
   % It is the same as college utility
   pvec.calibrate('workSigma', cS.calNever);
end



%%  Saved variables

% Calibrated parameters
cS.vParams = 1;

% Hh solution
cS.vHhSolution = 2;

% Aggregates
cS.vAggregates = 3;
% Additional aggregates, computed after calibration is done
cS.vAggrStats = 8;

% Preamble data
cS.vPreambleData = 5;

% Calibration results
cS.vCalResults = 6;

% Intermediate results from cal_dev
%  so that interrupted calibration can be continued
cS.vCalDev = 7;


%%  Variables that are always saved / loaded for base expNo
%  varNo 400-499

% CPI, base year = 1
% cS.vCpi = 401;

% College costs, base year prices
cS.vCollCosts = 402;

% Calibration targets
cS.vCalTargets = 403;

% Cohort earnings profiles (data)
cS.vCohortEarnProfiles = 404;

cS.vCohortSchooling = 405;

% Avg student debt by year
cS.vStudentDebtData = 406;

% Borrowing limits by cohort, detrended
cS.vBorrowLimits = 407;


%% Clean up

cS.expS = expS;
cS.pvector = pvec;
cS.modelS.validate;


end