function vWorkS = value_work(paramS, cS)
% Value of working. Presolve and make continuous approximations
%{
Test:
   test_bc1.work

Checked: 2015-Aug-21
%}

dbg = cS.dbg;
nk = cS.workS.nk;
vWorkS.kGridV = linspace(min(paramS.kMin_aV), paramS.kMax, nk)';


%% Value after learning ability
%{
by [k, work start age, school, ability]
k includes present value of transfers received after work start
Only for college entrants
%}

tMax = max(cS.ageWorkStartM(:));
vWorkS.value_ktsaM = nan([nk, tMax, cS.nSchool, cS.nAbil]);
% Continuous approximation
vWorkS.valueFct_tsaM = cell([tMax, cS.nSchool, cS.nAbil]);

for iSchool = cS.iCD : cS.nSchool
   for tStart = cS.ageWorkStartM(iSchool, :)
      % Length of work life
      T = cS.ageRetire - tStart + 1;
      for iAbil = 1 : cS.nAbil
         vWorkS.value_ktsaM(:,tStart,iSchool,iAbil) = ...
            hh_bc1.hh_work_bc1(vWorkS.kGridV, paramS.earnS.pvEarn_tsaM(tStart,iSchool,iAbil), paramS.R, ...
            T, paramS.utilWorkS, dbg);
         
         vWorkS.valueFct_tsaM{tStart,iSchool,iAbil} = griddedInterpolant(vWorkS.kGridV, ...
            vWorkS.value_ktsaM(:,tStart,iSchool,iAbil),  'pchip', 'linear');
      end
   end
end

if dbg > 10
   validateattributes(vWorkS.value_ktsaM, {'double'}, {'nonempty', 'real', ...
      'size', [nk, tMax, cS.nSchool, cS.nAbil]})
end



%%  Value of working as HSG

vWorkS.valueHsg_jV = hh_bc1.value_hsg(paramS, cS);


%% Value of work as CG, after learning graduation shock
%{
Continuous approximation in k
   takes into account that hh also receives parental transfers
   k is literally just assets
Can start work at ages 5 or 6
%}

% E V(k | j,CG)
vWorkS.evWorkCG_tjM = cell([tMax, cS.nTypes]);
iSchool = cS.iCG;

for tStart = cS.ageWorkStartM(iSchool,:)   
   % Unless worker starts in last possible year, he gets transfers from parents
   pvTransfer_jV = paramS.transfer_jV .* paramS.endowS.pvTransferFactor_tV(tStart);
   
   for j = 1 : cS.nTypes   
      % Make value on a grid
      value_kV = nan([nk, 1]);
      for ik = 1 : nk
         vWork_aV = zeros([cS.nAbil, 1]);
         for iAbil = 1 : cS.nAbil
            vWork_aV(iAbil) = vWorkS.valueFct_tsaM{tStart,iSchool,iAbil}(vWorkS.kGridV(ik) + pvTransfer_jV(j));
         end
         % Use Pr(a | j, grad)
         value_kV(ik) = sum(paramS.prA_jgradM(:, j) .* vWork_aV(:));
      end
      
      if dbg > 10
         % Check that value function increases in k
         if any(diff(value_kV) <= 0)
            error_bc1('Invalid', cS);
         end
      end

      % Function approximation
      vWorkS.evWorkCG_tjM{tStart,j} = griddedInterpolant(vWorkS.kGridV, value_kV, ...
         'pchip', 'linear');
   end
end

end