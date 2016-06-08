% Holds solution to the model
%{
cal_dev fills this
%}
classdef Solution < handle
   
properties
   covM  double
   
   % For each "type":
   % E(a | info)
   eaV   double
   qClassV  double
   yClassV  double
   sClassV  double
   
   % Aggregate stats computed during calibration
   frac_sqM    double
   frac_syM    double
   % Mean IQ by s
   iqMean_sV   double
   
   % Var(a | info), with and without observing IQ
   condVarAbil    double
   condVarAbilNoIq   double
end
   
methods
   function sS = Solution
   end
end
   
end