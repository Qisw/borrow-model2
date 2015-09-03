function cV = coll_bc(kPrimeV, hoursV, kV, wColl, pColl, transfer, R, periodLength, cS)
% Budget constraint in college
%{
Does not ensure positive consumption
%}

if cS.dbg > 10
   validateattributes(wColl, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
   if periodLength ~= 1  &&  periodLength ~= 2
      error('Not implemented');
   end
end

cV = (R ^ periodLength * kV - kPrimeV) ./ (1 + R * (periodLength-1)) + (wColl * hoursV + transfer - pColl);


end