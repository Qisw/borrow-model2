function vCollS = value_college(age, periodLength, kGridV, continValueFct_jV, paramS, cS)
% Value of starting a period in college, by j
%{
On capital grid

IN
   age
      age at which college is started
   periodLength
      student commits for this many periods
   kGridV
      may be singleton
   continValueFct_jV
      continuation value function(k')
%}


% Compute on k grid. 
nk = length(kGridV);
sizeV = [nk, cS.nTypes];
c_kjM = nan(sizeV);
hours_kjM = nan(sizeV);
kPrime_kjM = nan(sizeV);
value_kjM = nan(sizeV);
kMin = paramS.kMin_aV(age + periodLength);

wColl_jV = paramS.wColl_jV;
pColl_jV = paramS.pColl_jV;
transfer_jV = paramS.transfer_jV;


% Must repeat this loop. No other way of controlling parallel (for debugging)
if cS.runParallel
   parfor j = 1 : cS.nTypes
      [c_kjM(:,j), hours_kjM(:,j), kPrime_kjM(:,j), value_kjM(:,j)] = ...
         hh_bc1.coll_pd3(kGridV, wColl_jV(j), pColl_jV(j), transfer_jV(j), periodLength, kMin, ...
         continValueFct_jV{j}, j, paramS, cS);
   end
else
   for j = 1 : cS.nTypes
      [c_kjM(:,j), hours_kjM(:,j), kPrime_kjM(:,j), value_kjM(:,j)] = ...
         hh_bc1.coll_pd3(kGridV, wColl_jV(j), pColl_jV(j), transfer_jV(j), periodLength, kMin, ...
         continValueFct_jV{j}, j, paramS, cS);
   end   
end


vCollS.kGridV = kGridV;
vCollS.c_kjM = c_kjM;
vCollS.hours_kjM = hours_kjM;
vCollS.kPrime_kjM = kPrime_kjM;
vCollS.value_kjM = value_kjM;


%% Output check
if cS.dbg > 10
   if nk > 1
      if any(diff(vCollS.value_kjM, 1,1) <= 0)
         error_bc1('Not increasing in k', cS);
      end
   end
end


end