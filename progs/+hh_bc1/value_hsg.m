function valueHsg_jV = value_hsg(paramS, cS)
% Value of working as HSG
%{
Beliefs are unconditional Prob(a | j)
Includes mean pref for working as HSG
We only need to evaluate this for 1 k value for each j (the endowment + transfers)
%}

dbg = cS.dbg;
if any(abs(paramS.k_jV - paramS.k_jV(1)) > 1e-6)
   error('Assuming only 1 k per type');
end

valueHsg_jV = nan([cS.nTypes, 1]);

iSchool = cS.iHSG;
tStart = cS.ageWorkStartM(iSchool, 1);
% Length of work life
T = cS.ageRetire - tStart + 1;

for j = 1 : cS.nTypes
   % Endowment: k  +  present value of transfers
   k1 = paramS.k_jV(j)  +  paramS.transfer_jV(j) * paramS.endowS.pvTransferFactor_tV(tStart);
   
   % Value of working by ability
   vWork_aV = zeros(cS.nAbil, 1);
   for iAbil = 1 : cS.nAbil
      vWork_aV(iAbil) = hh_bc1.hh_work_bc1(k1, paramS.earnS.pvEarn_tsaM(tStart,iSchool,iAbil), paramS.R, ...
         T, paramS.utilWorkS, dbg);
   end
   
   valueHsg_jV(j) = sum(paramS.prob_a_jM(:, j) .* vWork_aV(:))  +  paramS.prefHS_jV(j);
end

if cS.dbg > 10
   validateattributes(valueHsg_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nTypes, 1]})
end

end