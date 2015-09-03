function yearV = year_from_age(ageV, bYearV)
% Compute year from age and birth year

% To make sure order of arguments is correct
if (ageV < 0)  || (ageV > 100)
   error('Invalid age');
end

yearV = bYearV + ageV - 1;

end