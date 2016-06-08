function updownload(setNo, expNoV, upDownStr)
% Upload or download sets to kure
%{
Also uploads data files (if upload)
%}

cS = const_bc1(setNo);
kS = KureLH;

for expNo = expNoV(:)'
   dirLocalS = helper_bc1.directories(true,  setNo, expNo);
   dirKureS  = helper_bc1.directories(false, setNo, expNo);
   
   % Mat files (up and down)
%    fprintf('Local dir:  %s \n',  dirLocalS.matDir);
%    fprintf('Remote dir: %s \n',  dirKureS.matDir);
   kS.updownload(dirLocalS.matDir, dirKureS.matDir, upDownStr);
   
   % Out files (down only)
   if strcmp(upDownStr, 'down')
      disp('Downloading out files');
%       fprintf('Local dir:  %s \n',  dirLocalS.outDir);
%       fprintf('Remote dir: %s \n',  dirKureS.outDir);
      kS.updownload(dirLocalS.outDir, dirKureS.outDir, upDownStr);
   end
end


% Upload data files
% They are stored under cS.expBase
if strcmp(upDownStr, 'up')  &&  ~any(expNoV == cS.expBase)
   expNo = cS.expBase;
   dirLocalS = helper_bc1.directories(true,  setNo, expNo);
   dirKureS  = helper_bc1.directories(false, setNo, expNo);
   kS.updownload(dirLocalS.matDir, dirKureS.matDir, upDownStr);
end


end