function vmS = coll_value_m(vColl3S, vWorkS, paramS, cS)
% Value of college at end of periods 1-2, before ability is learned

% Use same grid as value3 for efficiency (this is assumed below)
kGridV = vColl3S.kGridV;
nk = length(kGridV);
vmS.value_kjM = nan([nk, cS.nTypes]);
vmS.valueFct_jV = cell([cS.nTypes, 1]);

% Present value of transfers received after start of work as CD: transfer(j) * pvTransferFactor
age = cS.ageWorkStartM(cS.iCD, 1);
pvTransferFactor = paramS.endowS.pvTransferFactor_tV(age);

% By ability: prob of graduating
probGrad_aV = paramS.prGrad_aV;
probDrop_aV = 1 - probGrad_aV;


%% Loop over types

for j = 1 : cS.nTypes
   % Pr(a | j)
   prob_aV = paramS.prob_a_jM(:,j);
   % Present value of transfers
   pvTransfer = paramS.transfer_jV(j) * pvTransferFactor;
   
   % Loop over assets
   for ik = 1 : nk
      % Value of working as CD
      vCD_aV = zeros(cS.nAbil, 1);
      for iAbil = 1 : cS.nAbil
         vCD_aV(iAbil) = vWorkS.valueFct_tsaM{age, cS.iCD, iAbil}(kGridV(ik) + pvTransfer);
      end
      
      % Value at end of period 2
      % This assumes that the asset grid is the same as for college period 3
      vmS.value_kjM(ik, j) = sum(prob_aV .* (probDrop_aV .* vCD_aV  +  ...
         probGrad_aV .* vColl3S.value_kjM(ik,j)));
   end
   
   % Continuous approx of V_m(k', j) (continuation value)
   vmS.valueFct_jV{j} = griddedInterpolant(kGridV, vmS.value_kjM(:,j), 'pchip', 'linear');
end


vmS.kGridV = kGridV;


%% Output check
if cS.dbg > 10
   validateattributes(vmS.value_kjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nk, cS.nTypes]})
   if any(diff(vmS.value_kjM, 1,1) <= 0)
      error_bc1('Not increasing in k', cS);
   end
end

end