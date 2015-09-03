function aggr_check(aggrS, cS)
% Consistency checks

% move all consistency checks here +++++

%% By [q,y]



%% By y

% Mass of entrants by y
mass_yV = aggrS.ypS.massEnter_yV;
mass_yV = mass_yV(:) ./ sum(mass_yV);

earnCollMean = sum(aggrS.ypYear2S.earnCollMean_yV .* mass_yV);
check_lh.approx_equal(earnCollMean, aggrS.entrantYear2S.earnCollMean, 1e-3, []);

transferMean = sum(aggrS.ypYear2S.transferMean_yV .* mass_yV);
check_lh.approx_equal(transferMean, aggrS.entrantYear2S.transferMean, 1e-3, []);

hoursCollMean = sum(aggrS.ypYear2S.hoursCollMean_yV .* mass_yV);
check_lh.approx_equal(hoursCollMean, aggrS.entrantYear2S.hoursCollMean, 1e-3, []);

pMean = sum(aggrS.ypYear2S.pMean_yV .* mass_yV);
check_lh.approx_equal(pMean, aggrS.entrantYear2S.pMean, 1e-3, []);




end