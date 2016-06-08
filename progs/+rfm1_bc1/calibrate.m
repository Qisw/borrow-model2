function calibrate

cS = rfm1_bc1.Const;
doCal = 1;

% Random initial guesses
%  can load them later +++
rng(40);
paramS = rfm1_bc1.CalParams;
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

[~, outS] = cal_dev_nested(solnV);

var_save_bc1(outS, c0S.vRfmSolution, c0S);
var_save_bc1(paramS, c0S.vRfmParameters, c0S);


%% Nested deviation
   function [devOut, outS] = cal_dev_nested(guessV)
      if any(guessV < pvector.guessMin)  ||  any(guessV > pvector.guessMax)
         devOut = 1e6;
         outS = [];
      else
         paramS = pvector.guess_extract(guessV, paramS, doCal);
         % paramS = pvector.struct_update(paramS, doCal);
         [devOut, outS] = rfm1_bc1.cal_dev(paramS, tgS, cS);
      end
   end


end