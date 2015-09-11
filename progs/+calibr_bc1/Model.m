% High level description of model features
%{
%}
classdef Model
   
properties
   % ******  College
   % Free consumption by j?
   hasCollCons
   % Free leisure by j?
   hasCollLeisure
   % Heterogeneity in college costs?
   hasCollCostHetero
end

methods
   %% Constructor
   function mS = Model
      mS.hasCollCons = true;
      mS.hasCollLeisure = true;
      mS.hasCollCostHetero = false;
   end
   
   
   %% Validate
   function validate(mS)
      if mS.hasCollCons ~= true  &&  mS.hasCollCons ~= false
         error('Invalid');
      end
      %validateattributes(x, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
end

end