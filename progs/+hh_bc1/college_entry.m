function probCollege_jV = college_entry(v1S, vWorkS, paramS, cS)
% College entry decision
%{
IN
   v1S
      value function in college at period 1
   vWorkS
      value of working

OUT
   vWork, vColl
      value of work, college
      without pref shocks!

%}

prob_ixM = econLH.extreme_value_decision([v1S.value_jV,  vWorkS.valueHsg_jV], paramS.prefScaleEntry, cS.dbg);

probCollege_jV = prob_ixM(:, 1);

if cS.dbg > 10
   validateattributes(probCollege_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1, 'size', [cS.nTypes, 1]})
end
   
end