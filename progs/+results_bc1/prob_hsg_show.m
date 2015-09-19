function prob_hsg_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
% figS = const_fig_bc1;
hhS = var_load_bc1(cS.vHhSolution, cS);
yV = hhS.probHsg_jV;


% For trying alternative parameters
if 0
   paramS = param_load_bc1(setNo, expNo);
   paramS.probHsgMin = 0.6;
   paramS.probHsgOffset = -0.75;
   paramS.probHsgMult = 2;
   yV = [yV,  hh_bc1.prob_hsg(paramS.endowS.abilMean_jV, paramS, cS)];
end

fh = results_bc1.plot_by_m(yV, saveFigures, cS);
ylabel('Prob HSG');
figures_lh.axis_range_lh([0, 1, 0, 1]);
output_bc1.fig_format(fh, 'line');
output_bc1.fig_save(fullfile(cS.paramDir, 'prob_hsg_m'), saveFigures, cS);


end