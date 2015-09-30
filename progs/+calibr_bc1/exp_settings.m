function [expS, tgS, doCalV, iCohort] = exp_settings(pvec, cS)
% Experiment settings
%{
By default, non-calibrated params are copied from base expNo
Can override this by setting switches such as expS.earnExpNo
Then pvEarn_asM is taken from that experiment (which would usually be the experiment
that calibrates everything for a particular cohort)

IN
   pvecIn
      pvectorLH object with calibrated params

OUT
   pvec (handle class)
   expS
      struct with experiment settings
   tgS
      which calibration targets to use?
   Items for cS:
      doCalV
         parameters with any value in doCalV are calibrated
      iCohort
         cohort for which experiment is run
%}

expNo = cS.expNo;


%% Experiment numbers

% For each cohort: calibrate time varying parameters with these experiments
expS.bYearExpNoV = [203, 202, cS.expBase, 204];


% These experiments decompose time series changes into drivers
% Each COLUMN is a cohort
baseExpNoV = [100; 110; NaN; 120];
cfExpNoV   = 4 : 7;
expS.decomposeExpNoM = ones(length(cfExpNoV), 1) * baseExpNoV(:)'   +  cfExpNoV(:) * ones(1, length(baseExpNoV));
% Decomposition: cumulative changes

baseExpNoV = [140; 150; NaN; 160];
cfExpNoV   = 4 : 7;
expS.decomposeCumulExpNoM = ones(length(cfExpNoV), 1) * baseExpNoV(:)'   +  cfExpNoV(:) * ones(1, length(baseExpNoV));

% Pure comparative statics
expS.compStatExpNoV = 301 : 303;

% Which calibration targets to use?
% These are targets we would like to match. Targets that are NaN are ignored.
tgS = calibr_bc1.caltg_defaults('default', cS.modelS);



%%  Which data based parameters are from another experiment?
% For counterfactuals
% Meaning: another cohort

% Earnings profiles (sets targets if calibrated, otherwise takes paramS.pvEarn_asM from base cohort)
expS.earnExpNo = [];
% College costs (values, NOT targets)
expS.collCostExpNo = [];
% expS.ypBaseCohort = 0;
% Cohort from which borrowing limits are taken
%  Never calibrated
expS.bLimitCohort = [];
% Target school fractions (tgS.frac_scM) taken from another cohort
expS.schoolFracCohort = [];
% Parental altruism taken from this cohort
% expS.puWeightExpNo = [];
% Pref for HS from another experiment
expS.prefHsExpNo = [];
% Params governing HS graduation from another exper
expS.hsGraduationExpNo = [];
% Params governing college graduation rates from another exper
expS.collGraduationExpNo = [];

% Does this experiment require recalibration?
expS.doCalibrate = 1;


%%  Exogenously changed parameters

% Mean college cost
expS.pMeanChange = 0;
% Change in CG premium (log points)
expS.cgPremChange = 0;
expS.cdPremChange = 0;


%%  Settings for each case

% The reason for nested functions is an editor bug in Matlab
if expNo < 100
   base_exper;
elseif expNo < 200
   % Counterfactuals. Only calibrate a few things to match school fractions
   counterfactuals;
elseif expNo < 300
   time_series;
elseif expNo < 400
   % Pure counterfactuals. Nothing is calibrated
   pure_counterfactuals;
else
   error('Invalid');
end

return;


%% Nested:  Base experiments: calibrate everything to match all targets
function base_exper
   if expNo == cS.expBase
      expS.expStr = '1979';
      % Parameters with these values of doCal are calibrated
      doCalV = cS.calBase;
      iCohort = cS.iRefCohort;  
      
   else
      error('Invalid');
   end
end
   

%% Nested:  Pure counterfactuals: 300s
function pure_counterfactuals
   expS.doCalibrate = false;
   doCalV = cS.calExp;
   % Taking parameters from this cohort
   iCohort = cS.iRefCohort;

   if expNo == 301
      % Add $1000 to college costs
      expS.expStr = 'Higher tuition';
      expS.pMeanChange = 1e3 ./ cS.unitAcct;
      % output dir
      expS.outDir = 'tuition_up';
   elseif expNo == 302
      % Raise college grad premium by 10 log points
      expS.expStr = 'Higher CG premium';
      expS.cgPremChange = 0.1;
      % output dir
      expS.outDir = 'gradprem_up';
      
   elseif expNo == 303
      % Raise college grad premium by 10 log points
      expS.expStr = 'Higher college premium';
      expS.cgPremChange = 0.1;
      expS.cdPremChange = 0.1;
      % output dir
      expS.outDir = 'collprem_up';

   else
      error('Invalid');
   end
end
   
   
%% Nested:   Counterfactuals: 100s
% Change one parameter (e.g. college costs). Hold school fractions constant at base exper.
% Nothing is calibrated  EXCEPT prefHS, probHsg params to match college entry.
% Params are copied from base
function counterfactuals
   expS.doCalibrate = 1;
   doCalV = cS.calExp;
   % Taking parameters from this cohort
   iCohort = cS.iRefCohort;

   % Calibrate only params to match 
   %  school fractions
   %  prob HSG
   pvec.calibrate('prefHS', cS.calExp);
   % High school graduation parameters
   pvec.change_calibration_status(cS.pGroupS.hsGradParamV, cS.calBase, cS.calExp);
%    %pvec.calibrate('probHsgInter', cS.calExp);
%    pvec.calibrate('probHsgMin', cS.calExp);
%    pvec.calibrate('probHsgMult', cS.calExp);
%    pvec.calibrate('probHsgOffset', cS.calExp);
   % Only target school fractions
   tgS = calibr_bc1.caltg_defaults('onlySchoolFrac', cS.modelS);
   
   % Pick out cohort from which counterfactuals are taken
   % Single variable changes
   if expNo < 110
      cfBYear = 1915;   % Updegraff
      % This is used to compute the offset (expNo - baseExpNo)
      %  The offset determines the settings
      %baseExpNo = 100;
   elseif expNo < 120
      cfBYear = 1940;   % Project talent
      %baseExpNo = 110;
   elseif expNo < 130
      cfBYear = 1979;   % NLSY97
      %baseExpNo = 120;
   
   % Cumulative changes
   elseif expNo < 150
      % Cumulative changes: Updegraff
      cfBYear = 1915;  
      %baseExpNo = 140;
   elseif expNo < 160
      % Cumulative changes: Project Talent
      cfBYear = 1940;  
      %baseExpNo = 150;
   elseif expNo < 170
      % NLSY97
      cfBYear = 1979;
      %baseExpNo = 160;
   else
      error('Invalid');
   end
   
   % This is used to compute the offset (expNo - baseExpNo)
   %  The offset determines the settings
   baseExpNo = floor(expNo / 10) * 10;
   eDiff = expNo - baseExpNo;
   
   % Taking counterfactuals from this cohort (expNo)
   [~,cfCohort] = min(abs(cS.bYearV - cfBYear)); 
   cfExpNo = expS.bYearExpNoV(cfCohort); 

   
   if eDiff == 3
      expS.expStr = 'Replicate base exper';    % for testing
      expS.earnExpNo = cS.expBase;
      expS.bLimitCohort = iCohort;
      expS.collCostExpNo = cS.expBase;
      expS.prefHsExpNo = cS.expBase;
      expS.hsGraduationExpNo = cS.expBase;
      expS.collGraduationExpNo = cS.expBase;

   elseif any(expNo == expS.decomposeExpNoM(:))
   % ------  Change one param at a time
   % Sequence should match cumulative decomposition
      if eDiff == 4
         % Change college costs
         expS.expStr = 'Change college costs';
         % Need to calibrate everything for that cohort. Then impose pMean from there
         expS.collCostExpNo = cfExpNo;

      elseif eDiff == 5
         expS.expStr = 'Only change bLimit';    % when not recalibrated
         expS.bLimitCohort = cfCohort;

      elseif eDiff == 6
         % Take pvEarn_asM from cfExpNo
         expS.expStr = 'Only change earn profiles'; 
         expS.earnExpNo = cfExpNo;

      elseif eDiff == 7
         %  Target schooling of cf cohort
         %     Also change HSG rates and CG rates
         expS.expStr = 'Change schooling';
         expS.schoolFracCohort = cfCohort;
         expS.hsGraduationExpNo = cfExpNo;
         expS.collGraduationExpNo = cfExpNo;
         
      else
         error('Invalid');
      end
      
   elseif any(expNo == expS.decomposeCumulExpNoM(:))
      % -----  Cumulative changes   
      % Always adjust prefHS to keep schooling constant (for ease of interpretation)
      eDiff = expNo - baseExpNo;
      if eDiff >= 4
         % Change college costs
         expS.expStr = 'Change college costs';
         % Need to calibrate everything for that cohort. Then impose pMean from there
         expS.collCostExpNo = cfExpNo;
      end
      if eDiff >= 5
         expS.expStr = 'Change borrowing limit';    % when not recalibrated
         expS.bLimitCohort = cfCohort;
      end
      if eDiff >= 6
         % Take pvEarn_asM from cfExpNo
         expS.expStr = 'Change earnings profiles'; 
         expS.earnExpNo = cfExpNo;
      end
%       if eDiff >= 7
%          % Parental altruism
%          expS.expStr = 'Change parental altruism';
%          expS.puWeightExpNo = cfExpNo;
%          pvec.calibrate('puWeightMean', cS.calNever);
%       end
      if eDiff >= 7
         %  Target schooling of cf cohort
         expS.expStr = 'Change college entry';
         expS.schoolFracCohort = cfCohort;
         expS.prefHsExpNo = cfExpNo;
         expS.hsGraduationExpNo = cfExpNo;
         expS.collGraduationExpNo = cfExpNo;
         % Now nothing is calibrated anymore
         expS.doCalibrate = 0;
         pvec.calibrate('prefHS', cS.calNever);
      end
      
      
   else
      error('Invalid');
   end
end
   
   
%% Nested:  Calibrated experiments
% A subset of params is recalibrated. The rest is copied from baseline
function time_series
   % Now fewer parameters are calibrated
   doCalV = cS.calExp;
   % Calibrate pMean, which is really a truncated data moment
   pvec.calibrate('pMean', cS.calExp);
   tgS = calibr_bc1.caltg_defaults('timeSeriesPartial', cS.modelS);
         % also implement: do not target IQ/yp sorting +++++
         % this is 'timeSeries'

   if any(expNo == expS.bYearExpNoV)
      % ******  Calibrate all time varying params
      iCohort = find(expNo == expS.bYearExpNoV);
      expS.expStr = sprintf('%i', cS.cohYearV(iCohort));
      expS.outDir = 'cohort_compare';
      
      % Signal noise
      % pvec.calibrate('alphaAM', cS.calExp);
      
      % Match overall college entry
      pvec.calibrate('prefHS', cS.calExp);

      % Match college graduation rate
      % For all params related to college graduation: change calibration status (if 
      % calibrated in base case)
      pvec.change_calibration_status(cS.pGroupS.collGradParamV, cS.calBase, cS.calExp);
      
      % Match HS graduation rate
      pvec.change_calibration_status(cS.pGroupS.hsGradParamV, cS.calBase, cS.calExp);
      
      % Scale factors of lifetime earnings (log)
      pvec.calibrate('eHatCD', cS.calExp);
      pvec.calibrate('dEHatHSD', cS.calExp);
      pvec.calibrate('dEHatHSG', cS.calExp);
      pvec.calibrate('dEHatCG',  cS.calExp);
      
      % Keeping college wage fixed for now
      %pvec.calibrate('wCollMean', cS.calExp);
      
      % Project talent only: target mass by [s,q] and [s,y]
      % because we don't have a lot of other moments
      if iCohort == cS.cohortS.by_name('Project Talent')
         tgS.tgFrac_sq = true;
         tgS.tgFrac_sy = true;
      end
      
   elseif expNo == 205  ||  expNo == 206  || expNo == 207
      iCohort = 1;
      expS.expStr = sprintf('Cohort %i', cS.cohYearV(iCohort));
      
      % Signal noise
      % pvec.calibrate('alphaAM', cS.calExp);
      % Match overall college entry
      pvec.calibrate('prefHS', cS.calExp);
      
      % Scale factors of lifetime earnings (log)
      pvec.calibrate('eHatCD', cS.calExp);
      pvec.calibrate('dEHatHSD', cS.calExp);
      pvec.calibrate('dEHatHSG', cS.calExp);
      pvec.calibrate('dEHatCG',  cS.calExp);
      if expNo == 205
         % testing: calibrate pref scale at entry
         pvec.calibrate('prefScaleEntry', cS.calExp);   % +++
      elseif expNo == 206
         % testing: calibrate graduation rates
         pvec.calibrate('prGradMax', cS.calExp);   % +++
      elseif expNo == 207
         % testing: calibrate prefHS_jV
         expS.expStr = 'Calibrate prefHS by j';
         pvec.calibrate('dPrefHS', cS.calExp);   % +++
      else
         error('Invalid');
      end

   elseif expNo == 211
      % This changes earnings, borrowing limits, pMean
      error('Not updated'); % +++++
      expS.expStr = 'Only change observables';   
      iCohort = cS.iRefCohort - 1;  % make one for each cohort +++
%       % Take all calibrated params from base
%       for i1 = 1 : pvec.np
%          ps = pvec.valueV{i1};
%          if ps.doCal == cS.calExp
%             % Do not calibrate, but take from base exper
%             pvec.calibrate(ps.name, cS.calBase);
%          end
%       end
      %pvec.calibrate('logYpMean', cS.calExp);
   
   else
      error('Invalid');
   end
end
   

end