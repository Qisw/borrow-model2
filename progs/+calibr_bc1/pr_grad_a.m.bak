function prGradV = pr_grad_a(abilIdxV, paramS, cS)
% Prob of graduating | a
%{
Generalized logistic
%}
% -------------------------------------

pr0 = paramS.prGradMin;
pr1 = paramS.prGradMax;

prGradV = pr0 + (pr1 - pr0) ./ ...
   (1 + paramS.prGradMult ./ exp(paramS.prGradExp .* (paramS.abilGrid_aV(abilIdxV) - paramS.prGradABase))) ...
   .^ (1 / paramS.prGradPower);


%% Output check

check_lh.prob_check(prGradV, []);


end