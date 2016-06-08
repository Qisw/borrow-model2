function hh_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
if cS.runLocal == 0
   warning('Cannot run hh_show on server. Matlab version outdated.');
   return
end
figS = const_fig_bc1;
paramS = param_load_bc1(setNo, expNo);
hhS = var_load_bc1(cS.vHhSolution, cS);
aggrS = var_load_bc1(cS.vAggregates, cS);

% Prob of grad conditional on entry
prGrad_jV = aggrS.aggr_jS.mass_sjM(cS.iCG, :) ./ sum(aggrS.aggr_jS.mass_sjM(cS.iCD : cS.nSchool, :));
prGrad_jV = prGrad_jV(:);

% Collect info and sort by expected ability
dataM = table(paramS.endowS.abilMean_jV, paramS.m_jV, paramS.prob_jV, hhS.v0S.probEnter_jV, prGrad_jV, ...
   paramS.transfer_jV,  ...
   aggrS.simS.cons_tjM(1,:)',  aggrS.simS.cons_tjM(3,:)',  aggrS.simS.hours_tjM(1,:)', aggrS.simS.hours_tjM(3,:)');
dataM.Properties.VariableNames = {'abilMean', 'm', 'probJ', 'probEnter', 'prGradJ', ...
   'zColl', 'c1', 'c2', 'hours1', 'hours2'};
dataM = sortrows(dataM, 1);
dataM.cumProbJ = cumsum(dataM.probJ);


%% Simple x-y plots
if 1
   xStrV = {'abilMean',     'abilMean',     'abilMean',     'abilMean',     'abilMean',     'abilMean',   ...
      'c1',    'c2'};
   yStrV = {'entry', 'c1',    'c2', 'leisure1',  'leisure2', 'prGradJ', ...
      'leisure1', 'leisure2'};
   for iPlot = 1 : length(xStrV)
      [xV, xLabelStr, xFigStr] = fig_data(xStrV{iPlot}, dataM);
      [yV, yLabelStr, yFigStr] = fig_data(yStrV{iPlot}, dataM);
      
      
      fh = output_bc1.fig_new(saveFigures, []);
      hold on;
      plot(xV,  yV, 'o', 'color', figS.colorM(1,:));
      xlabel(xLabelStr);
      ylabel(yLabelStr);
      % Scale y axis for leisure plots
      if strncmpi(yLabelStr, 'leisure', 7)
         figures_lh.axis_range_lh([NaN NaN 0.5 1]);
      end
      output_bc1.fig_format(fh, 'line');
      output_bc1.fig_save(fullfile(cS.hhDir, [yFigStr, '_', xFigStr]), saveFigures, cS);
   end
end




%% Transfers and parental income
if 0
   fh = output_bc1.fig_new(saveFigures, []);
   hold on;
   xV = (paramS.yParent_jV);
   plot(xV,  (hhS.v0S.zColl_jV), 'o', 'color', figS.colorM(1,:));
   plot([min(xV), max(xV)], [min(xV), max(xV)], '--', 'color', figS.colorM(2,:));
   xlabel('Parental income');
   ylabel('Transfer (college)');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.hhDir, 'z_yp'), saveFigures, cS);
end




end


%% Get info for figures
   function [dataV, labelStr, figStr] = fig_data(inStr, dataM)
      if strcmp(inStr, 'm')
         labelStr = 'Ability signal (cum pct)';
         dataV = dataM.cumProbJ;
         figStr = 'm';
      elseif strcmp(inStr, 'abilMean')
         labelStr = 'Expected ability percentile';
         dataV = dataM.abilMean;
         figStr = 'abilMean';
      elseif strcmp(inStr, 'c1')
         labelStr = 'Cons period 1';
         dataV = dataM.c1;
         figStr = 'c1';
      elseif strcmp(inStr, 'c2')
         labelStr = 'Cons period 2';
         dataV = dataM.c2;
         figStr = 'c2';
      elseif strcmp(inStr, 'leisure1')
         labelStr = 'Leisure period 1';
         dataV = 1 - dataM.hours1;
         figStr = 'leisure1';
      elseif strcmp(inStr, 'leisure2')
         labelStr = 'Leisure period 2';
         dataV = 1 - dataM.hours2;
         figStr = 'leisure2';
      elseif strcmp(inStr, 'entry')
         labelStr = 'College entry rate';
         dataV = dataM.probEnter;
         figStr = 'probEnter';
      elseif strcmp(inStr, 'prGradJ')
         labelStr = 'Prob grad';
         dataV = dataM.prGradJ;
         figStr = 'probGrad';
      else
         error('Invalid');
      end
      
   end
