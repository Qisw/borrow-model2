function probV = prob_hsg(mV, paramS, cS)

% probV = logistic_lh(mV, 0, 1, 1,  paramS.probHsgMult, paramS.probHsgOffset, cS.dbg);

% Linear in signal
probV = max(0, min(1, paramS.probHsgInter + paramS.probHsgSlope .* mV));

if cS.dbg > 10
   validateattributes(probV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1})
end

end