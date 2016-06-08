% By j - simulate histories in college
%{
%}
function simS = sim_histories(hhS, paramS, cS)

dbg = cS.dbg;
% Max years in college
collLength = max(cS.ageWorkStartM(:)) - 1;

% Path of assets in college
%  at START of each period
%  restrict kPrime to be inside k grid for t+1
simS.k_tjM = nan([collLength + 1, cS.nTypes]);

% Hours in college (first 2 years, 2nd 2 years)
simS.hours_tjM = nan([collLength, cS.nTypes]);
% Consumption phases 1 and 2 in college
simS.cons_tjM = nan([collLength, cS.nTypes]);


% Start of life: endowment
simS.k_tjM(1,:) = paramS.k_jV;



%% Periods 1-2 (ability not known)

t = 1;
tV = 1 : 2;
[cons_jV, hours_jV, kPrime_jV] = hh_bc1.sim_college(hhS.v1S, simS.k_tjM(t,:)', length(tV), paramS, cS);
% Consumption and hours are constant over both periods
simS.cons_tjM(tV, :) = ones(length(tV),1) * cons_jV';
simS.hours_tjM(tV, :) = ones(length(tV),1) * hours_jV';

% Restrict inside period 3 k grid
%  Record as assets at start of period 3
kMin = hhS.vColl3S.kGridV(1);
kMax = hhS.vColl3S.kGridV(end);
simS.k_tjM(tV(end) + 1,:) = max(kMin, min(kMax, kPrime_jV));



%% Periods 3-4 in college

t = 3;
tV = 3 : 4;
[cons_jV, hours_jV, kPrime_jV] = hh_bc1.sim_college(hhS.vColl3S, simS.k_tjM(t,:)', length(tV), paramS, cS);

% Consumption and hours are constant over both periods
simS.cons_tjM(tV, :) = ones(length(tV),1) * cons_jV';
simS.hours_tjM(tV, :) = ones(length(tV),1) * hours_jV';

% Restrict to period 5 k grid
kMax = hhS.vColl5S.kGridV(end);
kMin = hhS.vColl5S.kGridV(1);
simS.k_tjM(tV(end) + 1, :) = max(kMin, min(kMax, kPrime_jV));


%% Period 5 in college

t = 5;
tV = 5;
[simS.cons_tjM(tV, :), simS.hours_tjM(tV, :), kPrime_jV] = hh_bc1.sim_college(hhS.vColl5S, simS.k_tjM(t,:)', ...
   length(tV), paramS, cS);

% No need to restrict to be inside of grid (works next period)
simS.k_tjM(tV(end) + 1, :) = kPrime_jV;


%% Implied: earnings and debt

% Earnings
simS.earn_tjM = simS.hours_tjM .* (ones([collLength,1]) * paramS.wColl_jV(:)');


% Debt levels (0 for those with positive k)
%  Contains NaNs because assets are computed only at end of each college period
simS.debt_tjM = max(0, -simS.k_tjM);



%% Output check

if cS.dbg > 10
   % k contains NaNs, except in these periods
   tV = [1, 3, 5, 6];
   validateattributes(simS.k_tjM(tV, :), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [length(tV), cS.nTypes]})
   validateattributes(simS.cons_tjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', [collLength, cS.nTypes]})
   validateattributes(simS.hours_tjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1, 'size', [collLength, cS.nTypes]})
   validateattributes(simS.earn_tjM,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      'size', [collLength, cS.nTypes]})
end

end

