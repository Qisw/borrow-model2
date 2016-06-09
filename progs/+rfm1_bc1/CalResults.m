% Holds output of calibration routine
classdef CalResults
   
properties
   % Solution for base cohort
   solBaseS    rfm1_bc1.Solution
   % Solution for early cohort
   solEarlyS    rfm1_bc1.Solution
end

methods
   function crS = CalResults(sol1S, sol2S)
      crS.solBaseS = sol1S;
      crS.solEarlyS = sol2S;
   end
end

end