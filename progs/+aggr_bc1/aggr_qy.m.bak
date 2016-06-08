function [qyS, qyYear2S, qyYear4S] = aggr_qy(universeStr, aggrS, paramS, cS)
% Aggregates by [IQ, yp] quartile
%{
IN:
   universeStr
      which universe to use for assigning [q,y] quartiles?
      'all'
      'hsg'

Checked: 2015-Sep-16
%}

dbg = cS.dbg;
nIq = length(cS.iqUbV);
nyp = length(cS.ypUbV);

if strcmpi(universeStr, 'all')
   ypClass_jV = paramS.endowS.ypClass_jV;
   iqClass_jV = paramS.endowS.iqClass_jV;
elseif strcmpi(universeStr, 'hsg')
   ypClass_jV = aggrS.aggr_jS.ypClassHsg_jV;
   iqClass_jV = aggrS.aggr_jS.iqClassHsg_jV;
else
   error('Invalid');
end


%% Allocate output matrices

% First 2 years in college
qyYear2S.zMean_qyM = zeros([nIq, nyp]);
qyYear2S.consMean_qyM = zeros([nIq, nyp]);
qyYear2S.earnMean_qyM = zeros([nIq, nyp]);
qyYear2S.debtMean_qyM = zeros([nIq, nyp]);
qyYear2S.pMean_qyM = zeros([nIq, nyp]);

% Years 3-4 in college
qyYear4S.debtMean_qyM = zeros([nIq, nyp]);


% ******  All

qyS.mass_sqyM = zeros([cS.nSchool, nIq, nyp]);
qyS.mass_qyM = zeros([nIq, nyp]);
%  Mass in college
qyS.massColl_qyM = zeros([nIq, nyp]);
%  Mass HSG or more
qyS.massHsgPlus_qyM = zeros([nIq, nyp]);



%% Main loop

for iy = 1 : nyp
   for iIq = 1 : nIq
      % j in this class
      jIdxV = find((ypClass_jV == iy)  &  (iqClass_jV == iIq));
      if ~isempty(jIdxV)
   
         % ********  All

%          % Mass by [s,j] for j in yp group
%          mass_sjM = aggrS.aggr_jS.mass_sjM(:, jIdxV);
         mass_sV  = sum(aggrS.aggr_jS.mass_sjM(:, jIdxV), 2);
         
         qyS.mass_sqyM(:, iIq, iy) = mass_sV;

%          for iSchool = 1 : cS.nSchool
%             % Mass(s,q,y) = sum over j in yp group: Pr(iq|j) * mass(j)
%             qyS.mass_sqyM(iSchool,:,iy) = sum(paramS.prIq_jM(:,jIdxV) .* (ones(nIq,1) * mass_sjM(iSchool,:)), 2);
%          end

         qyS.mass_qyM(iIq, iy) = sum(mass_sV);

         % Mass in college by [iq, j] for the right yp group
         qyS.massColl_qyM(iIq, iy) = sum(mass_sV(cS.iCD : cS.nSchool));
         qyS.massHsgPlus_qyM(iIq, iy) = sum(mass_sV(cS.iHSG : cS.nSchool));
         
         if qyS.massColl_qyM(iIq, iy) > 0
%             % Frac entering / graduating out of HSG
%             qyS.fracEnter_qyM(iIq, iy) = qyS.massColl_qyM(iIq, iy) ./ qyS.massHsgPlus_qyM(iIq, iy);
%             qyS.fracGrad_qyM(iIq, iy)  = mass_sV(cS.iCG) ./ qyS.massHsgPlus_qyM(iIq, iy);


            % ****  Years 1-2 in college
            % E(x | q,y) = sum over j in y class:  Prob(j | q) * x(j)
   %          probV = prJ_qM(jIdxV, iIq);
   %          probV = probV ./ sum(probV);
            % Mass of entrants by j
            probV = aggrS.aggr_jS.massColl_jV(jIdxV);
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
   end
end


% Fraction college out of HSG
% massHsgPlus_qyM = squeeze(sum(qyS.mass_sqyM(cS.iHSG : cS.nSchool, :, :), 1));
qyS.fracEnter_qyM = qyS.massColl_qyM ./ max(1e-8, qyS.massHsgPlus_qyM);
qyS.fracGrad_qyM = squeeze(qyS.mass_sqyM(cS.iCG, :,:)) ./ max(1e-8, qyS.massHsgPlus_qyM);


%% Output check
if dbg > 10
   validateattributes(qyS.mass_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      'size', [nIq, nyp]})
   validateattributes(qyS.fracEnter_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<', 1.001,  'size', [nIq, nyp]})
   validateattributes(qyS.fracGrad_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<', 1.001,  'size', [nIq, nyp]})
end

qyS.fracEnter_qyM = min(1, qyS.fracEnter_qyM);
qyS.fracGrad_qyM  = min(1, qyS.fracGrad_qyM);


%% Regression: college entry on [iq, yp] quartiles


if cS.dataS.regrIqYpWeighted
   % Universe: all
   wt_qyM = sqrt(qyS.mass_qyM);
else
   wt_qyM = [];
end

[qyS.betaIq, qyS.betaYp] = results_bc1.regress_qy(qyS.fracEnter_qyM, wt_qyM, cS.iqUbV(:), cS.ypUbV(:), dbg);
   
if dbg > 10
   validateattributes(qyS.betaIq, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   validateattributes(qyS.betaYp, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end


end