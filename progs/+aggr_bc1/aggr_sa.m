% Aggregates By [school, abil]
function mass_saM = aggr_sa(aggrS, paramS, cS)

mass_saM = nan([cS.nSchool, cS.nAbil]);

% This works because prob of HSG depends on j, not on a
% HSD: Mass(HSD,j) * Pr(a | j)
% HSG: Mass(HSG,j) * Pr(a | j)
for iAbil = 1 : cS.nAbil
   mass_saM(cS.iHSD, iAbil) = aggrS.aggr_jS.mass_sjM(cS.iHSD, :) * paramS.prob_a_jM(iAbil, :)';
   mass_saM(cS.iHSG, iAbil) = aggrS.aggr_jS.mass_sjM(cS.iHSG, :) * paramS.prob_a_jM(iAbil, :)';
end


% ******  College: 

massColl_jV = sum(aggrS.aggr_jS.mass_sjM(cS.iCD : cS.nSchool, :));
for iAbil = 1 : cS.nAbil
   % Mass college with this a
   massColl = paramS.prob_a_jM(iAbil,:) * massColl_jV(:);
   %  CG: mass(college,a) * pr(grad|a)
   mass_saM(cS.iCG, iAbil) = paramS.prGrad_aV(iAbil) * massColl;
   mass_saM(cS.iCD, iAbil) = (1 - paramS.prGrad_aV(iAbil)) * massColl;
end


%% Output check
if cS.dbg > 10
   validateattributes(mass_saM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, 'size', [cS.nSchool, cS.nAbil]})
   mass_aV = sum(mass_saM, 1);
   if any(abs(mass_aV(:) ./ (aggrS.totalMass .* paramS.prob_aV) - 1) > 1e-4)
      error_bc1('Invalid sum', cS);
   end
end


end

