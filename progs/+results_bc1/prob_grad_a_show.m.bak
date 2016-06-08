function prob_grad_a_show(setNo, expNo)

cS = const_bc1(setNo, expNo);
saveFigures = 1;
paramS = param_load_bc1(setNo, expNo);

% Put prGradMin on a grid
ng = 5;
prGradMinV = linspace(0.01, 0.5, ng);

yM = nan(cS.nAbil, ng);

for ig = 1 : ng
   paramS.prGradMin = prGradMinV(ig);
   yM(:, ig) = calibr_bc1.pr_grad_a(1 : cS.nAbil, paramS, cS);
end

fh = results_bc1.plot_by_abil(yM, saveFigures, cS);
ylabel('Graduation probability');
figures_lh.axis_range_lh([NaN NaN 0 1]);
legend(string_lh.vector_to_string_array(prGradMinV, '%.2f'));
output_bc1.fig_format(fh, 'line');
output_bc1.fig_save(fullfile(cS.paramDir, 'prob_grad_a_explore'), saveFigures, cS);


end