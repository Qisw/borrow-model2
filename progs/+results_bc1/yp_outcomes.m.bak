function yp_outcomes(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
nYp = length(cS.ypUbV);
iCohort = cS.iCohort;
% figS = const_fig_bc1;
% paramS = param_load_bc1(setNo, expNo);
aggrS = var_load_bc1(cS.vAggregates, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);


%% Bar graphs
if 1
   yStrV = {'Fraction entering college',  'Fraction graduating from college',  'Mean transfer',  'Mean ability'};
   figFnV = {'yp_enter',   'yp_grad',  'yp_transfer',  'yp_ability'};
   modelV = {aggrS.ypS.fracEnter_yV, aggrS.ypS.fracGrad_yV, aggrS.ypS.transferMean_yV, aggrS.ypS.abilMean_yV};
   dataV = {tgS.schoolS.fracEnter_ycM(:, iCohort), tgS.schoolS.fracGrad_ycM(:,iCohort), [], []};
   yLbV = [0, 0, 0, NaN];
   yUbV = [1, 1, NaN, NaN];   
   
   for iPlot = 1 : length(modelV)
      fh = output_bc1.fig_new(saveFigures, []);
      mV = modelV{iPlot};
      dV = dataV{iPlot};
      if isempty(dV)
         bar(1 : nYp, mV(:));
         legendV = {'Model'};
      else
         bar(1 : nYp, [mV(:), dV(:)]);
         legendV = {'Model', 'Data'};
      end
      xlabel('yp group');
      ylabel(yStrV{iPlot});
      legend(legendV, 'location', 'northwest');
      figures_lh.axis_range_lh([NaN NaN  yLbV(iPlot), yUbV(iPlot)]);
      output_bc1.fig_format(fh, 'bar');
      output_bc1.fig_save(fullfile(cS.outDir, figFnV{iPlot}), saveFigures, cS);
   end
end


end