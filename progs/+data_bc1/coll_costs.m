function coll_costs(setNo)
% Read file with college costs by year
%{
Constant dollars

Checked: 2015-Sep-3
%}


cS = const_bc1(setNo);
figS = const_fig_bc1;
saveFigures = 1;


%% Make college costs

% Read data from xls
% public and private colleges
xlsFn = fullfile(cS.dataDir, 'college costs herrington.xlsx');
numM = xlsread(xlsFn);

yearV = numM(:, 1);
validateattributes(yearV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1800, ...
   '<', 2020})
% Nominal amount per student
%  Product of revenue * (fraction of revenue from tuition)
tuitionV = numM(:,3) .* numM(:,2);


% Detrending factors for a nominal series
% detrendV = data_bc1.detrending_factors(yearV, setNo);

cpiS = econ_lh.CpiLH(cS.cpiBaseYear);
detrendV = cpiS.retrieve(yearV);

% Common year range
yrIdxV = find(~isnan(detrendV));
saveS.yearV = yearV(yrIdxV);
saveS.tuitionV = tuitionV(yrIdxV) ./ detrendV(yrIdxV);

validateattributes(saveS.tuitionV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})

var_save_bc1(saveS, cS.vCollCosts, cS);


%% College costs by year
% Constant prices
if 1
   fh = output_bc1.fig_new(saveFigures, []);
   plot(saveS.yearV, saveS.tuitionV, figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   xlabel('Year');
   ylabel('Mean college cost');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'collcost_year'), saveFigures, cS);
end



%% College costs by cohort
% Not exactly right. We use tutition at a different age.
if 1
   
   bYearV = saveS.yearV(:) - 23;
   dataV  = saveS.tuitionV(:);
   % Only show reasonably recent years
   yrIdxV = find(bYearV >= cS.bYearV(1));

   fh = output_bc1.plot_by_cohort(bYearV(yrIdxV), dataV(yrIdxV), saveFigures, cS);
   ylabel(sprintf('Mean college cost, %i prices', cS.cpiBaseYear));
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'collcost_cohort'), saveFigures, cS);   
end



end