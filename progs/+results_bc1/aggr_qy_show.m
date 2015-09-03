% Show aggregates by [q,y]
function aggr_qy_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
% paramS = param_load_bc1(setNo, expNo);
% hhS = var_load_bc1(cS.vHhSolution, cS);
aggrS = var_load_bc1(cS.vAggregates, cS);
qyS = aggrS.qyYear2S;


varNameV = {'consMean_qyM', 'earnMean_qyM', 'hoursMean_qyM', 'pMean_qyM', ...
   'debtMean_qyM', 'transferMean_qyM'};
fnStrV = {'cons_year2', 'earn_year2', 'hours_year2', 'college_costs_year2', ...
   'debt_year2', 'transfers_year2'};
zStrV = {'Consumption', 'Earnings', 'Hours', 'College costs', ...
   'Debt (year 2)', 'Transfers'};

for iPlot = 1 : length(varNameV)
   model_qyM = qyS.(varNameV{iPlot});
   output_bc1.bar_graph_qy(model_qyM, zStrV{iPlot}, saveFigures, cS);
   output_bc1.fig_save(['qy_', fnStrV{iPlot}], saveFigures, cS);
end

end