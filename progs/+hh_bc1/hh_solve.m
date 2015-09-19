function saveS = hh_solve(paramS, cS)
% Solve hh problem. 1 cohort
%{
kPrime is not restricted to lie within the grid

Change
   how to set k grids +++

Checked: 2015-Mar-20
%}


%% Value of work
% Approx on k grid

vWorkS = hh_bc1.value_work(paramS, cS);
saveS.vWorkS = vWorkS;



%% Value of studying in period 5

age = cS.ageWorkStartM(cS.iCG, 1);
periodLength = 1;
nk = 50;
kGridV = linspace(paramS.kMin_aV(age), paramS.kMax, nk)';

% Continuation value: Value of working as CG next period
saveS.vColl5S = hh_bc1.value_college(age, periodLength, kGridV, vWorkS.evWorkCG_tjM(age+1, :)', paramS, cS);



%% Value of starting period 5
% Before graduation shock (year 4 or 5) is realized
% For each j: function approximation

age = cS.ageWorkStartM(cS.iCG, 1);
% Use the same grid, so we already have the values for entering college
kGridV = saveS.vColl5S.kGridV;
% Prob of graduating today
probGrad4 = paramS.probGradFour;

% Value functions
value_jV = cell([cS.nTypes, 1]);
for j = 1 : cS.nTypes
   % Value of working as CG, starting this period  OR  value of studying next period
   value_kV = probGrad4 .* saveS.vWorkS.evWorkCG_tjM{age, j}(kGridV)  +  ...
      (1 - probGrad4) .* saveS.vColl5S.value_kjM(:, j);
   value_jV{j} = griddedInterpolant(kGridV, value_kV, 'pchip', 'linear');
end

saveS.vStart5S.value_jV = value_jV;



%% Value of periods 3-4 in college
%  kPrime need not be restricted to grid range

age = cS.ageWorkStartM(cS.iCD,1);
periodLength = 2;
nk = 50;
kGridV = linspace(paramS.kMin_aV(age), paramS.kMax, nk)';

% Continuation value: Value of working as CG next period
saveS.vColl3S = hh_bc1.value_college(age, periodLength, kGridV, saveS.vStart5S.value_jV, paramS, cS);




%% Value at end of period 2, before learning ability

saveS.vmS = hh_bc1.coll_value_m(saveS.vColl3S, saveS.vWorkS, paramS, cS);



%% Periods 1-2 in college
% Every type has 1 k

age = 1;
periodLength = 2;
if max(abs(paramS.k_jV - paramS.k_jV(1))) > 1e-6
   error('Assuming that everyone has the same k endowment');
end

saveS.v1S = hh_bc1.value_college(age, periodLength, paramS.k_jV(1), saveS.vmS.valueFct_jV, paramS, cS);
% There is only 1 k per type. So the value is
saveS.v1S.value_jV = saveS.v1S.value_kjM(1, :)';


% if cS.runParallel == 1
%    matlabpool close;
% end


%% College entry decision

v0S.probEnter_jV = hh_bc1.college_entry(saveS.v1S, saveS.vWorkS, paramS, cS);

% Make sure someone always enters college
v0S.probEnter_jV = min(0.999, max(1e-3, v0S.probEnter_jV));

validateattributes(v0S.probEnter_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'positive', '<', 1, 'size', [cS.nTypes, 1]})

% Bound entry probs from both sides to prevent cases where all / nobody goes to college during
% calibration
% But do not force those who cannot afford college to enter
if all(v0S.probEnter_jV < 0.02)
   v0S.probEnter_jV = max(0.005, v0S.probEnter_jV);
elseif all(v0S.probEnter_jV > 0.98)
   v0S.probEnter_jV = min(0.995, v0S.probEnter_jV);
end

saveS.v0S = v0S;


%% High school graduation (exogenous)

saveS.probHsg_jV = hh_bc1.prob_hsg(paramS.endowS.abilMean_jV, paramS, cS);


end