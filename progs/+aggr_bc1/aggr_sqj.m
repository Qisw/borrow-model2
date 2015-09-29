function sqS = aggr_sqj(aggrS, hhS, paramS, cS)
% Aggregates:  By [school, IQ, j]
%{
Checked: 2015-Aug-25
%}

frac_qV = diff([0; cS.iqUbV]);
nIq = length(cS.iqUbV);

% Mass by [s q] = sum over all j in IQ class
sqS.mass_sqM = zeros([cS.nSchool, nIq]);
for iIq = 1 : nIq
   jIdxV = find(paramS.endowS.iqClass_jV == iIq);
   sqS.mass_sqM(:, iIq) = sum(aggrS.aggr_jS.mass_sjM(:, jIdxV), 2);
end

% % Mass by [s, iq, j]
% sizeV = [cS.nSchool, cS.nIQ, cS.nTypes];
% sqS.mass_sqjM = zeros(sizeV);
% 
% for j = 1 : cS.nTypes
%    for iSchool = 1 : cS.nSchool
%       for iIQ = 1 : cS.nIQ
%          % Mass(s,iq,j) = mass(s,j) * pr(iq|j)
%          %  because IQ is not correlated with anything other than j (not with decisions and grad
%          %  probs)
%          sqS.mass_sqjM(iSchool,iIQ,j) = aggrS.aggr_jS.mass_sjM(iSchool,j) * paramS.prIq_jM(iIQ,j);
%       end
%    end
% end

% Mass by [s, iq]
% sqS.mass_sqM = sum(sqS.mass_sqjM, 3);

% Fraction s | iq = mass(s,q) / mass(q)
sqS.fracS_iqM = nan([cS.nSchool, nIq]);
for i1 = 1 : nIq
   sqS.fracS_iqM(:,i1) = sqS.mass_sqM(:,i1) ./ sum(sqS.mass_sqM(:,i1));
end

sqS.massEnter_qV = sum(sqS.mass_sqM(cS.iCD : cS.nSchool, :), 1);
sqS.massEnter_qV = sqS.massEnter_qV(:);

sqS.massHsgPlus_qV = sum(sqS.mass_sqM(cS.iHSG : cS.nSchool, :), 1);
sqS.massHsgPlus_qV = sqS.massHsgPlus_qV(:);

% Fractions conditional on HSG
sqS.fracEnter_qV = sqS.massEnter_qV ./ sqS.massHsgPlus_qV;
sqS.fracGrad_qV  = sqS.mass_sqM(cS.iCG, :)' ./ sqS.massHsgPlus_qV;

   
%%  Means by [s,q]

% prJ_sqM = nan([cS.nTypes, cS.nSchool, nIq]);
% for j = 1 : cS.nTypes
%    % Pr(j | s,q) = Pr(s,q,j) / Pr(s,q)
%    %  Ratio of probs = ratio of masses (b/c total mass is the same)
%    prJ_sqM(j, :,:) = sqS.mass_sqjM(:,:, j) ./ max(1e-6, sqS.mass_sqM);
% end
% 
% validateattributes(prJ_sqM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
%    '<=', 1})
% prSumV = sum(prJ_sqM, 1);
% if any(abs(prSumV(:) - 1) > 1e-4)
%    error_bc1('Invalid', cS);
% end
% 
% 
% % ******  Compute means
% % Over first 2 years in college
% 
% sqS.zMean_sqM = nan([cS.nSchool, nIq]);
% sqS.consMean_sqM = nan([cS.nSchool, nIq]);
% sqS.earnMean_sqM = nan([cS.nSchool, nIq]);
% sqS.hoursMean_sqM = nan([cS.nSchool, nIq]);
% for iSchool = 1 : cS.nSchool
%    for iIq = 1 : nIq
%       pr_jV = prJ_sqM(:, iSchool, iIq);
%       pr_jV = pr_jV ./ sum(pr_jV);
%       sqS.zMean_sqM(iSchool, iIq) = sum(pr_jV .* hhS.v0S.zColl_jV);
%       sqS.consMean_sqM(iSchool, iIq) = sum(pr_jV .* aggrS.cons_tjM(1,:)');
%    end
% end
   

   
%% Self test   
if cS.dbg > 10
%    validateattributes(sqS.mass_sqjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%       '>=', 0, 'size', sizeV})
   validateattributes(sqS.mass_sqM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, 'size', [cS.nSchool, nIq]})
   validateattributes(sqS.fracS_iqM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nSchool, nIq], 'positive', '<', 1})
   % Mass(s,q) should sum to mass by iq
   sumV = sum(sqS.mass_sqM);
   if any(abs(sumV(:) ./ aggrS.totalMass - frac_qV) > 5e-3)    % why so imprecise? +++
      error('Invalid');
   end

%    % Another way of computing frac enter | IQ
%    %  Prob(enter | IQ) = sum over j  (Pr(J | IQ) * Pr(enter | j))
%    %  Not super accurate b/c pr(j | iq) is not (see param_derived)
%    mass_qV = sum(sqS.mass_sqM, 1);
%    fracEnter_qV = sqS.massEnter_qV ./ mass_qV(:);
%    fracEnter2_qV = nan(nIq, 1);
%    for iIq = 1 : nIq
%       fracEnter2_qV(iIq) = sum(paramS.prJ_iqM(:, iIq) .* hhS.v0S.probEnter_jV .* hhS.probHsg_jV);
%    end
%    check_lh.approx_equal(fracEnter2_qV, fracEnter_qV, 2e-3, []);
end

end