function qyS = qy_targets(tgS, cS)
% Joint distribution of IQ, yp

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

qyS.mass_qycM = nan([nIq, nYp, cS.nCohorts]);


%% NLSY79 and 97
for ic = [tgS.icNlsy79, tgS.icNlsy97]
   if ic == tgS.icNlsy79
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy79_targets_load(cS);
   elseif ic == tgS.icNlsy97
      %  Load file with all NLSY79 targets
      n79S = data_bc1.nlsy97_targets_load(cS);
   else
      error('Invalid');
   end

   qyS.mass_qycM(:,:,ic) = n79S.pop_share_byinc_and_byafqt;
end


%% Output check

for ic = 1 : cS.nCohorts
   if ~isnan(qyS.mass_qycM(1,1,ic))
      tmpM = qyS.mass_qycM(:,:,ic);
      check_lh.prob_check(tmpM(:), 1e-6);
   end
end



end