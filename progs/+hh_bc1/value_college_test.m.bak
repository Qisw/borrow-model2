function value_college_test(setNo)

disp('Testing value_college');

cS = const_bc1(setNo);
expNo = cS.expBase;
paramS = param_load_bc1(setNo, expNo);

age = 3;
periodLength = 2;

nk = 100;
kV = linspace(-3, 5, nk);
continValueFct = griddedInterpolant(kV, kV .^ (1 - 2) ./ (1-2), 'linear', 'linear');
continValueFct_jV = cell([cS.nTypes, 1]);
for j = 1 : cS.nTypes
   continValueFct_jV{j} = continValueFct;
end

kGridV = linspace(-2, 4, 50)';
hh_bc1.value_college(age, periodLength, kGridV, continValueFct_jV, paramS, cS);

end