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



%% NLSY 79

ic = tgS.icNlsy79;
ypS.logYpMean_qcM(:, ic) = n79S.median_parent_inc_byafqt - log(tgS.nlsyCpiFactor);
ypS.logYpMean_ycM(:, tgS.icNlsy79) = n79S.median_parent_inc_byinc  - log(tgS.nlsyCpiFactor);


ypS.logYpMean_cV(ic) = n79S.median_parent_inc - log(tgS.nlsyCpiFactor);
% Std log(yp) - no need to account for units
ypS.logYpStd_cV(ic)  = n79S.sd_parent_inc; 


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