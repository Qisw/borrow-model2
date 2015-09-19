function probV = prob_hsg(abilV, paramS, cS)
%{
IN:
   abilV
      expected ability | j
%}

probV = logistic_lh(abilV, paramS.probHsgMin, 1, 1,  paramS.probHsgMult, paramS.probHsgOffset, cS.dbg);

% Linear in signal
% probV = max(0, min(1, paramS.probHsgInter + paramS.probHsgSlope .* abilV));

if cS.dbg > 10
   validateattributes(probV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1})
end

end