function results_all_bc1(setNo, expNo)
% Show all results

cS = const_bc1(setNo, expNo);
% paramS = param_load_bc1(setNo, expNo);
saveFigures = 1;


%% Preparation

% Make dirs
helper_bc1.mkdir(setNo, expNo);

if cS.runLocal == 1
   % If local: delete older result files
   results_bc1.delete_old_results(setNo, expNo, 7, 'noconfirm');
else
   % If on the server: delete all existing out files
   results_bc1.delete_results(setNo, expNo, 'noconfirm');
end

preamble_lh.initialize(var_fn_bc1(cS.vPreambleData, cS), cS.preambleFn);

if expNo == cS.expBase
   % Create symbol table
   helper_bc1.symbol_table(setNo);
end


%% Parameters

for showCalibrated = [0 1]
   calibr_bc1.param_tb(showCalibrated, setNo, expNo);
end
results_bc1.param_show(saveFigures, setNo, expNo);
results_bc1.endow_corr_show(setNo, expNo);
results_bc1.lty_show(saveFigures, setNo, expNo);



%% Main plots

% Fit
results_bc1.fit(saveFigures, setNo, expNo);
results_bc1.fit_qy(saveFigures, setNo, expNo);
% Table with all deviations from cal targets
results_bc1.fit_tb(setNo, expNo);


% Show policy functions
results_bc1.hh_show(saveFigures, setNo, expNo);
results_bc1.iq_outcomes(saveFigures, setNo, expNo);
results_bc1.yp_outcomes(saveFigures, setNo, expNo);
% Show value functions
results_bc1.value_show(saveFigures, setNo, expNo);

% Show aggregates
results_bc1.aggr_show(saveFigures, setNo, expNo);
results_bc1.aggr_qy_show(saveFigures, setNo, expNo);

results_bc1.prob_show(saveFigures, setNo, expNo);
results_bc1.prob_hsg_show(saveFigures, setNo, expNo);


%% Diagnostics

calibr_bc1.check_solution(setNo, expNo);

% Show how leisure varies across types for given consumption 
%  b/c of free consumption / leisure
results_bc1.static_show(saveFigures, setNo, expNo);

% Which params are close to bounds?
results_bc1.params_close_to_bounds(setNo, expNo);

% Show how prob(grad college | a) varies with parameters
results_bc1.prob_grad_a_show(setNo, expNo);

% For given j: show history
% results_bc1.history_show(setNo, expNo);

results_bc1.preamble_make(setNo, expNo);


end