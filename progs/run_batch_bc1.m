function run_batch_bc1(solverStr, perturbGuess, setNoV, expNo)
% Runs batch code on kure
%{
For single setNo: run calibration or experiment
For multiple setNos: submit one batch job per calibration

Before running this, go_bc1 has been run and put all dirs on the path

IN:
   solverStr
      'all'
         run all experiments without recalibrating the model
      'cumul', 'decomp'
         run subset of experiments (see exper_all)
%}


% init_bc1;

% Need to run this once (only) for parallel
% configCluster; 

% If an existing matlabpool is open: close it
% Does not work
% matlabpool close force local;

cS = const_bc1(setNoV(1), expNo);

% Strings that indicate to run experiments
experStrV = {'cumul', 'decomp', 'all'};


%% Cases
if length(setNoV) == 1
   if any(strcmpi(solverStr, experStrV))
      % Just run experiments
      % But also calibrate with 'none' so that we are sure to have current base results
      calibr_bc1.calibr('none', setNoV, cS.expBase);
      exper_all_bc1(solverStr, setNoV);
      
   elseif strcmpi(solverStr, 'exper')
      % A single experiment
      exper_bc1(setNoV(1), expNo);

   elseif expNo == cS.expBase
      % A single job to calibrate
      calibr_bc1.calibr(solverStr, setNoV, expNo);
      
   else
      error('Invalid');
   end
   
else
   % Multiple jobs
   for setNo = setNoV(:)'
      fprintf('Submitting job for set %i /%i \n', setNo, expNo);
      submit_job(solverStr, perturbGuess, setNo, expNo)
   end
end


end




%% Local: submit a job as a separate job
function submit_job(solverStr, perturbGuess, setNo, expNo)
   error('Not implemented');
   cmdStr = kure_command_bc1(solverStr, setNo, expNo);
   system(cmdStr);
end