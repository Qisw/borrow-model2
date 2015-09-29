function upload_progs

setNo = 1;
expNo = 1;
dirLocalS = helper_bc1.directories(true,  setNo, expNo);
dirKureS  = helper_bc1.directories(false, setNo, expNo);

kS = KureLH;

kS.updownload(dirLocalS.progDir, dirKureS.progDir, 'up');
% Currently using common shared progs
kS.upload_shared_code;
% kS.updownload(dirLocalS.sharedDir, dirKureS.sharedDir, 'up');

end