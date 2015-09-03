function [utilLifetimeV, c_ktM] = hh_work_bc1(kV, pvEarnV, R, T, utilWorkS, dbg)
% Household: work phase
%{
IN
   kV
      initial assets
      includes present value of transfers received after work start
   pvEarnV
      present value of earnings, discounted to work start
      may be scalar
   R
   T
      length of work life
   utilWorkS :: UtilCrraLH
      utility function at work
OUT
   c_ktM
      consumption by age (during work phase)
   utilLifetimeV
      utility = present value of u(c)

Checked: 2015-Aug-21
%}

%% Input check

nk = length(kV);
if dbg > 10
   validateattributes(kV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nk, 1]})
   validateattributes(T, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>=', 1})
end


%% Main

% Consumption at age 1 that is consistent with lifetime income
c1V = utilWorkS.age1_cons(R * kV  +  pvEarnV, R, T, dbg);

% Age consumption paths for each k
cGrowth = 1 + utilWorkS.c_growth(R, dbg);
c_ktM = c1V(:) * (cGrowth .^ (0 : (T-1)));


% Lifetime utility
utilLifetimeV = utilWorkS.lifetime_util_c1(c1V, R, T, dbg);



%% Self test
if dbg > 10
   % Present value budget constraint
   % Expand potentially scalar pvEarnV
   pvEarn2V = pvEarnV .* ones([nk, 1]);
   for ik = 1 : nk
      pvC = prvalue_bc1(c_ktM(ik,:), R);
      if abs((R * kV(ik) + pvEarn2V(ik)) - pvC) > 1e-4
         error_bc1('Invalid budget constraint', cS);
      end
   end
   
   validateattributes(utilLifetimeV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nk, 1]})
end


end