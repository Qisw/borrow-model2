function borrow_limits(setNo)
% Construct borrowing limits by [year in college, cohort]
%{
Base year dollar amounts, at the START of each year in college

Checked: 2015-Mar-19
%}

cS = const_bc1(setNo);
figS = const_fig_bc1;
saveFigures = 1;



%% Data
% Current dollars

% Finaid.org: Aggregate borrowing limits
% Start year and aggregate amount
% dataM = [1967, 9000;
%    1973, 7500;
%    1977, 7500;
%    1981, 12500;
%    1987, 17250;
%    1992, 23000;
%    1994, 46000];


% finaid.org
% Subsidized + unsubsidized loan limits by year
% and lifetime max
% The lifetime max is actually just the sum over the first 4 years

dataM = [
1967	1500	1500	1500	1500	6000;
1973	1000	1500	2500	2500	7500;
1977	2500	2500	2500	2500	10000;
1987	6625	6625	8000	8000	29250;
1993	6625	7500	10500	10500	35125;
2007	9500	10500	12500	12500	45000;
2012	9500	10500	12500	12500	45000];

% No loans before 1967
dataM = [zeros([1, size(dataM, 2)]); dataM];
dataM(1,1) = 1900;



%% Extract "variables"

yLbV = dataM(:,1);
limitByYearM = dataM(:, 2:5);
lifetimeMaxV = dataM(:, 6);
clear dataM;


% Cumulative borrowin limits, imposing lifetime max
%  By year, year in college
bLimitM = nan(size(limitByYearM));
for iy = 1 : size(limitByYearM, 1)
   bLimitM(iy, :) = min(lifetimeMaxV(iy), cumsum(limitByYearM(iy,:), 2));
end




%% Plot by year
if 1
   fh = output_bc1.fig_new(saveFigures, []);
   hold on;
   
   for i1 = 1 : length(yLbV)
      if i1 < length(yLbV)
         yUb = yLbV(i1 + 1);
      else
         yUb = yLbV(i1) + 1;
      end      
      yearPlotV = max(1960, yLbV(i1)) : yUb;
      
      detrendV = data_bc1.detrending_factors(yearPlotV, cS.setNo);
      
      plot(yearPlotV,  lifetimeMaxV(i1) ./ detrendV,  figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   end
   
   hold off;
   xlabel('Year');
   ylabel('Borrowing limit, detrended');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'borrow_limit_year'), saveFigures, cS);
end


%% Plot by cohort
if 1
   bYearV = cS.bYearV(1) : cS.bYearV(end);
   yearV  = bYearV + 23;
   dataV  = zeros(size(bYearV));
   for ic = 1 : length(bYearV)
      if yearV(ic) >= yLbV(1)
         % Find the applicable year bracket
         bracketIdxV = find(yearV(ic) >= yLbV);
         
         dataV(ic) = lifetimeMaxV(bracketIdxV(end)) ./ data_bc1.detrending_factors(yearV(ic), cS.setNo);
      end
   end
   
   fh = output_bc1.plot_by_cohort(bYearV(:), dataV(:), saveFigures, cS);
   ylabel('Borrowing limit, detrended');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'borrow_limit_cohort'), saveFigures, cS);
end


%% Make into borrowing limits by [year in college, cohort]

% No of years in college
ny = max(cS.ageWorkStartM(:)) - 1;
bLimit_acM = nan([ny+1, cS.nCohorts]);
% No borrowing at start of year 1
bLimit_acM(1, :) = 0;

% Just first 4 years (with direct data)
tV = 1 : size(bLimitM, 2);

for iCohort = 1 : cS.nCohorts
   for iy = 1 : ny
      % First year in college
      year1 = cS.yearStartCollege_cV(iCohort);

      % Matching time period for borrowing limits
      yrIdx = find(year1 >= yLbV);
      yrIdx = yrIdx(end);
      bLimit_acM(1 + tV, iCohort) = -bLimitM(yrIdx, :)' ./ data_bc1.detrending_factors(year1, cS.setNo);

      % Extend to past 4 years. Assume that borrowing limit does not rise further +++
      tLast = 1 + tV(end);
      bLimit_acM(tLast : end, iCohort) = bLimit_acM(tLast, iCohort);
   end
end


validateattributes(bLimit_acM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<=', 0, ...
   'size', [ny+1, cS.nCohorts]})

var_save_bc1(bLimit_acM, cS.vBorrowLimits, cS);


end