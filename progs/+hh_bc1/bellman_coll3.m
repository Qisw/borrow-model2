function rhsV = bellman_coll3(j, cV, hoursV, kV, hhS, paramS, cS)
% Direct implementation of Bellman equation in college, periods 3-4
%{
Returns RHS of Bellman, for all k grid points
For testing
%}

% kPrimeV = hhS.vColl3S.kPrime_kajM(:,iAbil,j);

periodLength = 2;

kPrimeV = hh_bc1.coll_bc_kprime(cV, hoursV, kV, paramS.wColl_jV(j), paramS.pColl_jV(j), paramS.transfer_jV(j), ...
   paramS.R, periodLength, cS);

% u in college today
utilCollV = hh_bc1.hh_util_coll_bc1(cV,  1 - hoursV,   paramS.cColl_jV(j), paramS.lColl_jV(j),  ...
   paramS.prefWt, paramS.prefSigma,  paramS.prefWtLeisure, paramS.prefRho);

% Value of working as CG
% vWorkFct = hhS.vWorkS.vFct_saM{cS.iCG, iAbil};
% vWorkFct = hhS.vWorkS.evWorkCG_jV{j};


rhsV = (1 + paramS.prefBeta * (periodLength-1)) .* utilCollV + ...
   (paramS.prefBeta .^ periodLength) .* hhS.vStart5S.value_jV{j}(kPrimeV);


end