function calibr(setNo)
% Test of calibration routines

cS = const_bc1(setNo);
expNo = cS.expBase;
cS.dbg = 111;

fprintf('\nTesting calibration routines \n\n');

% test_bc1.pr_iq_a;

% Endowment grid
calibr_bc1.endow_grid_test(setNo);

% Aggregation
aggr_bc1.aggregates_test(setNo);

% Objective function
% Takes a long time
if 0
   calibr_bc1.cal_dev_test(setNo);
end

end