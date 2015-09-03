function test_all_bc1(setNo)

if nargin < 1
   setNo = 7;
end

dbstop error;

param_derived_test_bc1(setNo);
test_bc1.work(setNo);
test_bc1.college(setNo);
test_bc1.calibr(setNo);


helper_bc1.marginals_test;

dbclear all;

end