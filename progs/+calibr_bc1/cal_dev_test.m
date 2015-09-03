function cal_dev_test(setNo)
% Takes a long time

disp('Testing cal_dev');

cS = const_bc1(setNo);
expNo = cS.expNo;

% Load param guesses. Impose exogenous params. Copy params from baseline if needed
paramS = param_load_bc1(setNo, expNo);
tgS = var_load_bc1(cS.vCalTargets, cS);
% This determines which params are calibrated
doCalV = cS.doCalV;

% Objective with baseline parameters
dev0 = calibr_bc1.cal_dev(tgS, paramS, cS);


% Make guesses from param vector
guessV = cS.pvector.guess_make(paramS, doCalV);
fprintf('  %i calibrated parameters \n', length(guessV));

% List of calibrated parameters
[~, pNameV] = cS.pvector.calibrated_values(paramS, doCalV);


%% Make sure that each guess affects the objective function
if 01
   fprintf('\nChecking that all guesses affect objective\n');
   dGuess = 0.1;
   devV = zeros(size(guessV));
   for i1 = 1 : length(guessV)
      fprintf('\nChanging parameter %i: %s  \n',  i1,  pNameV{i1});
      
      guess2V = guessV;
      if guessV(i1) < cS.guessUb - dGuess
         guess2V(i1) = guessV(i1) + dGuess;
      else
         guess2V(i1) = guessV(i1) - dGuess;
      end
      
      param2S = cS.pvector.guess_extract(guess2V, paramS, doCalV);
      param2S = param_derived_bc1(param2S, cS);
      
      devV(i1) = calibr_bc1.cal_dev(tgS, param2S, cS);
      fprintf('  Change in dev for guess %i: %.4f \n',  i1, devV(i1) - dev0);
      if abs(devV(i1) - dev0) < 1e-3
         fprintf('Parameter %i: %s  \n',  i1, pNameV{i1});
         struct_lh.compare(paramS, param2S, cS.dbg);
         error_bc1('Small change', cS);
      end
   end
end


end