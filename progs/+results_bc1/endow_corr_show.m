function endow_corr_show(setNo, expNo)
% Endowment correlations
% By simulation

cS = const_bc1(setNo, expNo);
statsS = var_load_bc1(cS.vAggrStats, cS);

corrS = statsS.endowCorrS;

[tbM, tbS] = latex_lh.corr_table(corrS.corrM, corrS.varNameV);
latex_lh.latex_texttb_lh(fullfile(cS.paramDir, 'endow_corr.tex'), tbM, 'Caption', 'Label', tbS);


end