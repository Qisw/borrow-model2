function fh = plot_by_abil(yM, saveFigures, cS)
% Plot a variable by ability (or a set of variables)
%{
Leave plot open and return handle
%}

figS = const_fig_bc1;

nVars = size(yM, 2);
if size(yM, 1) ~= cS.nAbil
   error('Invalid');
end


paramS = param_load_bc1(cS.setNo, cS.expNo);
xV = cumsum(paramS.prob_aV);

fh = output_bc1.fig_new(saveFigures, []);
hold on;

for iVar = 1 : nVars
   plot(xV, yM(:, iVar), figS.lineStyleV{iVar}, 'color', figS.colorM(iVar,:));
end

hold off;
xlabel('Ability percentile');

end