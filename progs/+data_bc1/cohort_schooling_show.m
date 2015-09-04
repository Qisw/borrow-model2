function cohort_schooling_show(saveFigures, setNo)

cS = const_bc1(setNo);
figS = const_fig_bc1;

% CPS data
loadS = var_load_bc1(cS.vCohortSchooling, cS);
fracEnterV = sum(loadS.frac_scM(cS.iCD : cS.iCG, :));
fracGradV  = loadS.frac_scM(cS.iCG, :);
nCohorts = length(loadS.bYearV);

% Micro data
tgS = var_load_bc1(cS.vCalTargets, cS);
fracEnterMicroV = sum(tgS.schoolS.frac_scM(cS.iCD : cS.iCG, :));
fracGradMicroV  = tgS.schoolS.frac_scM(cS.iCG, :);


%% Plot: CPS school fractions and model cohorts

% Gap between birth year and year we show (hsg)
dYear = cS.cohYearV(1) - cS.bYearV(1);

fh = output_bc1.fig_new(saveFigures, []);
hold on;

for iCase = 1 : 2
   if iCase == 1
      % All cohorts as a line
      plotIdxV = 1 : nCohorts;
      lineStyleV = figS.lineStyleDenseV;
   elseif iCase == 2
      % Model cohorts as dots
      plotIdxV = zeros(size(cS.bYearV));
      for ic = 1 : length(cS.bYearV)
         [~, plotIdxV(ic)] = min(abs(loadS.bYearV - cS.bYearV(ic)));
      end
      lineStyleV = repmat({'o'}, size(figS.lineStyleDenseV));
   end

   iLine = 1;
   % Plotted by year of hsg
   plot(loadS.bYearV(plotIdxV) + dYear, fracEnterV(plotIdxV),  lineStyleV{iLine}, 'Color', figS.colorM(iLine,:));
   iLine = iLine + 1;
   plot(loadS.bYearV(plotIdxV) + dYear, fracGradV(plotIdxV),   lineStyleV{iLine}, 'Color', figS.colorM(iLine,:));
   
   if iCase == 2
      % Also plot micro data
      iLine = 1;
      plot(loadS.bYearV(plotIdxV) + dYear, fracEnterMicroV,  'd', 'Color', figS.colorM(iLine,:));
      iLine = iLine + 1;
      plot(loadS.bYearV(plotIdxV) + dYear, fracGradMicroV,   'd', 'Color', figS.colorM(iLine,:));      
   end
end

hold off;
xlabel(cS.formatS.cohortXLabelStr);
legend({'College entry', 'College graduation'}, 'Location', 'Best');
ylabel('Fraction');
output_bc1.fig_format(fh, 'line');

output_bc1.fig_save(fullfile(cS.dataOutDir, 'cohort_college'), saveFigures, cS);   

end

