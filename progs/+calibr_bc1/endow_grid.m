function gridM = endow_grid(muV, stdV, wtM, cS)
% Construct the endowment grid
%{
Realized means and std can be quite far off the target ones for reasonably large numbers of types 
(e.g. 80)

Zero standard deviations are OK
But make sure to set the correlation params for those variables to 0 as well

IN
   muV(iVar), stdV(iVar)
      mean and std dev of marginals
      variances may be 0
   wtM
      weight each var puts on each random variable
%}
% ---------------------------------------------

n = cS.nTypes;
nVar = length(muV);
dbg = cS.dbg;


%% Input check
if cS.dbg > 10
   validateattributes(muV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nVar, 1]})
   validateattributes(stdV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nVar, 1], '>=', 0})
   validateattributes(wtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nVar, nVar], ...
      '>', -10, '<', 10})
   
   % If there are any 0 std deviations: make sure all the correlation params are also 0
   zeroIdxV = find(abs(stdV) < 1e-10);
   if ~isempty(zeroIdxV)
      for i1 = zeroIdxV(:)'
         checkIdxV = 1 : nVar;
         checkIdxV(i1) = [];
         if any(wtM(i1, checkIdxV) > 1e-8)  ||  any(wtM(checkIdxV,i1) > 1e-8)
            error_bc1('Invalid', cS);
         end
      end
   end
end



%% Make the endowment grid

rng(3);

mS = random_lh.MultiVarNormal(muV, stdV);
gridM = mS.draw_given_weights(n, wtM, dbg);


% randM = randn([n, nVar]);

% % Try: scale random vars to get realized distribution of endowments closer to target
% rMeanV = mean(randM);
% rStdV  = std(randM);
% for iVar = 1 : nVar
%    randM(:, iVar) = (randM(:, iVar) - rMeanV(iVar)) / rStdV(iVar);
% end


% % Make wt matrix to get N(0,1) marginals
% gridM = zeros([n, nVar]);
% for iVar = 1 : nVar
%    wtV = wtM(iVar,:);
%    wtV = wtV ./ sqrt(sum(wtV .^ 2)) .* stdV(iVar);
%    gridM(:,iVar) = muV(iVar) + randM * wtV(:);
% end

% Try: scale outputs so that means and stds are exactly right
gMeanV = mean(gridM);
gStdV = std(gridM);
for iVar = 1 : nVar
   gridM(:, iVar) = (gridM(:, iVar) - gMeanV(iVar)) / max(1e-5, gStdV(iVar)) * stdV(iVar)   +   muV(iVar);
end


if cS.dbg > 10
   validateattributes(gridM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n, nVar]})
end



end