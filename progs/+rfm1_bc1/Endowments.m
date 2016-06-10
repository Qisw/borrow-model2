% Individual endowments
classdef Endowments < handle

properties
   % Weight matrix for making multivar normal object
   wtM   double
   % Multivariate normal object
   mvnS  randomLH.MultiVarNormal
   % No of persons to simulate
   % nSim
   dbg
end

properties (Dependent)
   % Cov matrix
   covM
end


methods 
   %% Constructor
   function eS = Endowments(paramS, cS)
      % Make lower triangular weight matrix from calibrated params
      eS.wtM = paramS.weight_matrix(cS);
      n = size(eS.wtM, 1);

      % Marginals do not matter. Set to mean 0, std 1
      eS.mvnS = randomLH.MultiVarNormal(zeros(n, 1), ones(n,1));

      %eS.nSim = cS.nSim;
      eS.dbg = cS.dbg;
      
   end
   
   %% Implied cov matrix
   function covM = get.covM(eS)
      covM = eS.mvnS.cov_from_weights(eS.wtM, eS.dbg);
   end
   
   
   %% Draw endowments
   function randM = draw_endowments(eS, nSim)
      rng(251);
      randM = eS.mvnS.draw_given_weights(nSim, eS.wtM, eS.dbg);
   end
   
   
   %% Compute E(a | other vars)
   %{
   Also conditional var(a). Scalar
   %}
   function [eaV, condVar] = conditional_distrib_abil(eS, conditionOnIq, randM)
      cS = rfm1_bc1.Const;
      assert(isequal(cS.idxA, 1));
      n = size(eS.wtM, 1);
      
      if isempty(randM)
         randM = eS.draw_endowments(cS.nSim);
      end
      nSim = size(randM, 1);

      if conditionOnIq
         % Hh conditions on IQ
         % Condition on everything but a
         idxCondV = 1 : n;
         idxCondV(cS.idxA) = [];
      else
         % Same without IQ
         idxCondV = 1 : n;
         idxCondV([cS.idxA, cS.idxQ]) = [];
      end
      
      % Means
      eaV = zeros(nSim, 1);
      for i1 = 1 : nSim
         aMeanV = eS.mvnS.conditional_distrib(idxCondV, randM(i1, idxCondV), eS.covM, cS.dbg);
         % Assumes cS.idxA == 1
         eaV(i1) = aMeanV(1);
      end
      validateattributes(eaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nSim, 1]})
         
      % Variance (scalar)
      [~, std1] = eS.mvnS.conditional_distrib(idxCondV, randM(1, idxCondV), eS.covM, cS.dbg);
      condVar = std1(1) .^ 2;
   end

end
   
end