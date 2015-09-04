function iq_outcomes(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
nIq = length(cS.iqUbV);
iCohort = cS.iCohort;
% figS = const_fig_bc1;
% paramS = param_load_bc1(setNo, expNo);
aggrS = var_load_bc1(cS.vAggregates, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);

sqS = aggrS.sqS;


%% Bar graphs
if 1
   yStrV = {'Fraction entering college',  'Fraction graduating from college'};
   figFnV = {'iq_enter',   'iq_grad'};
   modelV = {sqS.fracEnter_qV, sqS.fracGrad_qV};
   dataV = {tgS.schoolS.fracEnter_qcM(:, iCohort), tgS.schoolS.fracGrad_qcM(:,iCohort)};
   
   for iPlot = 1 : length(modelV)
      fh = output_bc1.fig_new(saveFigures, []);
      mV = modelV{iPlot};
      dV = dataV{iPlot};
      bar(1 : nIq, [mV(:), dV(:)]);
      xlabel(cS.formatS.iqGroupStr);
      ylabel(yStrV{iPlot});
      legend({'Model', 'Data'}, 'location', 'northwest');
      figures_lh.axis_range_lh([NaN NaN 0 1]);
      output_bc1.fig_format(fh, 'bar');
      output_bc1.fig_save(fullfile(cS.outDir, figFnV{iPlot}), saveFigures, cS);
   end
end


end