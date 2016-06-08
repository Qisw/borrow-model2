function [ypS, ypYear2S, ypYear4S, ypGradS] = aggr_yp(aggrS, paramS, cS)
% Aggregates: By parental income class
%{
This repeats code for aggregates by IQ
%}

% nIq = length(cS.iqUbV);
nyp = length(cS.ypUbV);



%% Allocate outputs

ypS.mass_syM = nan([cS.nSchool, nyp]);

% Mass who enter / graduate
ypS.massEnter_yV = zeros([nyp, 1]);
% ypS.fracGrad_yV = zeros([nyp, 1]);
% This is NOT conditional on college
ypS.logYpMean_yV = zeros([nyp, 1]);
ypS.transferMean_yV = zeros([nyp, 1]);
ypS.abilMean_yV = zeros([nyp, 1]);


% ******  Years 1-2 in college

% Fin stats for *first 2 years* in college
% Initialize all with zeros so that deviation is valid when nobody goes to college in a group
ypYear2S.pMean_yV = nan([nyp, 1]);
% ANNUAL transfer (to be comparable with data targets
ypYear2S.transferMean_yV = zeros([nyp, 1]);
ypYear2S.hoursCollMean_yV = zeros([nyp, 1]);
ypYear2S.earnCollMean_yV = zeros([nyp, 1]);
ypYear2S.consCollMean_yV = zeros([nyp, 1]);
ypYear2S.debtFrac_yV = nan(nyp, 1);
ypYear2S.debtMean_yV = nan(nyp, 1);


% ******  Years 3-4 in college

% Debt at end of year 4 (these are CG)
ypYear4S.debtFrac_yV = zeros([nyp, 1]);
ypYear4S.debtMean_yV = zeros([nyp, 1]);


% College grads at end of college
ypGradS.debtFrac_yV = zeros([nyp, 1]);
ypGradS.debtMean_yV = zeros([nyp, 1]);



%% Main

for iy = 1 : nyp
   % ********  All
   
   % Types in this class
   jIdxV = find(paramS.endowS.ypClass_jV == iy);
   totalMass = sum(aggrS.aggr_jS.mass_jV(jIdxV));
   
   % Mass(s,y) = sum over all j in yp class
   for iSchool = 1 : cS.nSchool
      ypS.mass_syM(iSchool, iy) = sum(aggrS.aggr_jS.mass_sjM(iSchool, jIdxV), 2);
   end
   ypS.massEnter_yV(iy) = sum(ypS.mass_syM(cS.iCD : cS.nSchool, iy));   

   % Average parental income (not conditional on college)
   wtV = aggrS.aggr_jS.mass_jV(jIdxV);
   wtV = wtV ./ sum(wtV);
   ypS.logYpMean_yV(iy) = sum(wtV .* log(paramS.yParent_jV(jIdxV)));
   ypS.transferMean_yV(iy) = sum(wtV .* paramS.transfer_jV(jIdxV));
   ypS.abilMean_yV(iy) = sum(wtV .* paramS.endowS.abilMean_jV(jIdxV));

   
   % *******  College entrants
   
   % Their masses in college
   massColl_jV = sum(aggrS.aggr_jS.mass_sjM(cS.iCD : cS.nSchool, jIdxV));
   jMass = sum(massColl_jV);

   if jMass > 0
      % ******  First 2 years in college (all entrants)

      frac_jV = massColl_jV(:) ./ jMass;

      ypYear2S.pMean_yV(iy) = sum(frac_jV .* paramS.pColl_jV(jIdxV));
      % Transfer (annualized)
      ypYear2S.transferMean_yV(iy) = sum(frac_jV .* paramS.transfer_jV(jIdxV));
      ypYear2S.hoursCollMean_yV(iy) = sum(frac_jV .* aggrS.simS.hours_tjM(1,jIdxV)');
      ypYear2S.earnCollMean_yV(iy) = sum(frac_jV .* aggrS.simS.earn_tjM(1,jIdxV)');
      ypYear2S.consCollMean_yV(iy) = sum(frac_jV .* aggrS.simS.cons_tjM(1,jIdxV)');
      ypYear2S.debtMean_yV(iy) = sum(frac_jV .* aggrS.simS.debt_tjM(3,jIdxV)');
      ypYear2S.debtFrac_yV(iy) = sum(frac_jV .* (aggrS.simS.debt_tjM(3,jIdxV)' > 0));

      
%       % *** Debt stats at end of college
%       % Mass that exits at end of years 2 / 4
%       % mass_tjM = aggrS.mass_sjM([cS.iCD, cS.iCG],jIdxV);
% 
%       % debt at end of years 2 and 4
%       debt_tjM = max(0, -aggrS.k_tjM(2:3, jIdxV));
%       debtFrac_yV(iy) = sum(mass_tjM(:) .* (debt_tjM(:) > 0)) ./ sum(mass_tjM(:));
%       % Meand debt (not conditional)
%       debtMean_yV(iy) = sum(mass_tjM(:) .* debt_tjM(:)) ./ sum(mass_tjM(:));


      % *******  At the end of 4 years in college (graduates only)
      
      frac_jV = aggrS.aggr_jS.mass_sjM(cS.iCG, jIdxV);
      frac_jV = frac_jV(:) ./ sum(frac_jV);

      % Debt at end of year 4
      ypYear4S.debtFrac_yV(iy) = sum(frac_jV .* (aggrS.simS.debt_tjM(5,jIdxV)' > 0));
      ypYear4S.debtMean_yV(iy) = sum(frac_jV .* aggrS.simS.debt_tjM(5,jIdxV)');

      
      % ******  College grads at end of college
      % Same as those who stay 4+ years
      mass_jV = frac_jV;
      % Everybody graduates in 4 or 5 years with same probability
      prob4 = paramS.probGradFour;
      debt_tjM = aggrS.simS.debt_tjM(5:6, jIdxV);
      hasDebt_tjM = (debt_tjM > 0);

      ypGradS.debtFrac_yV(iy) = sum(mass_jV .* (prob4 .* hasDebt_tjM(1,:)'  +  (1 - prob4) .* hasDebt_tjM(2,:)'));
      ypGradS.debtMean_yV(iy) = sum(mass_jV .* (prob4 .* debt_tjM(1,:)'  +  (1 - prob4) .* debt_tjM(2,:)'));
      


      % ******  Stats by [iq, yp]
      % should be in aggr_qy.m

%          % Mass (q,y) = sum over j in y group  Pr(iq|j) * mass(j)
%          mass_qyM(:, iy) = sum(paramS.prIq_jM(:, jIdxV) .* (ones([nIq,1]) * aggrS.mass_jV(jIdxV)'), 2);
% 
%          % Mass in college by [iq, j] for the right yp group
%          massColl_qyM(:, iy) = sum(paramS.prIq_jM(:, jIdxV) .* (ones([nIq,1]) * massColl_jV(:)'), 2);
% 
%          % Mass in college by [iq, j] for the right yp group
%          massGrad_qyM(:, iy) = sum(paramS.prIq_jM(:, jIdxV) .* (ones([nIq,1]) * massGrad_jV(:)'), 2);
   end
end

massHsgPlus_yV = sum(ypS.mass_syM(cS.iHSG : cS.nSchool, iy), 1);
ypS.fracEnter_yV = ypS.massEnter_yV ./ massHsgPlus_yV;
ypS.fracGrad_yV  = ypS.mass_syM(cS.iCG, :)' ./ massHsgPlus_yV;

   
%% Output check

if cS.dbg > 10
   validateattributes(ypYear2S.pMean_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nyp,1]})
   validateattributes(ypYear2S.transferMean_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, 'size', [nyp,1]})
   validateattributes(ypYear4S.debtFrac_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1.001, 'size', [nyp,1]})
   validateattributes(ypYear4S.debtMean_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, 'size', [nyp,1]})


   validateattributes(ypGradS.debtFrac_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1.001,  'size', [nyp, 1]})
   validateattributes(ypGradS.debtMean_yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
         'size', [nyp, 1]})
end

ypYear2S.debtFrac_yV = min(1, ypYear2S.debtFrac_yV);
ypYear4S.debtFrac_yV = min(1, ypYear4S.debtFrac_yV);


end
