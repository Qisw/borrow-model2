function earnS = param_earn_derived(tgS, paramS, cS)
% Derived params: lifetime earnings
%{
Discounted to work start
Data give us pv earn by [school, ability]
Assume that delaying by 1 year reduces lty by 1/R
%}

% Returns to ability by s
earnS.phi_sV = [paramS.phiHSG; paramS.phiHSG; paramS.phiHSG; paramS.phiCG];

% Initialize this to a meaningless default (changed later if used)
earnS.eHat_sV = zeros([cS.nSchool, 1]);
% Ability offset: to ensure that phi(s) * (a - aBar) >= 0
earnS.aBar = paramS.abilGrid_aV(1);


%% Main

% Do we copy pvEarn_asM from another experiment?
if isempty(cS.expS.earnExpNo)
   % Targets
   % Present values are discounted to work start
   earnS.tgPvEarn_sV = tgS.pvEarn_scM(:, cS.iCohort);

   % Present value by [ability, school]
   %  discounted to work start age
   if cS.abilAffectsEarnings == 0
      % Ability does not affect earnings
      pvEarn_saM = earnS.tgPvEarn_sV * ones(1, cS.nAbil);
   else
      earnS.eHat_sV = log(earnS.tgPvEarn_sV(cS.iHSG)) + paramS.eHatCD + ...
         [paramS.dEHatHSD; paramS.dEHatHSG; 0; paramS.dEHatCG];
      dAbilV = (paramS.abilGrid_aV - earnS.aBar);
      pvEarn_saM = nan([cS.nSchool, cS.nAbil]);
      for iSchool = 1 : cS.nSchool
         pvEarn_saM(iSchool,:) = ...
            exp(earnS.eHat_sV(iSchool) + dAbilV .* earnS.phi_sV(iSchool));
      end
   end
   
   % Add the time dimension
   tMax = max(cS.ageWorkStartM(:));
   earnS.pvEarn_tsaM = nan(tMax, cS.nSchool, cS.nAbil);
   for iSchool = 1 : cS.nSchool
      % Valid work start ages
      tV = cS.ageWorkStartM(iSchool,:);
      for t = tV
         earnS.pvEarn_tsaM(t,iSchool,:) = pvEarn_saM(iSchool,:) ./ (paramS.R .^ (t-tV(1)));
      end
   end

else
   % Copy from another experiment
   c2S = const_bc1(cS.setNo, cS.expS.earnExpNo);
   param2S = var_load_bc1(cS.vParams, c2S);
   earnS.tgPvEarn_sV = param2S.tgS.pvEarn_sV;
   earnS.pvEarn_tasM = param2S.pvEarn_tasM;
end


%% Output check
   
if cS.dbg > 10
   % Contains nans for invalid work start ages
   validateattributes(earnS.pvEarn_tsaM, {'double'}, {'nonempty', 'real', ...
      'positive', 'size', [tMax, cS.nSchool, cS.nAbil]})

   for iSchool = 1 : cS.nSchool
      tV = cS.ageWorkStartM(iSchool, 1, 1) : cS.ageWorkStartM(iSchool, 2);
      pvEarn_tsaM = earnS.pvEarn_tsaM(tV, iSchool, :);
      validateattributes(pvEarn_tsaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      
      diff_aV = diff(pvEarn_tsaM, 1, 3);
      if any(diff_aV(:) <= 0)
         error_bc1('pv earn must be increasing in ability', cS);
      end
      if length(tV) > 1
         if any(diff(pvEarn_tsaM, 1) >= 0)
            error_bc1('pv earn must be decreasing in t', cS);
         end
      end
   end
 
   
   % Check that log earnings gains from schooling are increasing in ability
   % For 1st work start age
   % Log gains by schooling
   diffM = diff(log(pvEarn_saM), 1, 1);
   % Change of those by ability
   diff2M = diff(diffM, 1, 2);
   if any(diff2M(:) < -1e-3)
      disp(log(pvEarn_saM));
      error_bc1('Earnings gains decreasing in ability', cS);
   end
end

end