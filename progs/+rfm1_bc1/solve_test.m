function solve_test(outS, frac_sV, paramS, cS)
% Test after solving model

% Fraction schooling attained?
cnt_sV = accumarray(outS.sClassV, 1);
checkLH.approx_equal(cnt_sV(:) ./ sum(cnt_sV),  frac_sV, 1e-3, []);

checkLH.prob_check(outS.frac_sqM(:), 1e-4);
checkLH.prob_check(outS.frac_syM(:), 1e-4);

% Perfect sorting by E(a)
eaMinV = zeros(cS.nSchool, 1);
eaMaxV = zeros(cS.nSchool, 1);
for iSchool = 1 : cS.nSchool
   eaMinV(iSchool) = min(outS.eaV(outS.sClassV == iSchool));
   eaMaxV(iSchool) = max(outS.eaV(outS.sClassV == iSchool));
end
assert(all(eaMinV(2 : cS.nSchool) > eaMaxV(1 : (cS.nSchool - 1))));


% Compute fraction HSG+ | q the long way
nq = length(cS.qClUbV);
for iq = 1 : nq
   mass_sV = outS.frac_sqM(:, iq);
   checkLH.approx_equal(sum(mass_sV(cS.iHSG : end)) ./ sum(mass_sV),  outS.fracHsg_qV(iq), 1e-5, []);
end

end