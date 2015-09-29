function tgS = caltg_defaults(caseStr, modelS)
% Default: what moments are targeted?
%{
IN:
   modelS :: Model
      model features

Checked: 2015-Aug-20
%}


%% Defaults (for baseline cohort)

% PV of lifetime earnings by schooling
tgS.tgPvLty = true;

% Joint distribution [iq, yp]
tgS.tgMass_qy = true;


%% College outcomes

% Overall school fractions
tgS.tgFracS = 1;

% Fraction graduating high school (or more) | IQ or YP
tgS.tgFracHsgPlus_q = true;
tgS.tgFracHsgPlus_y = true;

% Fraction by [s,q,y]
%  need to avoid double counting when this is available +++
tgS.tgFrac_sqy = false;
tgS.tgFrac_sy = false;
tgS.tgFrac_sq = false;

% fraction entering college (conditional on HSG)
tgS.tgFracEnterIq = 1;
% fraction graduating (not conditional on entry) (conditional on HSG)
tgS.tgFracGradIq = 1;
tgS.tgFracEnterYp = 1;
tgS.tgFracGradYp = 1;

% Targets by [iq, yp]: entry and graduation rates
tgS.tgCollegeQy = 1;

% Regression coefficients of entry on [iq, yp]
tgS.tgRegrIqYp = 1;


% *****  Schooling. Universe are HSG
% Usually not used, unless no other moments are available
% But can leave switched on b/c 

% Fraction entering / graduating by [q,y]
tgS.tgHsgCollegeQy = true;
% Frac HSG+ | IQ or YP
tgS.tgHsgFracHsgPlus_qy = true; 
% tgS.tgHsgFracHsgPlus_q = true; 
% tgS.tgHsgFracHsgPlus_y = true;


%% Financing

% *****  College costs
tgS.tgPMean  = 1;
tgS.tgPStd   = modelS.hasCollCostHetero;
tgS.tgPMeanIq = modelS.hasCollCostHetero;
tgS.tgPMeanYp = modelS.hasCollCostHetero;

% *****  Parental income
% Only correlation with other endowments matters
tgS.tgYpIq = false;
tgS.tgYpYp = false;

% *****  Hours and earnings
tgS.tgHours = 1;
tgS.tgHoursIq = 1;
tgS.tgHoursYp = 1;
tgS.tgEarn = 1;
tgS.tgEarnIq = 1;
tgS.tgEarnYp = 1;

% Debt at end of college by CD / CG
% tgS.tgDebtFracS = 0;
% tgS.tgDebtMeanS = 0;
% Debt at end of college
% tgS.tgDebtFracIq = 0;
% tgS.tgDebtFracYp = 0;
% tgS.tgDebtMeanIq = 0;
% tgS.tgDebtMeanYp = 0;
% Average debt per student
% tgS.tgDebtMean = false;
% Debt stats among college grads only, by iq an yp
%   Not used b/c small debt values could lead to large deviations relative to data
tgS.tgDebtFracGrads = false;
tgS.tgDebtMeanGrads = true;
% Penalty when too many students hit borrowing limit?
%  To avoid getting stuck at params where everyone maxes out borrowing limit
tgS.useDebtPenalty = 1;

% Mean transfer
tgS.tgTransfer = 1;
tgS.tgTransferYp = 1;
tgS.tgTransferIq = 1;
% Penalize transfers > data transfers?
tgS.tgPenalizeLargeTransfers = true;

% Financing shares (only constructed for cohorts where transfers etc not available)
tgS.tgFinShares = false;


%% Override for cases
if strcmpi(caseStr, 'default')
   % Nothing

elseif strcmpi(caseStr, 'timeSeriesFit')
   % Time series calibration. Try to match everything for each cohort
   % Not everything is available, of course

elseif strcmpi(caseStr, 'timeSeriesPartial')
   % Match everything but IQ, yp sorting
   % But need to target marginal entry rates -- otherwise model implies negative sorting
   % ad hoc +++
   tgS.tgRegrIqYp = 0;
   % fraction graduating (not conditional on entry)
   tgS.tgFracGradIq = 0;
   tgS.tgFracGradYp = 0;
   % Targets by [iq, yp]: entry and graduation rates
   tgS.tgCollegeQy = 0;

   % Fraction by [s,q,y]
   tgS.tgFrac_sqy = false;


elseif strcmpi(caseStr, 'timeSeries')
   % Time series calibration
   % Do not target regression coefficients betaIq, betaYp
   %  We want to see how far we go without targeting them. We need to match frac_s and LTY(s)
   tgS.tgRegrIqYp = 0;
   % fraction entering college
   tgS.tgFracEnterIq = 0;
   % fraction graduating (not conditional on entry)
   tgS.tgFracGradIq = 0;
   tgS.tgFracEnterYp = 0;
   tgS.tgFracGradYp = 0;
   % Targets by [iq, yp]: entry and graduation rates
   tgS.tgCollegeQy = 0;
   % Fraction by [s,q,y]
   tgS.tgFrac_sqy = false;


elseif strcmpi(caseStr, 'onlySchoolFrac')
   % Target only school fractions
   % For experiments
   % Check that this actually switches everything off!
   nameV = fieldnames(tgS);
   for i1 = 1 : length(nameV)
      tgS.(nameV{i1}) = false;
   end
   tgS.tgFracS = true;

else
   error('Invalid');
end


end
