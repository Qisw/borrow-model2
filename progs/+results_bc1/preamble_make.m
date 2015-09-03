function preamble_make(setNo, expNo)
% Write data for preamble
%{
Notation is in symbol table
%}

cS = const_bc1(setNo, expNo);



%% Other model notation
% results_bc1.preamble_add('prefHS', '\bar{\eta}', 'Common preference for HS', cS);
% results_bc1.preamble_add('prefShockEntry', '\eta', 'Preference shock at college entry', cS);

% outS = helper_bc1.symbols;
% fnV = fieldnames(outS);
% for i1 = 1 : length(fnV)
%    results_bc1.preamble_add(fnV{i1},  outS.(fnV{i1}),  'Symbol', cS);
% end


%% Data constants

results_bc1.preamble_add('cpiBaseYear',  sprintf('%i', cS.cpiBaseYear),  'CPI base year',  cS);
results_bc1.preamble_add('collCostAge',  sprintf('%i', cS.dataS.collCostAge), 'Age for which college cost is taken', cS);


results_bc1.preamble_write(cS);

end