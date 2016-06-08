function check_solution(setNo, expNo)
% Check computed equilibrium

cS = const_bc1(setNo, expNo);
paramS = param_load_bc1(setNo, expNo);
aggrS = var_load_bc1(cS.vAggregates, cS);
hhS = var_load_bc1(cS.vHhSolution, cS);

fp = 1;

fprintf(fp, '\nChecking equilibrium\n');


%% Are value functions monotonic?
% Mostly checked when value functions are computed

for iSchool = 1 : cS.nSchool
   for t = cS.ageWorkStartM(iSchool, :)
      value_kaM = squeeze(hhS.vWorkS.value_ktsaM(:, t, iSchool, :));
      if any_lh(diff(value_kaM, 1, 1) <= 0)  ||  any_lh(diff(value_kaM, 1, 2) <= 0)
         error_bc1('Value of working not increasing', cS);
      end
   end
end



%% How often is kMax reached?
% Is grid too narrow

fprintf(fp, '\nkMax is binding this often in each period: \n');
fprintf(fp, '  %i',  sum(aggrS.simS.k_tjM > paramS.kMax - 1e-6, 2));
fprintf(fp, '\n');
fprintf(fp, 'Highest k chosen:  %.0f    kMax: %.0f \n',  max(aggrS.simS.k_tjM(:)), paramS.kMax);






end