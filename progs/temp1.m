function temp1

n = 1e4;
nr = 4;

wtM = rand(nr, nr);
wtM = triu(wtM);
sigmaM = wtM * wtM';

sigmaM

xM = mvnrnd(zeros(1,nr), sigmaM, n);

rIdxV = 1 : (nr-1);
yIdx  = nr;
omitIdx = nr-1;
roIdxV = 1 : (nr-2);

mdl = fitlm(xM(:, rIdxV), xM(:, yIdx));
ypV = feval(mdl, xM(:, rIdxV));
corrM = corrcoef(ypV, xM(:, omitIdx));

% Same omitting one regressor
mdl = fitlm(xM(:, roIdxV), xM(:, yIdx));
ypV = feval(mdl, xM(:, roIdxV));
corr2M = corrcoef(ypV, xM(:, omitIdx));

fprintf('Omitting regressor changes correlation from %.3f to %.3f  (%.3f) \n', ...
   corrM(1,2), corr2M(1,2), abs(corr2M(1,2)) - abs(corrM(1,2)));


end