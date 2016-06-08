function param_set(setNo, expNo)
% Set params from output by cal_dev
%{
Used when saving guesses does not work
%}

disp(' ');
disp('Writing new params to file');

% The output produced by cal_dev
% Matlab cannot do a single long string, so we concatenate
outputStr = ['prefWtWork:  9.927       prefWtLeisure:  0.122    prefHS:  23.960 ', ...
'logZMean:  1.545    logZStd:  0.437     alphaZY:  2.156     alphaMY:  0.723 ', ...
'alphaMZ:  0.267     alphaQY:  0.580     alphaQZ:  0.583     alphaQM:  0.317 ', ...
'alphaAY:  1.126     alphaAZ:  0.250     alphaAM:  2.037     alphaAQ:  0.479 ', ...
'probHsgMin:  0.587       probHsgMult:  2.031      probHsgOffset:  -0.770 ', ...
'prGradMin:  0.028   prGradMax:  0.901   prGradMult:  2.329 ', ...
'prGradExp:  1.378   wCollMean:  28.879       cCollMax:  9.652 ', ...
'lCollMax:  0.175    eHatCD:  -0.141     dEHatHSD:  -0.378 ', ...
'dEHatHSG:  -0.052   dEHatCG:  0.214'];

% Make into cell array of string
outputV = strsplit(outputStr, ' ');
n = length(outputV);

% Show what we are doing
disp('Setting these parameters: ');
for i1 = 1 : 2 : (n-1)
   paramStr = outputV{i1};
   if paramStr(end) == ':'
      paramStr(end) = [];
      outputV{i1} = paramStr;
   else
      error('No semicolon found');
   end
   fprintf('  %s  ->  %s \n',  outputV{i1}, outputV{i1+1});
end

% Ask for confirmation
ans1 = input_lh.ask_confirm('Write these values into file?', false);

if ans1
   cS = const_bc1(setNo, expNo);
   paramS = var_load_bc1(cS.vParams, cS);
   for i1 = 1 : 2 : (n-1)
      nameStr = outputV{i1};
      newValue = str2double(outputV{i1+1});
      validateattributes(newValue, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      paramS.(nameStr) = newValue;
      fprintf('  %s  ->  %.3f \n',  nameStr, paramS.(nameStr));
   end
   
   % Save
   var_save_bc1(paramS, cS.vParams, cS);
end


end