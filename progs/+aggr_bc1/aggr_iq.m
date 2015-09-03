% Aggregates By IQ
function [iqS, iqYear2S, iqYear4S] = aggr_iq(aggrS, paramS, cS)


%% Allocate outputs

nIq = length(cS.iqUbV);

% Mean parental income by IQ quartile (for all)
iqS.logYpMean_qV = nan([nIq, 1]);


% *****  Stats for first 2 years in college (includes dropouts and grads)

% Mean college cost (for entrants)
iqYear2S.pMean_qV = nan([nIq, 1]);
% Average annual transfer (for entrants)
iqYear2S.transferMean_qV = nan([nIq, 1]);

% Average hours, first 2 years in college (for entrants)
iqYear2S.hoursCollMean_qV = nan([nIq, 1]);
% Average earnings, first 2 years in college (for entrants)
iqYear2S.earnCollMean_qV = nan([nIq, 1]);
iqYear2S.consCollMean_qV = nan([nIq, 1]);

% Debt at end of year 2
iqYear2S.debtMean_qV = nan([nIq, 1]);
iqYear2S.debtFrac_qV = nan([nIq, 1]);


% % Fraction in debt at end of college
% iqS.debtFracEoc_qV = nan([nIq, 1]);
% % Mean debt, NOT conditional on being in debt (end of college)
% iqS.debtMeanEoc_qV = nan([nIq, 1]);


% Debt at end of year 4
iqYear4S.debtFrac_qV = zeros([nIq, 1]);
iqYear4S.debtMean_qV = zeros([nIq, 1]);




%% Main

for iIq = 1 : nIq
   % *******  All

   % Mass by j for this IQ
   wtV = aggrS.aggr_jS.mass_jV .* paramS.prIq_jM(iIq, :)';
   % Parental income (not conditional on college)
   iqS.logYpMean_qV(iIq) = sum(wtV .* log(paramS.yParent_jV)) ./ sum(wtV);

   
   % *******  In college: first 2 years
   
   % Mass with IQ and j in college
   wt_jV = aggrS.aggr_jS.massColl_jV .* paramS.prIq_jM(iIq, :)';
   wt_jV = wt_jV ./ sum(wt_jV);
   
   % First 2 years in college
   iqYear2S.pMean_qV(iIq) = sum(wt_jV .* paramS.pColl_jV);   
   iqYear2S.transferMean_qV(iIq) = sum(wt_jV .* paramS.transfer_jV);

   iqYear2S.hoursCollMean_qV(iIq) = sum(wt_jV .* aggrS.simS.hours_tjM(1,:)');
   iqYear2S.earnCollMean_qV(iIq) = sum(wt_jV .* aggrS.simS.earn_tjM(1,:)');
   iqYear2S.consCollMean_qV(iIq) = sum(wt_jV .* aggrS.simS.cons_tjM(1,:)');
   
   % Debt at end of year 2
   iqYear2S.debtMean_qV(iIq) = sum(wt_jV .* aggrS.simS.debt_tjM(3,:)');
   iqYear2S.debtFrac_qV(iIq) = sum(wt_jV .* (aggrS.simS.debt_tjM(3,:)' > 0));
   
   
   % ******* For those in college 4 years or more
   
   % Mass = mass of college grads
   mass_jV = squeeze(aggrS.sqS.mass_sqjM(cS.iCG, iIq,:));
   mass_jV = mass_jV(:);
   
   % Debt at end of year 4 (from assets at year 5
   debt_jV = aggrS.simS.debt_tjM(5,:)';
   
   iqYear4S.debtFrac_qV(iIq) = sum(mass_jV .* (debt_jV > 0)) ./ sum(mass_jV);
   iqYear4S.debtMean_qV(iIq) = sum(mass_jV .* debt_jV) ./ sum(mass_jV);

   
%    % *** Debt stats at end of college
%    % Mass that exits at end of years 2 / 4, by j
%    mass_tjM = squeeze(aggrS.mass_sqjM([cS.iCD, cS.iCG], iIq,:));
% %    % debt at end of years 2 and 4
% %    debt_tjM = max(0, -aggrS.k_tjM(2:3, :));
%    iqS.debtFracEoc_qV(iIq) = sum(mass_tjM(:) .* (debt_tjM(:) > 0)) ./ sum(mass_tjM(:));
%    % Meand debt (not conditional)
%    iqS.iqS.debtMeanEoc_qV(iIq) = sum(mass_tjM(:) .* debt_tjM(:)) ./ sum(mass_tjM(:));
 
end



%% Output check

if cS.dbg > 10
   validateattributes(iqYear2S.pMean_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nIq, 1]})
   validateattributes(iqYear2S.debtMean_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0})
   validateattributes(iqYear2S.debtFrac_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1.001})
   validateattributes(iqYear4S.debtMean_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0})
   validateattributes(iqYear4S.debtFrac_qV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1.001})
end


end
