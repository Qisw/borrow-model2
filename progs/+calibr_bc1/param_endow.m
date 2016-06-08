function paramS = param_endow(paramInS, cS)
% Endowment grids by type
%{
Packs newer params into endowS

this code needs to be cleaned up +++++
%}

dbg = cS.dbg;
paramS = paramInS;

if cS.modelS.hasCollCostHetero
   error('Not implemented');
end

% All agents start with 0 assets (bad assumption?)
paramS.k_jV = zeros(cS.nTypes, 1);

% All agents have the same college costs
paramS.pColl_jV = paramS.pMean .* ones(cS.nTypes, 1);

% All types have the same probability
paramS.prob_jV = ones([cS.nTypes, 1]) ./ cS.nTypes;


%% Make grids
% This code should be far more general: draw named endowments given parameters that define wtM +++++

% Order is 
%  y, z, m, IQ, ability
iYp = 1;
iTransfer = 2;
iSignal = 3;
iIq = 4;
iAbil = 5;

ng = 5;
wtM = diag(ones(ng, 1));
meanV = zeros(ng, 1);
stdV  = ones(ng, 1);

% yp is first: nothing to do with wtM
meanV(iYp) = paramS.logYpMean;
stdV(iYp) = paramS.logYpStd;

wtM(iTransfer, iYp) = paramS.alphaZY;
meanV(iTransfer) = paramS.logZMean;
stdV(iTransfer) = paramS.logZStd;

wtM(iSignal, [iYp, iTransfer]) = [paramS.alphaMY, paramS.alphaMZ];

wtM(iIq, [iYp, iTransfer, iSignal]) = [paramS.alphaQY, paramS.alphaQZ, paramS.alphaQM];

wtM(iAbil, [iYp, iTransfer, iSignal, iIq]) = [paramS.alphaAY, paramS.alphaAZ, paramS.alphaAM, paramS.alphaAQ];

% Multivariate normal object
mS = randomLH.MultiVarNormal(meanV, stdV);

% Covariance matrix implied by wtM (matching stdV)
endowS.covMatM = cov_from_weights(mS, wtM, dbg);
% Store the order of elements (for display later)
endowS.iYp = iYp;
endowS.iTransfer = iTransfer;
endowS.iSignal = iSignal;
endowS.iIq = iIq;
endowS.iAbil = iAbil;

% Grids = draws from joint normal
rng(21);
gridM = mvnrnd(mS.meanV(:)',  endowS.covMatM,  cS.nTypes);
validateattributes(gridM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nTypes, ng]});


% *****  Sort by E(ability | j)

% Indices of variables we condition on
idx2V = 1 : ng;
idx2V(iAbil) = [];

% Moments of a | j
abilMean_jV = zeros(cS.nTypes, 1);

for j = 1 : cS.nTypes
   % Conditional moments of a | j
   % Values we condition on (everyting except ability)
   value2V = gridM(j,:);
   value2V(iAbil) = [];
   abilMean_jV(j) = mS.conditional_distrib(idx2V, value2V, endowS.covMatM, dbg);
end

[~, sortIdxV] = sort(abilMean_jV);
gridM = gridM(sortIdxV, :);


% *****  Extract endowments from grid

paramS.yParent_jV = exp(gridM(:,iYp));
paramS.transfer_jV = exp(gridM(:,iTransfer));
paramS.m_jV = gridM(:,iSignal);
endowS.iq_jV = gridM(:, iIq);
% This is not needed
% paramS.abil_jV = gridM(:, iAbil);


%% Check endowment grid
if cS.dbg > 10
   % Check that joint distribution of endowments is close to expected
   % But: due to sampling error, means can be quite far off
   %mean2V = mean(gridM);
   %check_lh.approx_equal(mean2V(:), meanV(:), 1e-2, []);
%    std2V  = std(gridM);
%    check_lh.approx_equal(std2V(:), stdV(:), 5e-2, []);
%    covMat2M = cov(gridM);
%    check_lh.approx_equal(covMat2M, endowS.covMatM, 1e-1, []);
   
   % Moments of marginal distributions are checked in test fct for endow_grid
   validateattributes(paramS.yParent_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'positive', 'size', [cS.nTypes, 1]})
%    if abs(mean(paramS.m_jV)) > 0.2
%       disp(mean(paramS.m_jV));
%       error_bc1('Invalid mean m', cS);
%    end
%    if abs(std(paramS.m_jV) - 1) > 0.05
%       disp(std(paramS.m_jV));
%       error_bc1('Invalid std m', cS);
%    end
end


%% Ability

% Ability grid: equal probabilities
% paramS.abilGrid_aV = norminv(linspace(0.05, 0.95, cS.nAbil))';

% Normal grid object
ngS = distrib_lh.NormalGrid(linspace(1, 2, cS.nAbil)', dbg);

% Make grid with equal probabilities
%  This grid could be too narrow +++
ngS.set_grid_equal_prob(cS.nAbil, 0, 1, dbg);
paramS.abilGrid_aV = ngS.gridV;


% ****** Pr(a | type)
paramS.prob_a_jM = zeros([cS.nAbil, cS.nTypes]);

% Indices of variables we condition on
idx2V = 1 : ng;
idx2V(iAbil) = [];

% Moments of a | j
endowS.abilMean_jV = zeros(cS.nTypes, 1);
endowS.abilStd_jV  = zeros(cS.nTypes, 1);

for j = 1 : cS.nTypes
   % Conditional moments of a | j
   % Values we condition on (everyting except ability)
   value2V = gridM(j,:);
   value2V(iAbil) = [];
   [endowS.abilMean_jV(j), endowS.abilStd_jV(j)] = mS.conditional_distrib(idx2V, value2V, endowS.covMatM, dbg);

   % Convert these into probabilities for each ability grid point
   paramS.prob_a_jM(:, j) = ngS.grid_mass(endowS.abilMean_jV(j), endowS.abilStd_jV(j), dbg);
end

if cS.dbg > 10
   check_bc1.prob_matrix(paramS.prob_a_jM,  [cS.nAbil, cS.nTypes],  cS);
   validateattributes(paramS.abilGrid_aV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nAbil, 1]})
end


% ******  Derived

% Pr(a) = sum over j (pr(j) * pr(a|j))
paramS.prob_aV = zeros(cS.nAbil, 1);
for iAbil = 1 : cS.nAbil
   prob_a_jV = paramS.prob_a_jM(iAbil,:);
   paramS.prob_aV(iAbil) = sum(paramS.prob_jV(:) .* prob_a_jV(:));
end   

if cS.dbg > 10
   check_bc1.prob_matrix(paramS.prob_aV,  [cS.nAbil, 1], cS);   
end



%%  Free consumption / leisure in college 
%  Proportional to expected ability. Range 0 to cCollMax

xV = endowS.abilMean_jV;
mMin = min(xV);
mMax = max(xV);

if cS.modelS.hasCollCons
   paramS.cColl_jV = (xV - mMin) .* paramS.cCollMax ./ (mMax - mMin);
else
   paramS.cColl_jV = zeros(cS.nTypes, 1);
end
if cS.modelS.hasCollLeisure
   paramS.lColl_jV = (xV - mMin) .* paramS.lCollMax ./ (mMax - mMin);
else
   paramS.lColl_jV = zeros(cS.nTypes, 1);
end



%% For now: everyone gets the same college earnings
paramS.wColl_jV = ones([cS.nTypes, 1]) * paramS.wCollMean;
if cS.dbg > 10
   validateattributes(paramS.wColl_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'positive', 'size', [cS.nTypes, 1]})
end


%% Parental income classes
endowS.ypClass_jV = distrib_lh.class_assign(paramS.yParent_jV, paramS.prob_jV, cS.ypUbV, cS.dbg);
if cS.dbg > 10
   validateattributes(endowS.ypClass_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      'positive', '<=', length(cS.ypUbV)})
end


%% IQ classes

endowS.iqClass_jV = distrib_lh.class_assign(endowS.iq_jV, paramS.prob_jV, cS.iqUbV, cS.dbg);
if cS.dbg > 10
   validateattributes(endowS.iqClass_jV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      'positive', '<=', length(cS.iqUbV)})
end

% 
% %  IQ params
% [paramS.prIq_jM, paramS.pr_qjM, paramS.prJ_iqM] = calibr_bc1.iq_param(paramS, cS);
% 


%% Transfers received after start of work
% By age of work start

% Present value of transfers received after start of work as CD: transfer(j) * pvTransferFactor
ageMax = cS.ageLastTransfer;
% After ageLastTransfer: these are 0
endowS.pvTransferFactor_tV = zeros(ageMax + 2, 1);
for age = 1 : ageMax
   endowS.pvTransferFactor_tV(age) = (paramS.R ^ age)  .*  econ_lh.geo_sum(1 / paramS.R,  age,  cS.ageLastTransfer);
end


paramS.endowS = endowS;

end