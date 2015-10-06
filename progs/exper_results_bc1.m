function exper_results_bc1(runStr, setNo)
% After running all experiments, show results
%{
If any experiments are not available, return with a warning
%}

% cS = const_bc1(setNo);

if ~ischar(runStr)
   error('runStr must be string');
end

% Pure comparative statics
if strcmpi(runStr, 'all')  ||  strcmpi(runStr, 'counter')
   pure_counter(setNo);
end

if strcmpi(runStr, 'all')  || strcmpi(runStr, 'timeSeries')
   time_series(setNo);
end

if strcmpi(runStr, 'all')  || strcmpi(runStr, 'sequential')
   sequential_decomp(setNo);
end

if strcmpi(runStr, 'all')  || strcmpi(runStr, 'cumulative')
   cohorts_side_by_side(setNo);   
   cumulative_decomp(setNo);
end

return;

end


%% Pure counterfactuals
function pure_counter(setNo)
   cS = const_bc1(setNo);
   
   for expNo = cS.expS.compStatExpNoV(:)'   
      c2S = const_bc1(setNo, expNo);
      expNoV = [cS.expBase, expNo];
      exper_bc1.compare(setNo * ones(size(expNoV)),  expNoV,  fullfile(cS.setOutDir,  c2S.expS.outDir));
   end
end


%% Time series calibration
function time_series(setNo)
   
   cS = const_bc1(setNo);
   outDir = fullfile(cS.dirS.setOutDir, 'cohort_compare');

   % Compare cohort outcomes
   cfExpNoV = cS.expS.bYearExpNoV(~isnan(cS.expS.bYearExpNoV));
   % expNoV = flip([cS.expBase, cfExpNoV]);  
   expNoV = cfExpNoV;
   %c2S = const_bc1(setNo, cfExpNoV(1));
   %outDir = fullfile(cS.setOutDir, c2S.expS.outDir);
   exper_bc1.compare(setNo .* ones(size(expNoV)), expNoV, outDir);
   
   % Short cohort comparison table to explain driving forces
   exper_bc1.cohort_summary(outDir, setNo);

end


%% For experiments that vary one variable at a time: show key outcomes
function sequential_decomp(setNo)

   cS = const_bc1(setNo);

   for iCohort = 1 : size(cS.expS.decomposeExpNoM, 2)
      if iCohort ~= cS.iRefCohort
         expNoV = [cS.expBase; cS.expS.decomposeExpNoM(:, iCohort)];
         outDir = fullfile(cS.setOutDir, sprintf('cohort%i', cS.bYearV(iCohort)));
         exper_bc1.compare(setNo .* ones(size(expNoV)), expNoV, outDir);
      end
   end

end


%% Cumulative change of parameter values for decomposition
function cumulative_decomp(setNo)

   cS = const_bc1(setNo);

   % For experiments that vary variables cumulatively
   for iCohort = 1 : size(cS.expS.decomposeCumulExpNoM, 2)
      if iCohort ~= cS.iRefCohort
         expNoV = [cS.expBase; cS.expS.decomposeCumulExpNoM(:, iCohort); cS.expS.bYearExpNoV(iCohort)];
         setNoV = setNo .* ones(size(expNoV));
         outDir = fullfile(cS.setOutDir, sprintf('cumulative%i', cS.bYearV(iCohort)));
         exper_bc1.compare(setNoV, expNoV, outDir);

         % Bar graph with decomposition
         % Not showing data is clearer
         iCohort1 = []; % cS.iRefCohort;
         iCohort2 = []; % iCohort;
         exper_bc1.beta_iq_yp_sequence(outDir, iCohort1, iCohort2, setNoV, expNoV);
      end
   end

end


%% Compare all cohorts side-by-side
% Cumulative decomposition
function cohorts_side_by_side(setNo)

   cS = const_bc1(setNo);
   
   % Settings
   outDir = fullfile(cS.setOutDir, 'cumulative');
   filesLH.mkdir(outDir);
   outFn = fullfile(outDir, 'decompose.tex');
   
   expNoM = cS.expS.decomposeCumulExpNoM;
   % Omit base cohort (decomposition is relative to that cohort)
   expNoM(:, cS.iRefCohort) = [];
   setNoM = setNo * ones(size(expNoM));
   [nx, nm] = size(expNoM);
   
   setTitleV = cell([nm, 1]);
   for im = 1 : nm
      cmS = const_bc1(setNoM(1,im), expNoM(1,im));
      setTitleV{im} = sprintf('Cohort %i', cmS.cohYearV(cmS.iCohort));
   end
   
   expTitleV = cell([nx, 1]);
   for ix = 1 : nx
      cxS = const_bc1(setNoM(ix,1), expNoM(ix,1));
      expTitleV{ix} = cxS.expS.expStr;
   end
   
   exper_bc1.tb_regr_entry_multiple(outFn, setTitleV, expTitleV, setNoM, expNoM);
end