% Aggregates By j
function aggr_jS = aggr_j(aggrS, hhS, paramS, cS)
   
% Defines total mass
aggr_jS.mass_jV = paramS.prob_jV * aggrS.totalMass;

aggr_jS.mass_sjM = zeros([cS.nSchool, cS.nTypes]);

% HSD = mass * (1 - prob HSG)
aggr_jS.mass_sjM(cS.iHSD, :) = (1 - hhS.probHsg_jV) .* aggr_jS.mass_jV;

% HSG+ = mass - mass(HSD)
massHsPlus_jV = aggr_jS.mass_jV - aggr_jS.mass_sjM(cS.iHSD, :)';

% Mass in college by j
aggr_jS.massColl_jV = massHsPlus_jV .* hhS.v0S.probEnter_jV;

% HSG
aggr_jS.mass_sjM(cS.iHSG, :) = massHsPlus_jV - aggr_jS.massColl_jV;

% Prob college grad conditional on entry = sum of Pr(a|j) * Pr(grad|a)
prGrad_jV = nan([cS.nTypes, 1]);
for j = 1 : cS.nTypes
   prGrad_jV(j) = sum(paramS.prob_a_jM(:,j) .* paramS.prGrad_aV);
end

% Mass of college grads by j
aggr_jS.mass_sjM(cS.iCG, :) = aggr_jS.massColl_jV .* prGrad_jV;

aggr_jS.mass_sjM(cS.iCD, :) = aggr_jS.massColl_jV - aggr_jS.mass_sjM(cS.iCG, :)';


% Prob s | j = Prob(s and j) / (prob j)
aggr_jS.probS_jM = aggr_jS.mass_sjM ./ (ones([cS.nSchool,1]) * aggr_jS.mass_jV(:)');


%% Assign [q,y] classes for universe HSG

% Parental income classes
aggr_jS.ypClassHsg_jV = distrib_lh.class_assign(paramS.yParent_jV, massHsPlus_jV, cS.ypUbV, cS.dbg);

% IQ classes
aggr_jS.iqClassHsg_jV = distrib_lh.class_assign(paramS.endowS.iq_jV, massHsPlus_jV, cS.iqUbV, cS.dbg);



%% Output check
if cS.dbg > 10
   validateattributes(aggr_jS.mass_sjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', aggrS.totalMass, 'size', [cS.nSchool, cS.nTypes]})
   validateattributes(aggr_jS.ypClassHsg_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      'positive', '<=', length(cS.ypUbV)})
   validateattributes(aggr_jS.iqClassHsg_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      'positive', '<=', length(cS.iqUbV)})
end


end
