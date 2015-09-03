function prob_hsg_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
% figS = const_fig_bc1;
% paramS = param_load_bc1(setNo, expNo);
hhS = var_load_bc1(cS.vHhSolution, cS);

fh = results_bc1.plot_by_m(hhS.probHsg_jV, saveFigures, cS);
ylabel('Prob HSG');
figures_lh.axis_range_lh([0, 1, 0, 1]);
output_bc1.fig_format(fh, 'line');
output_bc1.fig_save(fullfile(cS.paramDir, 'prob_hsg_m'), saveFigures, cS);


end