function outS = endow_corr(paramS, cS)
% Endowment correlations, by simulation

symS = helper_bc1.symbols;

% Draw a sample of j and their continuous IQ, abilities
[abilV, jV, iqV] = calibr_bc1.endow_sim(1e4, paramS, cS);

% Correlation matrix
outS.varNameV = {symS.retrieve('ability', true), symS.retrieve('abilSignal', true), ...
   symS.retrieve('IQ', true), symS.retrieve('collCost', true), symS.retrieve('pTransfer', true), '$\ln(y)$'};
outS.iAbil = 1;
outS.iSignal = 2;
outS.iIq = 3;
outS.iCost = 4;
outS.iTransfer = 5;
outS.iYp = 6;

outS.corrM = corrcoef([abilV, paramS.m_jV(jV), iqV, paramS.pColl_jV(jV), paramS.transfer_jV(jV), ...
   log(paramS.yParent_jV(jV))]);

   
end
