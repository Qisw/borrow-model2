function hh_solve_test(setNo)

disp('Testing hh solution');
cS = const_bc1(setNo);
paramS = param_load_bc1(setNo, cS.expBase);

cS.dbg = 111;

tic
hhS = hh_bc1.hh_solve(paramS, cS);
toc

var_save_bc1(hhS, cS.vHhSolution, cS);

end