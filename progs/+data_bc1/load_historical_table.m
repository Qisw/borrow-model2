function outS = load_historical_table(loadFn)
% Make a data table into a matrix for each variable in the table
% by [q, y]
%{
Expects variables and 'cum_ses' / 'cum_iq' for class bounds

Steps
1. Load the file
2. Make each variable into a matrix by [q,y]
%}

%% Load the table

loadM = readtable(loadFn);
% Variable names
vnV = loadM.Properties.VariableNames;
nObs = length(loadM.cum_ses);

%    % Only keep all reces / sexes
%    idxV = find(strcmp(loadM.gender, 't')  &  strcmp(loadM.race, 't'));
%    loadM = loadM(idxV, :);
%    nObs = length(idxV);


% Recode interval upper bounds
[iYpV, ypUbV] = vector_lh.recode_sequential(loadM.cum_ses, 5);
validateattributes(iYpV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', ...
   'size', [nObs,1]})
outS.ypUbV = ypUbV;

[iIqV, iqUbV] = vector_lh.recode_sequential(loadM.cum_iq, 5);
validateattributes(iIqV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', ...
   'size', [nObs,1]})
outS.iqUbV = iqUbV;


%% Make each variable into a matrix by [q, y]

for iVar = 1 : length(vnV)
   varName = vnV{iVar};
   % exclude some variables
   if all(strcmpi(varName, {'race', 'gender', 'cum_ses', 'cum_iq'}) == 0)
      outS.([varName, '_qyM']) = accumarray([iIqV, iYpV], loadM.(varName));
   end
end
   
   
%% Output check

validateattributes(outS.ypUbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1.001})
validateattributes(outS.iqUbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1.001})

% Deal with rounding
outS.iqUbV = min(outS.iqUbV, 1);
outS.ypUbV = min(outS.ypUbV, 1);

end

