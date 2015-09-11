function dirS = directories(runLocal, setNo, expNo)
%{
Directories are either
- local
- kure

Shared dirs are NOT on path when this runs the first time.

IN
   runLocal
      return local or kure or mounted directories?
      may be []; then the function figures out whether we run locally
%}

global lhS;
% kS = KureLH;

setStr = sprintf('set%03i', setNo);
expStr = sprintf('exp%03i', expNo);
dirS.setStr = setStr;
dirS.expStr = expStr;

if isempty(runLocal)
   dirS.runLocal = (exist('/users/lutz', 'dir') > 0);
else
   dirS.runLocal = runLocal;
end

% Only baseDir depends on whether we are local
if dirS.runLocal
   dirS.baseDir = fullfile('/users', 'lutz', 'dropbox', 'hc', 'borrow_constraints');
else
   dirS.baseDir = fullfile('/nas02/home/l/h/lhendri/', 'bc');
end


% Dir hierarchy
dirS.modelDir = fullfile(dirS.baseDir, 'model2');

   dirS.progDir = fullfile(dirS.modelDir, 'progs');
   % For paper figures
   dirS.paperDir = fullfile(dirS.modelDir, 'PaperFigures');
   dirS.matDir  = fullfile(dirS.modelDir, 'mat', setStr, expStr);

   dirS.setOutDir = fullfile(dirS.modelDir, 'out', setStr);
      % Show data
      dirS.dataOutDir = fullfile(dirS.setOutDir, 'data');
      dirS.outDir  = fullfile(dirS.setOutDir, expStr);
         % Within an experiment: show fit
         dirS.fitDir  = fullfile(dirS.outDir, 'fit');
         % Parameters
         dirS.paramDir = fullfile(dirS.outDir, 'params');
         % Hh solution
         dirS.hhDir = fullfile(dirS.outDir, 'household');

if dirS.runLocal
   dirS.sharedDir = lhS.sharedDir;
else
   dirS.sharedDir = fullfile(dirS.modelDir, 'shared');
end

dirS.dataDir = fullfile(dirS.baseDir, 'data');

dirS.cpsDir = fullfile(dirS.baseDir, 'cps');
   dirS.cpsProgDir = fullfile(dirS.cpsDir, 'progs');
   

% Preamble data
dirS.preambleFn = fullfile(dirS.outDir, 'preamble1.tex');
dirS.symbolFn = fullfile(dirS.outDir, 'symbols.tex');


%% Local only names

% NLSY79 data moments
dirS.nlsy79Fn = ...
   '/Users/lutz/Dropbox/borrowing constraints/Calibration targets/NLSY 79/August 2015/Results/all_targets_struct.mat';

% NLSY97 data moments
dirS.nlsy97Fn = ...
   '/Users/lutz/Dropbox/borrowing constraints/Calibration targets/NLSY 97/August 2015/Results/all_targets_struct.mat';

% Historical study data files live here
dirS.studyDir = '/Users/lutz/Dropbox/borrowing constraints/data/';
   dirS.studyGradDir  = fullfile(dirS.studyDir, 'income x iq x college grad');
   dirS.studyEntryDir = fullfile(dirS.studyDir, 'income x iq x college');



end