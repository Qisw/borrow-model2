% Calibrated parameters
%{
alphaXY determines correlation matrix of endowments
ordering: a, g, q, y
%}
classdef CalParams < handle

properties
   alphaAG  double
   alphaAQ  double
   alphaAY  double
   
   alphaGQ  double
   alphaGY  double
   
   alphaQY  double
end

methods
   %% Constructor
   function pS = CalParams
   end
   
   %% Validate
   function validate(pS)
      fnV = properties(pS);
      for i1 = 1 : length(fnV)
         validateattributes(pS.(fnV{i1}), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      end
   end
   
   %% Initialize with random values (for testing)
   % Using positive values for all (b/c it is most plausible a priori)
   function initialize_random(pS)
      fnV = properties(pS);
      for i1 = 1 : length(fnV)
         pS.(fnV{i1}) = rand(1,1);
      end
   end
   
   
   %% Default pvector
   function pv = pvector(pS)
      doCal = 1;
      nCal = 6;
      pv = pvectorLH(nCal, doCal);
      
      fnV = properties(pS);
      for i1 = 1 : length(fnV)
         pStr = fnV{i1};
         if strncmp(pStr, 'alpha', 5)
            p1 = pstructLH(pStr, pStr, pStr, 0.5, 0, 3, doCal);
            pv.add(p1);
         end
      end
   end
   
   
   %% Make lower triangular weight matrix for multivariate normal
   function wtM = weight_matrix(pS, cS)
      n = cS.nEndow;
      wtM = eye(n);
      wtM(cS.idxG, cS.idxA) = pS.alphaAG;
      wtM(cS.idxQ, [cS.idxA, cS.idxG]) = [pS.alphaAQ, pS.alphaGQ];
      wtM(cS.idxY, [cS.idxA, cS.idxG, cS.idxQ]) = [pS.alphaAY, pS.alphaGY, pS.alphaQY];
%       wtM(cS.idxA, [cS.idxG, cS.idxQ, cS.idxY]) = [pS.alphaAG, pS.alphaAQ, pS.alphaAY];
%       wtM(cS.idxG, [cS.idxQ, cS.idxY]) = [pS.alphaGQ, pS.alphaGY];
%       wtM(cS.idxQ, cS.idxY) = pS.alphaQY;
      
      validateattributes(wtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [4,4]})
   end
   
end
   
end