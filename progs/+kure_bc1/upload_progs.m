function upload_progs

setNo = 1;
expNo = 1;
dirLocalS = helper_bc1.directories(true,  setNo, expNo);
dirKureS  = helper_bc1.directories(false, setNo, expNo);

kure_lh.updownload(dirLocalS.progDir, dirKureS.progDir, 'up');
kure_lh.updownload(dirLocalS.sharedDir, dirKureS.sharedDir, 'up');

end