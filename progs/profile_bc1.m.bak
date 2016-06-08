% Profiling script
% Cannot be in a function. The profiler does not seem to work there

setNo = 7;
cS = const_bc1(setNo);
paramS = param_load_bc1(setNo, cS.expBase);

dbclear all;
profile clear;
profile on;
cS.dbg = 0;

tic
hhS = hh_bc1.hh_solve(paramS, cS);
toc

profile off;
profile report;


% end
