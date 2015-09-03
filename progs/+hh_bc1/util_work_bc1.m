function [utilV, muV, utilLifetime] = util_work_bc1(cV, utilWorkS, dbg)
% Utility at work
%{
OUT
   utilV
      for each cV
   muV
      marginal utilities
   utilLifetime
      lifetime utility

Test:
   directly implements model equations. No test.

Checked: 2015-Aug-21
%}

%% Input check
if dbg > 10
   validateattributes(cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
end


%% Main

[utilV, muV] = utilWorkS.util(cV, dbg);

if nargout >= 3
   % Lifetime utility
   % now interpreting cV as c over time
   utilLifetime = utilWorkS.lifetime_util(cV(:)', dbg);
else
   utilLifetime = nan;
end



%% Self-test
if dbg > 10
   validateattributes(utilV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', size(cV)})
   validateattributes(muV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', size(cV)})
   
   if nargout > 2
      validateattributes(utilLifetime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         'scalar'})
   end
end

end