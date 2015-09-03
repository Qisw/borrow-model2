function transferS = transfer_tg(tgS, cS)

dollarFactor = tgS.hsbCpiFactor;

%% Allocate outputs

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);

% Mean transfer by parental income, conditional on college
% Ref cohort only
transferS.transferMean_ycM = nan([nYp, cS.nCohorts]);
transferS.transferMean_qcM = nan([nIq, cS.nCohorts]);


%% HSB
% HSB, hsb_fam_income.xlsx
%  Transfer PER YEAR
%  Is this in base year prices? +++

transferS.transferMean_ycM(:, tgS.icHSB) = [2358.477; 3589.882; 5313.561; 7710.767] ...
   ./ dollarFactor;

% NELS
transferV = [2264; 3678; 4649; 5386];
transferS.transferMean_qcM(:,tgS.icHSB) = transferV ./ dollarFactor;



%% Implied

for ic = 1 : cS.nCohorts
   % Average for all college students
   massV = sum(sum(tgS.schoolS.frac_sqycM(cS.iCD : cS.nSchool, :, :, ic), 1), 2);
   if ~any(isnan(massV))
      massColl_yV = squeeze(massV);
      transferS.transferMean_cV(ic) = sum(massColl_yV .* transferS.transferMean_ycM(:,ic)) ./ sum(massColl_yV);

      % Alternative computation
      massV = sum(sum(tgS.schoolS.frac_sqycM(cS.iCD : cS.nSchool, :, :, ic), 1), 3);
      massColl_qV = squeeze(massV);
      meanAlt = sum(massColl_qV(:) .* transferS.transferMean_qcM(:,ic)) ./ sum(massColl_qV);
      if abs(meanAlt / transferS.transferMean_cV(ic) - 1) > 1e-2
         %error_bc1('Mean transfers not consistent', cS);
         warning('Mean transfers not consistent');    % Enable error here +++++
      end
   end
end

end