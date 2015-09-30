function fh = plot_by_m(yM, saveFigures, cS)
% Plot a variable by m (or a set of variables)
%{
Instead of m, we now plot by E(ability | j)
Leave plot open and return handle
%}

% figS = const_fig_bc1;

nVars = size(yM, 2);
if size(yM, 1) ~= cS.nTypes
   error('Invalid');
end


% Sort types by m
paramS = param_load_bc1(cS.setNo, cS.expNo);
sortM = sortrows([paramS.endowS.abilMean_jV, (1 : cS.nTypes)']);

% Sorted type indices
jIdxV = sortM(:, 2);
xV = cumsum(paramS.prob_jV(jIdxV));

fh = output_bc1.fig_new(saveFigures, []);
hold on;

for iVar = 1 : nVars
   output_bc1.plot_line(xV, yM(jIdxV, iVar), iVar, cS);
   % plot(xV, yM(jIdxV, iVar), figS.lineStyleDenseV{iVar}, 'color', figS.colorM(iVar,:));
end

hold off;
xlabel('Expected ability percentile');

end