function aggr_sS = aggr_s(aggrS, paramS, cS)
% Aggregates by schooling

nSchool = cS.nSchool;

% E(IQ | s)
aggr_sS.iqMean_sV = zeros(nSchool, 1);

for iSchool = 1 : nSchool
   % Mass(j and s)
   mass_jV = aggrS.aggr_jS.mass_sjM(iSchool,:)';
   aggr_sS.iqMean_sV(iSchool) = sum(paramS.iq_jV .* mass_jV) ./ sum(mass_jV);
end

validateattributes(aggr_sS.iqMean_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nSchool, 1]})

end