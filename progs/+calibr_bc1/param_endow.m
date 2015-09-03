function endowS = param_endow(paramS, cS)
% Endowment related derived parameters


%% Transfers received after start of work
% By age of work start

% Present value of transfers received after start of work as CD: transfer(j) * pvTransferFactor
ageMax = cS.ageLastTransfer;
% After ageLastTransfer: these are 0
endowS.pvTransferFactor_tV = zeros(ageMax + 2, 1);
for age = 1 : ageMax
   endowS.pvTransferFactor_tV(age) = (paramS.R ^ age)  .*  econ_lh.geo_sum(1 / paramS.R,  age,  cS.ageLastTransfer);
end



end