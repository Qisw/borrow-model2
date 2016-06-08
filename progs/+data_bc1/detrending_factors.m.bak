function [outV, outRealV] = detrending_factors(yearV, setNo)
% Make detrending factors by year from xls
%{
It is now easy to retrieve by year 
Detrending factor is CPI / cS.unitAcct
Also returns detrending factors for REAL variables (a constant)

The values for cpiBaseYear are 1000 (cS.unitAcct)
%}

cS = const_bc1(setNo);

% For detrending by Nominal disposable income per capita
% tbM = readtable(fullfile(cS.dataDir, 'nipa.xlsx'));
% dS  = econ_lh.DataByYearLH(tbM);
% 
% outV = dS.retrieve('NomDispIncome', yearV, cS.dbg) ./ ...
%    dS.retrieve('NomDispIncome', cS.cpiBaseYear, cS.dbg) .* cS.unitAcct;

cpiS = econ_lh.CpiLH(cS.cpiBaseYear);

% Real series: no detrending
outRealV = ones(length(yearV), 1) .* cS.unitAcct;
% Nominal series: divide by cpi
outV = outRealV .* cpiS.retrieve(yearV);



end
