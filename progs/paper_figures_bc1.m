function paper_figures_bc1
% Copy results to PaperFigures dir

disp('Copying results to paper');
setNo = 7;
expNo = 1;
cS = const_bc1(setNo, expNo);

tgDir = cS.paperDir;
if ~exist(tgDir, 'dir')
   error('tg dir does not exist');
end


sourceV = {cS.symbolFn,    fullfile(cS.paramDir, 'param_tb.tex'),    fullfile(cS.paramDir, 'param_fixed_tb.tex'), ...
   fullfile(cS.fitDir, 'fit.tex'),  fullfile(cS.outDir, 'preamble1.tex')};
tgV     = {'symbols.tex',  'param_tb.tex',   'param_fixed_tb.tex', ...
   'fit.tex',  'preamble1.tex'};

for i1 = 1 : length(sourceV)
   if exist(sourceV{i1}, 'file')
      copyfile(sourceV{i1},  fullfile(tgDir, tgV{i1}));
   else
      fprintf('File does not exist: \n');
      fprintf('    %s \n',  sourceV{i1});
   end
   
end


end