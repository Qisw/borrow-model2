% Constants
classdef Const < handle
   
properties
   dbg = 111;
   nSchool = 4
   iHSD = 1
   iHSG = 2
   iCD = 3
   iCG = 4
   
   % Endowments
   nEndow = 4;
   endowNameV = {'a', 'g', 'q', 'y'};
   idxA = 1;
   idxG = 2;
   idxQ = 3;
   idxY = 4;
   nSim = 2e3;
   
   % BC1 setNo, expNo
   setNo = 7;
   expNo = 1;
   % Cohort to use for calibration
   iCohort = 3;
   iCohortEarly = 1;
   
   % Class upper bounds
   yClUbV = 0.25 : 0.25 : 1;
   qClUbV = 0.25 : 0.25 : 1;
   
   % Target: conditioning on IQ should reduce Var(a | type) by this factor
   varAbilNoIqFactor = 0.6;
   
   % Target var(a | info), ratio when students condition on IQ and when they don't?
   tgVarAbilRatio = true;
   
   % Penalize corr (a, q) below this value
   minCorrAQ = 0.5;
   
   % *** Directories
   outDir
end

methods
   function cS = Const
      c0S = const_bc1(cS.setNo, cS.expNo);
      cS.outDir = fullfile(c0S.outDir, 'rfm1');
   end
end
   
end