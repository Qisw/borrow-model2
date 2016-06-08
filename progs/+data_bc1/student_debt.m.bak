function student_debt(setNo)
%{
Checked: 2015-Sep-2
%}

cS = const_bc1(setNo);
saveFigures = 1;

% Load data from Trends in Student Aid
%   2013 prices, starts in 1970
tbM = readtable(fullfile(cS.dataDir, 'trends_student_aid.xlsx'));

% Start with federal loans per undergraduate
avgDebtV = tbM.FedLoanPerUndergrad;

% Compute ratio of loans per undergrad to loans per student (incl graduate)
% First year with data
idxV = find(~isnan(tbM.FedLoanPerUndergrad));
ratio1 = tbM.FedLoanPerUndergrad(idxV(1)) ./ tbM.FedLoanPerStudent(idxV(1));

% Impute loans per undergad in early years assuming that the ratio is constant over time
idxV = find(isnan(tbM.FedLoanPerUndergrad));

% This is the imputed debt series in 2013 prices
avgDebtV(idxV) = ratio1 .* tbM.FedLoanPerStudent(idxV);


% Make into base year prices
cpiS = econ_lh.CpiLH(2013);
avgDebtV = avgDebtV  .*  cpiS.retrieve(2013)  ./ cpiS.retrieve(cS.cpiBaseYear);


% Detrend the real series
[~, detrendV] = data_bc1.detrending_factors(tbM.Year, setNo);
avgDebtV = avgDebtV ./ detrendV;

% % Make into base year prices
% cpiS = econ_lh.CpiLH(cS.cpiBaseYear);
% cpiV = cpiS.retrieve([cS.cpiBaseYear, 2013]);
% 
% avgDebtV = avgDebtV  ./ cpiV(2) .* cpiV(1);


%% Before data start: linear trend from 0 in 1963
% as in Avery and Turner (JEP)

saveS.yearV = (1950 : tbM.Year(end))';
saveS.avgDebtV = zeros(size(saveS.yearV));

% First year with data
idxV = find(~isnan(avgDebtV));
yr1 = tbM.Year(idxV(1));
yrIdx1 = yr1 - saveS.yearV(1) + 1;
saveS.avgDebtV(yrIdx1 : end) = avgDebtV(idxV);

% Year assumed 0 debt
year0 = 1963;
yrIdx0 = year0 - saveS.yearV(1) + 1;
saveS.avgDebtV(yrIdx0 : yrIdx1) = linspace(0, saveS.avgDebtV(yrIdx1), yrIdx1 - yrIdx0 + 1);


%% Save

var_save_bc1(saveS, cS.vStudentDebtData, cS);


%% Plot
if 1
   figS = const_fig_bc1;
   fh = output_bc1.fig_new(saveFigures, []);
   plot(saveS.yearV, saveS.avgDebtV, figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   xlabel('Year');
   ylabel('Average debt per undergraduate');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'debt_mean_year'), saveFigures, cS);
end


end