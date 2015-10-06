function fig_save(figFn, saveFigures, cS)
%{
IN
   figFn
      with or without directory
%}

% Add directory, if none present
figFn = files_lh.fn_complete(figFn, cS.outDir, [], cS.dbg);
figDir = fileparts(figFn);

figS = const_fig_bc1;
figOptS = figS.figOptS;

% Store FIG files here
figOptS.figDir = fullfile(figDir, 'figdata');
if ~exist(figOptS.figDir, 'dir')
   filesLH.mkdir(figOptS.figDir);
end

figures_lh.fig_save_lh(figFn, saveFigures, figS.slideOutput, figOptS);

end