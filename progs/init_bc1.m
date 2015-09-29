% function init_bc1
% Startup script. Everything is already on path

      % fprintf('\nStartup borrowing constraints model 2\n');
      % 
cS = const_bc1([]);
      % 
      % % global lhS;
      % 
      % 
      % % Add program dir to path
      % mPath = mfilename('fullpath');
      % progDir = fileparts(mPath);
      % addpath(progDir);
      % 
      % 
      % dirS = helper_bc1.directories([], 1,1);
      % for i1 = 1 : length(dirS.sharedDirV)
      %    addpath(dirS.sharedDirV{i1});
      % end
%addpath(fullfile(dirS.sharedDir, 'export_fig'));

setNo = cS.setDefault;
expNo = cS.expBase;
cS = const_bc1(setNo, expNo);

% helper_bc1.parpool_open(cS);

% end