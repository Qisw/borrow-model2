function ypS = yp_targets(n79S, tgS, cS)

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Mean log parental income by IQ quartile
ypS.logYpMean_qcM = nan([nIq, cS.nCohorts]);
ypS.logYpMean_ycM = nan([nYp, cS.nCohorts]);

% Mean and std by cohort
%  Directly sets the model params
ypS.logYpMean_cV = nan([cS.nCohorts, 1]);
ypS.logYpStd_cV  = nan([cS.nCohorts, 1]);



%% NLSY 79 and 97

for ic = [tgS.icNlsy79, tgS.icNlsy97]
   if ic == tgS.icNlsy79
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy79_targets_load(cS);
      dFactor = tgS.nlsyCpiFactor;
   elseif ic == tgS.icNlsy97
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy97_targets_load(cS);
      dFactor = tgS.nlsy97CpiFactor;
   else
      error('Invalid');
   end

   ypS.logYpMean_qcM(:, ic) = n79S.median_parent_inc_byafqt - log(dFactor);
   ypS.logYpMean_ycM(:, ic) = n79S.median_parent_inc_byinc  - log(dFactor);


   ypS.logYpMean_cV(ic) = n79S.median_parent_inc - log(dFactor);
   % Std log(yp) - no need to account for units
   ypS.logYpStd_cV(ic)  = n79S.sd_parent_inc; 
end



%% Earlier cohorts

% update +++++

% Assumed time invariant
ypS.logYpMean_cV = ypS.logYpMean_cV(tgS.icNlsy79) .* ones([cS.nCohorts, 1]);
% Std log(yp) - no need to account for units
ypS.logYpStd_cV  = ypS.logYpStd_cV(tgS.icNlsy79) .* ones([cS.nCohorts, 1]); 


% Should perhaps construct mean from mean by q where feasible +++
% for consistency
% for iCohort = 1 : cS.nCohorts
%    ypS.logYpMean_cV(iCohort) = mean(ypS.logYpMean_qcM(:,iCohort));
% end


%% Output check

if cS.dbg > 10
   idxV = find(~isnan(ypS.logYpMean_qcM(1,:)));
   validateattributes(ypS.logYpMean_qcM(:,idxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 10})
   validateattributes(ypS.logYpMean_ycM(:,idxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      '<', 10})

   validateattributes(ypS.logYpMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(ypS.logYpStd_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 0.1, ...
      '<', 1})
end


   
% Check consistency with values by iq, yp

end