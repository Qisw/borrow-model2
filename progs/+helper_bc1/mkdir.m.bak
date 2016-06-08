function mkdir(setNo, expNo)
% Make all directories needed

dbg = 111;
% cS = const_bc1(setNo, expNo);
dirS = helper_bc1.directories([], setNo, expNo);

filesLH.mkdir(dirS.matDir, dbg);
filesLH.mkdir(dirS.outDir, dbg);
filesLH.mkdir(dirS.fitDir, dbg);
filesLH.mkdir(dirS.paramDir, dbg);
filesLH.mkdir(dirS.dataOutDir, dbg);
filesLH.mkdir(dirS.hhDir, dbg);


%% Also make remote directories
% Requires that 'killdevil' is mounted as a disk
kS = KureLH;
if kS.is_mounted
   remoteBaseDir = fullfile(kS.mountedVolume, 'bc', 'model2');
   filesLH.mkdir(fullfile(remoteBaseDir, 'mat', dirS.setStr, dirS.expStr), dbg);
   filesLH.mkdir(fullfile(remoteBaseDir, 'out', dirS.setStr, dirS.expStr), dbg);
end

end
