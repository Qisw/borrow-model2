function kPrimeV = coll_bc_kprime(cV, hoursV, kV, wColl, pColl, transfer, R, periodLength, cS)
% Budget constraint in college

if cS.dbg > 10
   validateattributes(wColl, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
   if ~any(periodLength == [1,2])
      error('Invalid');
   end
end

kPrimeV = (R ^ periodLength) * kV + (1 + R * (periodLength - 1)) * (wColl * hoursV - cV - pColl + transfer);

if cS.dbg > 10
   validateattributes(kPrimeV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
end

end