function init_bc1

fprintf('\nStartup borrowing constraints model 2\n');

% cS = const_bc1([]);

mPath = mfilename('fullpath');
progDir = fileparts(mPath);

addpath(progDir);

dirS = helper_bc1.directories([], 1,1);
addpath(dirS.sharedDir);
addpath(fullfile(dirS.sharedDir, 'export_fig'));

% setNo = cS.setDefault;
% expNo = cS.expBase;
% cS = const_bc1(setNo, expNo);

% helper_bc1.parpool_open(cS);

end