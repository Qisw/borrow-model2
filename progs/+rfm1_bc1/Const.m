% Constants
classdef Const < handle
   
properties
   dbg = 111;
   nSchool = 4
   
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
   
   % Class upper bounds
   yClUbV = 0.25 : 0.25 : 1;
   qClUbV = 0.25 : 0.25 : 1;
   
   % Target: conditioning on IQ should reduce Var(a | type) by this factor
   varAbilNoIqFactor = 0.5;
end

methods
   function cS = Const
   end
end
   
end