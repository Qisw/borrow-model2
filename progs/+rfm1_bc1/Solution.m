% Holds solution to the model
%{
cal_dev fills this
does not contain individual realizations
%}
classdef Solution < handle
   
properties
   % Cov matrix of endowments (order defined in Const)
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
   % Fraction HSG+ given y or q
   fracHsg_yV  double
   fracHsg_qV  double
   % Fraction CD+ given y or q (mass CD+ / mass total)
   fracEnter_yV   double
   fracEnter_qV   double
   % Mean IQ by s
   iqMean_sV   double
   yMean_sV    double
   
   % Var(a | info), with and without observing IQ
   condVarAbil    double
   condVarAbilNoIq   double
end
   
methods
   function sS = Solution
   end   
end
   
end