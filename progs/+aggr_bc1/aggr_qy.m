function [qyS, qyYear2S, qyYear4S] = aggr_qy(aggrS, paramS, cS)
% Aggregates by [IQ, yp] quartile
%{
Checked: 2015-Jul-6
%}

dbg = cS.dbg;
nIq = length(cS.iqUbV);
nyp = length(cS.ypUbV);



%% Probabilities: Entrants

% Prob j among college entrants
pr_jV = aggrS.aggr_jS.massColl_jV;
pr_jV = pr_jV ./ sum(pr_jV);

% We have Pr(j) and Pr(IQ | j). Use Bayes rule to compute the rest
pmS = stats_lh.ProbMatrix2D(paramS.prIq_jM, pr_jV);

prJ_qM = pmS.prX_yM;
validateattributes(prJ_qM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nTypes, nIq]})
clear pmS;



%% Allocate output matrices

% First 2 years in college
qyYear2S.zMean_qyM = nan([nIq, nyp]);
qyYear2S.consMean_qyM = nan([nIq, nyp]);
qyYear2S.earnMean_qyM = nan([nIq, nyp]);
qyYear2S.debtMean_qyM = nan([nIq, nyp]);
qyYear2S.pMean_qyM = nan([nIq, nyp]);

% Years 3-4 in college
qyYear4S.debtMean_qyM = nan([nIq, nyp]);


% ******  All

qyS.mass_sqyM = zeros([cS.nSchool, nIq, nyp]);
qyS.mass_qyM = nan([nIq, nyp]);
%  Mass in college
qyS.massColl_qyM = nan([nIq, nyp]);



%% Main loop

for iy = 1 : nyp
   % j in this class
   jIdxV = find(paramS.ypClass_jV == iy);
   
   
   % ********  All
   
   % Mass by [s,j] for j in yp group
   mass_sjM = aggrS.aggr_jS.mass_sjM(:, jIdxV);
   
   for iSchool = 1 : cS.nSchool
      % Mass(s,q,y) = sum over j in yp group: Pr(iq|j) * mass(j)
      qyS.mass_sqyM(iSchool,:,iy) = sum(paramS.prIq_jM(:,jIdxV) .* (ones(nIq,1) * mass_sjM(iSchool,:)), 2);
   end
   
   qyS.mass_qyM(:, iy) = sum(qyS.mass_sqyM(:,:,iy), 1);
   
   % Mass in college by [iq, j] for the right yp group
   qyS.massColl_qyM(:, iy) = sum(qyS.mass_sqyM(cS.iCD : cS.nSchool, :, iy), 1);


   for iIq = 1 : nIq
      % ****  Years 1-2 in college
      % E(x | q,y) = sum over j in y class:  Prob(j | q) * x(j)
      probV = prJ_qM(jIdxV, iIq);
      probV = probV ./ sum(probV);
      
      qyYear2S.transferMean_qyM(iIq, iy) = sum(probV .* paramS.transfer_jV(jIdxV));
      qyYear2S.pMean_qyM(iIq, iy) = sum(probV .* paramS.pColl_jV(jIdxV));
      qyYear2S.consMean_qyM(iIq, iy) = sum(probV .* aggrS.simS.cons_tjM(1, jIdxV)');
      qyYear2S.earnMean_qyM(iIq, iy) = sum(probV .* aggrS.simS.earn_tjM(1, jIdxV)');
      qyYear2S.hoursMean_qyM(iIq, iy) = sum(probV .* aggrS.simS.hours_tjM(1, jIdxV)');
      qyYear2S.debtMean_qyM(iIq, iy) = sum(probV .* aggrS.simS.debt_tjM(3, jIdxV)');

      
      % ****  Years 3-4 in college
      
      % probV = ?
      % qyYear4S.debtMean_qyM(iIq, iy) = sum(probV .* aggrS.simS.debt_tjM(5, jIdxV)');
   end
end


% Fraction college out of HSG
massHsgPlus_qyM = squeeze(sum(qyS.mass_sqyM(cS.iHSG : cS.nSchool, :, :), 1));
qyS.fracEnter_qyM = qyS.massColl_qyM ./ massHsgPlus_qyM;
qyS.fracGrad_qyM = squeeze(qyS.mass_sqyM(cS.iCG, :,:)) ./ massHsgPlus_qyM;

if dbg > 10
   validateattributes(qyS.mass_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      'size', [nIq, nyp]})
   validateattributes(qyS.fracEnter_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1,  'size', [nIq, nyp]})
end


%% Regression: college entry on [iq, yp] quartiles


if cS.dataS.regrIqYpWeighted
   wt_qyM = sqrt(qyS.mass_qyM);
else
   wt_qyM = [];
end

[qyS.betaIq, qyS.betaYp] = results_bc1.regress_qy(qyS.fracEnter_qyM, wt_qyM, cS.iqUbV(:), cS.ypUbV(:), dbg);
   
if dbg > 10
   validateattributes(qyS.betaIq, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end


end