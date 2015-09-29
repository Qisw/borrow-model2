function borrow_limits(setNo)
% Construct borrowing limits by [year in college, cohort]
%{
In units of account

There is no point trying to construct this from an aggregate series
Each cohort needs to be hand coded

Checked: 2015-Mar-19
%}

cS = const_bc1(setNo);
figS = const_fig_bc1;
saveFigures = 1;



%% Data: Aggregate series, but we don't use this 
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
% This looks like independent students to me

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


%% Borrowing limits by [year in college, cohort]
% Hand coded for each cohort

% No of years in college
ny = max(cS.ageWorkStartM(:)) - 1;
bLimit_acM = nan([ny+1, cS.nCohorts]);
% No borrowing at start of year 1
bLimit_acM(1, :) = 0;

% Just first 4 years (with direct data)
% tV = 1 : size(bLimitM, 2);

for iCohort = 1 : cS.nCohorts
   % First year in college
   year1 = cS.cohortS.yearStartCollegeV(iCohort);
   % Years in college
   collYearV = year1 + (0 : ny);
   detrendV = data_bc1.detrending_factors(collYearV, cS.setNo);
   
   if year1 < 1967 - 5
      % No loans
      bLimit_acM(:, iCohort) = 0;
      
   elseif cS.bYearV(iCohort) == 1961
      % NLSY 79
      % GSL loans for everyone
      % Nominal loan limit until 1987 is $2500 per year with cumulative limit of $10,000
      % (finaid.org)
      limitV = zeros(ny+1, 1);
      limitV(2 : 5) = 2500 : 2500 : 10000;
      limitV(6 : end) = 10000;
      bLimit_acM(:, iCohort) = -limitV(:) ./ detrendV;
      
   elseif cS.bYearV(iCohort) == 1979
      % NLSY97
      % ?Trends in Undergraduate Borrowing II: Federal Student Loans in 1995-96, 1999-2000, and 2003-04,? March 18, 2008. http://nces.ed.gov/pubsearch/pubsinfo.asp?pubid=2008179rev.
      % Table 1. for dependent students
      limitV = zeros(ny+1, 1);
      limitV(2 : 6) = cumsum([2600, 3500, 5500, 5500, 5500]);
%       limitV(6 : end) = limitV(5);
      bLimit_acM(:, iCohort) = -limitV(:) ./ detrendV;
      
   else
      error('Not implemented');
   end
   
   
   % Make sure inflation does not erode borrowing limits over time
   for iy = 3 : (ny+1)
      bLimit_acM(iy,:) = min(bLimit_acM(iy-1,:), bLimit_acM(iy,:));
   end
      

%    % Matching time period for borrowing limits
%    yrIdx = find(year1 >= yLbV);
%    yrIdx = yrIdx(end);
%    bLimit_acM(1 + tV, iCohort) = -bLimitM(yrIdx, :)' ./ data_bc1.detrending_factors(year1 - 1 + tV, cS.setNo);
% 
%    % Extend to past 4 years. Assume that borrowing limit does not rise further +++
%    tLast = 1 + tV(end);
%    bLimit_acM(tLast : end, iCohort) = bLimit_acM(tLast, iCohort);
end


validateattributes(bLimit_acM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<=', 0, ...
   'size', [ny+1, cS.nCohorts]})

var_save_bc1(bLimit_acM, cS.vBorrowLimits, cS);




end