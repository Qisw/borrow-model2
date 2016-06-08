function [cons_jV, hours_jV, kPrime_jV] = sim_college(v1S, k_jV, periodLength, paramS, cS)
% Simulate paths in college
%{
One period of decisions, covers ages in tV
Initial assets are k_jV

Cases
1. v1S contains value function on grid for interpolation
2. v1S contains value function for only 1 k point
%}

dbg = cS.dbg;
nTypes = cS.nTypes;

%% Input check
if dbg > 10
   validateattributes(k_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nTypes, 1]})
end


%% Simulation

kPrime_jV = zeros(nTypes, 1);
hours_jV = zeros(nTypes, 1);
cons_jV  = zeros(nTypes, 1);

for j = 1 : nTypes
   % Current k
   k = k_jV(j);
   if length(v1S.kGridV) > 1
      kPrime_jV(j) = interp1(v1S.kGridV, v1S.kPrime_kjM(:,j), k, 'linear', 'extrap');
      % Hours and consumption: constant in both periods
      hours_jV(j) = interp1(v1S.kGridV, v1S.hours_kjM(:,j), k, 'linear', 'extrap');
      cons_jV(j) = interp1(v1S.kGridV, v1S.c_kjM(:,j), k, 'linear', 'extrap');
   elseif length(v1S.kGridV) == 1
      if abs(v1S.kGridV - k) > 1e-8
         error_bc1('Invalid', cS);
      end
      kPrime_jV(j) = v1S.kPrime_kjM(1,j);
      hours_jV(j)  = v1S.hours_kjM(1,j);
      cons_jV(j)   = v1S.c_kjM(1,j);
   else
      error('Invalid');
   end
   
   if dbg > 10
      % Check that b.c. holds
      kp2 = hh_bc1.coll_bc_kprime(cons_jV(j), hours_jV(j), k, ...
         paramS.wColl_jV(j), paramS.pColl_jV(j), paramS.transfer_jV(j), paramS.R, periodLength, cS);
      if abs(kp2 - kPrime_jV(j)) > 1e-3
         error_bc1('bc violated', cS);
      end
   end
end


%% Output check
if dbg > 10
   sizeV = [cS.nTypes, 1];
   validateattributes(kPrime_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', sizeV})
   validateattributes(cons_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', sizeV})
   validateattributes(hours_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0,  'size', sizeV})
end

end