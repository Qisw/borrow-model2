function cohort_earn_profiles_show(saveFigures, setNo)
% Show cohort earnings profiles
%{
The profiles are just copied from cps data
%}

cS = const_bc1(setNo);
expNo = cS.expBase;
figS = const_fig_bc1;
figOptS = figS.figOpt4S;

tgS = var_load_bc1(cS.vCalTargets, cS);
logEarn_tscM = log_lh(tgS.earn_tscM, NaN);

[yMin, yMax] = figures_lh.yrange(logEarn_tscM(:));
% yMax = ceil(max(log(max(0.1, tgS.earn_tscM(:)))));

fhV = zeros(length(cS.bYearV), 1);
for iCohort = 1 : length(cS.bYearV)
   fhV(iCohort) = output_bc1.fig_new(saveFigures, figOptS);
   hold on;
   
   for iSchool = 1 : cS.nSchool
      ageV = cS.ageWorkStartM(iSchool, 1) : cS.ageRetire;
      
      % Complete profile
      iLine = iSchool;
      earnV = tgS.earn_tscM(ageV, iSchool, iCohort);
      idxV = find(earnV > 0);
      plot(cS.age1 - 1 + ageV(idxV), log(earnV(idxV)), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
      
   end
   
   hold off;
   xlabel('Age');
   ylabel('Earnings');
   legend(cS.sLabelV, 'location', 'south');
   figures_lh.axis_range_lh([NaN, NaN, yMin, yMax]);
   output_bc1.fig_format(fhV(iCohort), 'line');
   
   output_bc1.fig_save(fullfile(cS.dataOutDir, sprintf('earn_profile_coh%i', cS.bYearV(iCohort))), saveFigures, cS);
end


end