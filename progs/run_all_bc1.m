function run_all_bc1(setNo)
% Run everything in sequence

cS = const_bc1(setNo);


%% Prepare the set
if 0
   % Make directories
   helper_bc1.mkdir(setNo, cS.expNo);
   
   data_all_bc1(setNo);
   return;
end


%% Test routines
if 01
   test_all_bc1(setNo);
end



%% Calibration and experiments
if 01
   % Copy params from intermediate guess
   % param_from_guess_bc1(setNo, expNo);
   % This is used to set params to fixed values
   % calibr_bc1.param_set(setNo, expNo);
   
   % Calibrate for base cohort (all params)
   calibr_bc1.calibr('none', setNo, cS.expBase);
   
   % Run all experiments that do not require recalibration
   % Needs to be done after calibrating for all cohorts!
   exper_all_bc1(setNo);
end


%% Results
if 0
   % Use this to delete existing results for clean slate
   % results_bc1.delete_results(setNo, expNo);
   % Delete old result files with this
   % results_bc1.delete_old_results(setNo, expNo, minAge, askConfirm);
   % Calibration runs this
   % results_all_bc1(setNo, cS.expBase);
   
   % Show results for experiments
   exper_results_bc1('all', setNo);

   % Copy results to paper dir
   paper_figures_bc1;
end



end