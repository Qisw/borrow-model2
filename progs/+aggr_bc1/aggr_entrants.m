function entrantYear2S = aggr_entrants(aggrS, cS)
% Aggregates for college entrants / all


% Mean debt at end of college
% debtS.debtMeanEndOfCollege = sum(debtEndOfCollegeS.mean_qV .* mass_qV(:));


%%  Stats over first 2 years in college

% Fraction of entrants by q
fracColl_qV = aggrS.sqS.massEnter_qV;
fracColl_qV = fracColl_qV(:) ./ sum(fracColl_qV(:));

entrantYear2S.consCollMean = sum(aggrS.iqYear2S.consCollMean_qV .* fracColl_qV(:));
entrantYear2S.earnCollMean = sum(aggrS.iqYear2S.earnCollMean_qV .* fracColl_qV(:));
entrantYear2S.transferMean = sum(aggrS.iqYear2S.transferMean_qV .* fracColl_qV(:));
entrantYear2S.hoursCollMean = sum(aggrS.iqYear2S.hoursCollMean_qV .* fracColl_qV(:));
[entrantYear2S.pStd, entrantYear2S.pMean] = stats_lh.std_w(aggrS.iqYear2S.pMean_qV, fracColl_qV(:), cS.dbg);

entrantYear2S.debtMean = sum(aggrS.iqYear2S.debtMean_qV .* fracColl_qV);
entrantYear2S.debtFrac = sum(aggrS.iqYear2S.debtFrac_qV .* fracColl_qV);

% Check
debtMeanYear2 = sum(aggrS.aggr_jS.massColl_jV .* aggrS.simS.debt_tjM(3,:)') ./ sum(aggrS.aggr_jS.massColl_jV);
if abs(debtMeanYear2 - entrantYear2S.debtMean) > 1e-2
   error_bc1('Invalid debt year 2', cS);
end


% ****** Financing shares

% Spending per year (average)
spending = entrantYear2S.consCollMean + entrantYear2S.pMean;
% Fraction paid with earnings
entrantYear2S.fracEarnings = entrantYear2S.earnCollMean / spending;
% Fraction paid with debt
entrantYear2S.fracDebt = entrantYear2S.debtMean / spending;
% Fraction paid with transfers
entrantYear2S.fracTransfers = entrantYear2S.transferMean / spending;


% 
% 
% % Mean debt of all college students
% %  not conditional on having debt
% %  we observe all entrants at t=1-2 and graduates in 3-4
% debtAllS.mean = mean_coll_all(debt_tjM, aggrS.mass_sjM, cS);
% % debtAllS.mean = sum(aggrS.massColl_jV' .* debt_tjM(1,:) + aggrS.mass_sjM(cS.iCG, :) .* debt_tjM(2,:)) ...
% %    ./ sum(aggrS.massColl_jV + aggrS.mass_sjM(cS.iCG, :)');
% 
% % Consumption, average over college entrants, all years
% aggrS.consCollMean = mean_coll_all(aggrS.cons_tjM, aggrS.mass_sjM, cS);
% aggrS.earnCollMean = mean_coll_all(aggrS.earn_tjM, aggrS.mass_sjM, cS);
% aggrS.pMean = mean_coll_all(ones([2,1]) * paramS.pColl_jV',  aggrS.mass_sjM, cS);
% aggrS.zMean = mean_coll_all(ones([2,1]) * hhS.v0S.zColl_jV',  aggrS.mass_sjM, cS);
% 


% %% Compute average across all college students
% %{
% IN
%    x_tjM
%       any variable by year in college (1-2, 3-4) and j
%    mass_sjM
% OUT
%    Mean of x over all college students
% %}
% function meanOut = mean_coll_all(x_tjM, mass_sjM, cS)
%    massColl_jV = sum(mass_sjM(cS.iCD : cS.nSchool, :), 1);
%    massCG_jV = mass_sjM(cS.iCG,:);
%    meanOut = sum(massColl_jV(:) .* x_tjM(1,:)' + massCG_jV(:) .* x_tjM(2,:)') ...
%       ./ sum(massColl_jV(:) + massCG_jV(:));   
% end

end