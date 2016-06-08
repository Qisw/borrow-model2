function outV = hollis_read(varNameV, cS)
% Read Hollis xls file with financing info
% In units of account
% Data are provided in base year prices

% Hollis applied to all
m=readtable('/Users/lutz/Dropbox/borrowing constraints/Calibration targets/data from todd/hollis_means.xls');

outV = nan(size(varNameV));
for iVar = 1 : length(varNameV)
   varIdx = find(strncmpi(m.stat, varNameV{iVar}, length(varNameV{iVar})));
   if length(varIdx) == 1
      outV(iVar) = m.value(varIdx) ./ cS.unitAcct;
   else
      error('Not found');
   end
end


end