function work(setNo)
% Just syntax test. The equations are tested in the UtilCrraLH code

fprintf('\nTesting hh work routines\n\n');

cS = const_bc1(setNo);
expNo = 1;
cS.dbg = 111;

paramS = param_load_bc1(setNo, expNo);


%% Syntax test

hh_bc1.util_work_bc1(linspace(0.1, 10, 5), paramS.utilWorkS, cS.dbg);

nInd = 10;
kV = rand([nInd, 1]);
pvEarnV = rand([nInd, 1]);
T = 23;
hh_bc1.hh_work_bc1(kV, pvEarnV, paramS.R, T, paramS.utilWorkS, cS.dbg);

% Value of working as HSG
hh_bc1.value_hsg(paramS, cS);

% Entire value of work function
hh_bc1.value_work(paramS, cS);


% [hhS, hhSuccess] = var_load_bc1(cS.vHhSolution, cS);
% if hhSuccess == 1
%    fprintf('Also testing saved hh value \n');
% end



end