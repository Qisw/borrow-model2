function paper_figures_bc1
% Copy results to PaperFigures dir

disp('Copying results to paper');
setNo = 7;
expNo = 1;
cS = const_bc1(setNo, expNo);
dirS = cS.dirS;

tgDir = cS.paperDir;
if ~exist(tgDir, 'dir')
   error('tg dir does not exist');
end


sourceV = {cS.symbolFn,    fullfile(cS.paramDir, 'param_tb.tex'),    fullfile(cS.paramDir, 'param_fixed_tb.tex'), ...
   fullfile(cS.outDir, 'preamble1.tex')};
tgV     = {'symbols.tex',  'param_tb.tex',   'param_fixed_tb.tex', ...
   'preamble1.tex'};

for i1 = 1 : length(sourceV)
   copy_one(sourceV{i1}, tgV{i1});
end


%% Fit

tgDir = fullfile(cS.paperDir, 'fit');
filesLH.mkdir(tgDir);

copy_one(fullfile(dirS.fitDir, 'fit.tex'));
copy_one(fullfile(dirS.fitDir, 'iq_enter.pdf'));
copy_one(fullfile(dirS.fitDir, 'yp_enter.pdf'));
copy_one(fullfile(dirS.fitDir, 'iq_grad.pdf'));
copy_one(fullfile(dirS.fitDir, 'yp_grad.pdf'));
copy_one(fullfile(dirS.fitDir, 'iq_debtmean.pdf'));
copy_one(fullfile(dirS.fitDir, 'yp_debtmean.pdf'));
copy_one(fullfile(dirS.fitDir, 'iq_transfer.pdf'));
copy_one(fullfile(dirS.fitDir, 'yp_transfer.pdf'));


%% Time series: by cohort

for iCohort = 1 : cS.nCohorts
   if iCohort ~= cS.iRefCohort
      expNo2 = cS.expS.bYearExpNoV(iCohort);
      c2S = const_bc1(setNo, expNo2);
      tgDir = fullfile(cS.paperDir,  c2S.cohortS.descrV{iCohort});
      filesLH.mkdir(tgDir);
      
      dirS = c2S.dirS;
      
      copy_one(fullfile(dirS.fitDir, 'fit.tex'));
      
      % Comparison with ref cohorts
      outDir = fullfile(dirS.setOutDir, sprintf('cumulative%i', cS.bYearV(iCohort)));
      copy_one(fullfile(outDir, 'beta_iq_decomp.pdf'));
      copy_one(fullfile(outDir, 'beta_yp_decomp.pdf'));
   end
end


%% Time series: cohort comparison

tgDir = fullfile(cS.paperDir, 'cohort_compare');
srcDir = fullfile(dirS.setOutDir, 'cohort_compare');
filesLH.mkdir(tgDir);

copy_one(fullfile(srcDir, 'beta_iq.pdf'));
copy_one(fullfile(srcDir, 'beta_yp.pdf'));


%% Nested: copy one file
   function copy_one(sourceFn, tgFn)
      % If target omitted: keep same name
      if nargin < 2
         [~, fName, fExt] = fileparts(sourceFn);
         tgFn = [fName, fExt];
      end
      
      
      if exist(sourceFn, 'file')
         copyfile(sourceFn,  fullfile(tgDir, tgFn));
      else
         fprintf('File does not exist: \n');
         fprintf('    %s \n',  sourceFn);
      end      
   end


end