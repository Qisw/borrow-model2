function calibrate
% Run calibration
%{
No testing required. It just runs minimizer on cal_dev
%}

cS = rfm1_bc1.Const;
doCal = 1;

% Random initial guesses
paramS = rfm1_bc1.CalParams;
%rng(40);
paramS.initialize_random;
pvector = paramS.pvector;
guessV = pvector.guess_make(paramS, doCal);

% Calibration targets
c0S = const_bc1(cS.setNo, cS.expNo);
tgS = var_load_bc1(c0S.vCalTargets, c0S);

% Check guess extraction
if true
   devOut = rfm1_bc1.cal_dev(paramS, tgS, cS);
   devOut2 = cal_dev_nested(guessV);
   checkLH.approx_equal(devOut, devOut2, 1e-6, []);
end


%% Optimization

optS = optimset('fminsearch');
optS.TolFun = 1e-5;
optS.TolX = 1e-3;
[solnV, fVal, exitFlag] = fminsearch(@cal_dev_nested, guessV, optS);

if exitFlag <= 0
   warning('No convergence');
end

fprintf('Calibration done with terminal value %.3g \n',  fVal);


%% Save

[~, outS, outEarlyS] = cal_dev_nested(solnV);
saveS = rfm1_bc1.CalResults(outS, outEarlyS);

var_save_bc1(saveS, c0S.vRfmSolution, c0S);
var_save_bc1(paramS, c0S.vRfmParameters, c0S);


%% Nested deviation
   function [devOut, outS, outEarlyS] = cal_dev_nested(guessV)
      if any(guessV < pvector.guessMin)  ||  any(guessV > pvector.guessMax)
         % Invalid guess
         devOut = 1e6;
         outS = [];
         outEarlyS = [];
         
      else
         if randomLH.rand_time < 0.1
            cS.dbg = 111;
         else
            cS.dbg = 0;
         end
         paramS = pvector.guess_extract(guessV, paramS, doCal);
         % paramS = pvector.struct_update(paramS, doCal);
         [devOut, outS, outEarlyS] = rfm1_bc1.cal_dev(paramS, tgS, cS);
      end
   end


end