function temp2

rng(41);
n = 3;
wtM = 2 * randn(n,n);
meanV = linspace(-1, 1, n)';
stdV  = rand(n, 1) * 2;
nObs = 1e6;


% Make lower triangular
for i1 = 1 : (n-1)
   wtM(i1, i1) = 1;
   wtM(i1, (i1+1) : n) = 0;
end
wtM(n,n) = 1;

% Make expected cov matrix
covM = wtM * (wtM');

% Check that cholesky produces wtM
wt2M = chol(covM, 'lower');
check_lh.approx_equal(wtM, wt2M, 1e-6, []);


% Draw random vars
rng(12);
randM = randn(nObs, n);
varM = zeros(nObs, n);
for iVar = 1 : n
   varM(:, iVar) = randM * wtM(iVar,:)';
end

% Check that random variables drawn have correct cov matrix
cov2M = cov(varM);
% Surprisingly large gaps even for large numbers of observations
check_lh.approx_equal(covM, cov2M, 1e-2, []);


% Rescale the variables and check that correlations are unchanged
corrM = corrcoef(varM);

var2M = zeros(size(varM));
for iVar = 1 : n
   var2M(:,iVar) = (varM(:, iVar) - mean(varM(:,iVar))) ./ std(varM(:,iVar)) .* stdV(iVar) + meanV(iVar);
end

check_lh.approx_equal(mean(var2M)', meanV, 1e-5, []);
check_lh.approx_equal(std(var2M)', stdV, 1e-5, []);

corr2M = corrcoef(var2M);
check_lh.approx_equal(corrM, corr2M, 1e-3, []);


% Draw random vars using built in function
rng(121);
var3M = mvnrnd(meanV(:)',  covM,  nObs);
corr3M = corrcoef(var3M);
check_lh.approx_equal(corrM, corr3M, 3e-3, []);

keyboard;

end