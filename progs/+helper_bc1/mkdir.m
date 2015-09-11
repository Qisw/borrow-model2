function mkdir(setNo, expNo)
% Make all directories needed

dbg = 111;
% cS = const_bc1(setNo, expNo);
dirS = helper_bc1.directories([], setNo, expNo);

files_lh.mkdir_lh(dirS.matDir, dbg);
files_lh.mkdir_lh(dirS.outDir, dbg);
files_lh.mkdir_lh(dirS.fitDir, dbg);
files_lh.mkdir_lh(dirS.paramDir, dbg);
files_lh.mkdir_lh(dirS.dataOutDir, dbg);
files_lh.mkdir_lh(dirS.hhDir, dbg);


%% Also make remote directories
% Requires that 'killdevil' is mounted as a disk
kS = KureLH;
if kS.is_mounted
   remoteBaseDir = fullfile(kS.mountedVolume, 'bc', 'model2');
   files_lh.mkdir_lh(fullfile(remoteBaseDir, 'mat', dirS.setStr, dirS.expStr), dbg);
   files_lh.mkdir_lh(fullfile(remoteBaseDir, 'out', dirS.setStr, dirS.expStr), dbg);
end

end
