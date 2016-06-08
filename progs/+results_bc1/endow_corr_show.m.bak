function endow_corr_show(setNo, expNo)
% Endowment correlations
% By simulation

cS = const_bc1(setNo, expNo);
symS = helper_bc1.symbols;
% statsS = var_load_bc1(cS.vAggrStats, cS);
% 
% corrS = statsS.endowCorrS;
paramS = param_load_bc1(setNo, expNo);
endowS = paramS.endowS;

% Make cov matrix into correlation matrix
[~, corrM] = cov2corr(endowS.covMatM);
nVar = size(corrM, 1);

% Variable names
varNameV = cell(nVar, 1);
varNameV{endowS.iYp} = symS.retrieve('famIncome', true);
varNameV{endowS.iTransfer} = symS.retrieve('pTransfer', true);
varNameV{endowS.iIq} = symS.retrieve('IQ', true);
varNameV{endowS.iSignal} = symS.retrieve('abilSignal', true);
varNameV{endowS.iAbil} = symS.retrieve('ability', true);

[tbM, tbS] = latex_lh.corr_table(corrM, varNameV);
latex_lh.latex_texttb_lh(fullfile(cS.paramDir, 'endow_corr.tex'), tbM, 'Caption', 'Label', tbS);



end