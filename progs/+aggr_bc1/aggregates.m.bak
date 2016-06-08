function aggrS = aggregates(hhS, paramS, cS)
% Compute aggregates
%{

Checked: 2015-Apr-3
%}


dbg = cS.dbg;
nIq = length(cS.iqUbV);
% Scale factor
aggrS.totalMass = 100;

% % Holds debt stats
% debtS.setNo = cS.setNo;
% % Debt stats: all college students
% debtAllS.setNo = cS.setNo;
% % Debt stats: end of college
% debtEndOfCollegeS.setNo = cS.setNo;


%%  Compute aggregates
% Consistency checks are done when everything has been computed
% To make independent of sequence of computations

% By j
aggrS.aggr_jS = aggr_bc1.aggr_j(aggrS, hhS, paramS, cS);

% By [s,a]
aggrS.mass_saM = aggr_bc1.aggr_sa(aggrS, paramS, cS);

% Simulate histories in college, by t,j
aggrS.simS = aggr_bc1.sim_histories(hhS, paramS, cS);

% By [school, IQ]
aggrS.sqS = aggr_bc1.aggr_sqj(aggrS, hhS, paramS, cS);

% By IQ quartile
[aggrS.iqS, aggrS.iqYear2S, aggrS.iqYear4S, aggrS.iqGradS] = aggr_bc1.aggr_iq(aggrS, paramS, cS);

% Aggregates (college entrants)
aggrS.entrantYear2S = aggr_bc1.aggr_entrants(aggrS, cS);

% By [parental income class]
[aggrS.ypS, aggrS.ypYear2S, aggrS.ypYear4S, aggrS.ypGradS] = aggr_bc1.aggr_yp(aggrS, paramS, cS);

% By [s, y]
aggrS.syS = aggr_bc1.aggr_syj(aggrS, hhS, paramS, cS);

% By [IQ, yp]
% Universe used to assign [q,y] quartiles: all
[aggrS.qyS, aggrS.qyYear2S, aggrS.qyYear4S] = aggr_bc1.aggr_qy('all', aggrS, paramS, cS);
% Universe to assign quartiles: high school graduates
aggrS.qyUniverseHsgS = aggr_bc1.aggr_qy('hsg', aggrS, paramS, cS);


%% By school

aggrS.mass_sV = sum(aggrS.aggr_jS.mass_sjM, 2);
aggrS.mass_sV = aggrS.mass_sV(:);

aggrS.frac_sV = aggrS.mass_sV ./ sum(aggrS.mass_sV);


% *******  Mean log lifetime earnings, discounted to work start

aggrS.pvEarnMeanLog_sV = nan([cS.nSchool, 1]);

for iSchool = 1 : cS.nSchool
   mass_aV = aggrS.mass_saM(iSchool,:)';
   % Possible work start ages
   tStartV = cS.ageWorkStartM(iSchool, :);
   
   if tStartV(2) == tStartV(1)
      % All start at same age
      logLty_aV = log(paramS.earnS.pvEarn_tsaM(tStartV(1), iSchool, :));
      aggrS.pvEarnMeanLog_sV(iSchool) = sum(mass_aV .* logLty_aV(:)) ./ sum(mass_aV);
      
   elseif iSchool == cS.iCG
      % currently only CG have 2 work start dates
      % Prob of graduating in 4 years is just a number
      mass_taM = [paramS.probGradFour; 1 - paramS.probGradFour] * mass_aV(:)';
      logLty_taM = squeeze(log(paramS.earnS.pvEarn_tsaM(tStartV, iSchool, :)));
      aggrS.pvEarnMeanLog_sV(iSchool) = sum(mass_taM(:) .* logLty_taM(:)) ./ sum(mass_taM(:));
   else
      error('Invalid');
   end
end

if dbg > 10
   validateattributes(aggrS.pvEarnMeanLog_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nSchool, 1]})
end


%% By graduation status
   % 
   %    % *****  Debt at end of college
   %    % indexed by [dropout, graduate]
   % 
   %    % Fraction in debt
   %    debtEndOfCollegeS.frac_sV = zeros([2,1]);
   %    % Mean debt (not conditional on being in debt)
   %    debtEndOfCollegeS.mean_sV = zeros([2,1]);
   % 
   %    for i1 = 1 : 2
   %       if i1 == 1
   %          % Dropouts
   %          massColl_jV = aggrS.mass_sjM(cS.iCD, :);
   %          t = 2;
   %       elseif i1 == 2
   %          % Graduates
   %          massColl_jV = aggrS.mass_sjM(cS.iCG, :);
   %          t = 3;
   %       end
   % 
   %       % Mass of this school type by j
   %       massColl_jV = massColl_jV ./ sum(massColl_jV);
   %       % Assets at end of college by j
   %       k_jV = aggrS.k_tjM(t, :);
   % 
   %       % Find those types that are in debt
   %       dIdxV = find(k_jV < 0);
   %       if ~isempty(dIdxV)
   %          debtEndOfCollegeS.frac_sV(i1) = sum(massColl_jV(dIdxV));
   %          % Mean debt, not conditional on being in debt (b/c mass does not sum to 1)
   %          debtEndOfCollegeS.mean_sV(i1) = -sum(massColl_jV(dIdxV) .* k_jV(dIdxV));
   %       end
   %    end
   %    clear massColl_jV;
   % 
   %    % Avoid rounding errors
   %    debtEndOfCollegeS.frac_sV = min(1, debtEndOfCollegeS.frac_sV);
   % 
   %    if dbg > 10
   %       validateattributes(debtEndOfCollegeS.frac_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   %          '>=', 0, '<=', 1})
   %       validateattributes(debtEndOfCollegeS.mean_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   %          '>=', 0})
   %    end






%% Clean up

if cS.dbg > 10
   % Consistency checks
   aggr_bc1.aggr_check(aggrS, cS);
end


end

