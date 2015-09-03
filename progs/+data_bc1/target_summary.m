function target_summary(iCohort, setNo)
% Summarize calibration targets by cohort

cS = const_bc1(setNo);
tgS = var_load_bc1(cS.vCalTargets, cS);

outFn = fullfile(cS.dataOutDir, sprintf('target_summary_coh%i.txt', cS.bYearV(iCohort)));
fp = fopen(outFn, 'w');

nYp = length(cS.ypUbV);
nIq = length(cS.iqUbV);

fprintf(fp, '\nSummary of calibration targets for %i cohort\n\n',  cS.cohYearV(iCohort));
fprintf(fp, 'All detrended\n');


%% Unconditional stats

% age1 = 40;
% earn_sV = tgS.earn_tscM(age1 - cS.age1 + 1, :, iCohort);
% earn_sV = earn_sV(:);
% fprintf(fp, 'Mean earnings by schooling (age %i, thousands): ', age1);
% fprintf(fp, '  %.1f  ',  earn_sV .* dollarFactor ./ 1e3);
% fprintf(fp, '\n');
% 
% fprintf(fp, 'Log skill premiums: ');
% fprintf(fp, '  %.2f  ',  diff(log(earn_sV)));
% fprintf(fp, '\n');

fprintf(fp, 'College cost: mean / std  %.1f / %.1f \n',  tgS.costS.pMean_cV(iCohort), ...
   tgS.costS.pStd_cV(iCohort));

fprintf(fp, 'In college: mean hours: %.2f   mean earnings: %.1f \n', ...
   tgS.hoursS.hoursMean_cV(iCohort),  mean(tgS.collEarnS.mean_qcM(:,iCohort)));



%% By parental income quartile

fprintf(fp, '\nBy parental income quartile\n');
fprintf(fp, '%4s  %6s  %6s\n',  'Q', 'ypMean', 'zMean');
for i1 = 1 : nYp
   fprintf(fp, '%4i  %6.1f  %6.1f\n', i1, ...
      exp(tgS.ypS.logYpMean_ycM(i1,iCohort)),  ...
      tgS.transferS.transferMean_ycM(i1,iCohort));
end


%% By IQ quartile

fprintf(fp, '\n\nBy IQ quartile\n');
fprintf(fp, '%4s  %5s %5s  %6s %6s\n',  'Q',  'CD+CG', 'CG',  'ypMean', 'zMean');

for i1 = 1 : nIq
   fprintf(fp, '%4i  %5.2f %5.2f  %6.1f %6.1f\n',  i1, ...
      tgS.schoolS.fracEnter_qcM(i1,iCohort), tgS.schoolS.fracGrad_qcM(i1,iCohort),  ...
      exp(tgS.ypS.logYpMean_qcM(i1,iCohort)), ...
      tgS.transferS.transferMean_qcM(i1,iCohort));
end

fclose(fp);
type(outFn);


end