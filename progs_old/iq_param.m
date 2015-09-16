function [prIq_jM, pr_qjM, prJ_iqM] = iq_param(paramS, cS)
% Set IQ related derived params
%{
Checked: 2015-Aug-25
%}

error('Not updated');

nIq = length(cS.iqUbV);


% Pr(iq group | j)
prIq_jM = calibr_bc1.pr_xgroup_by_type(paramS.m_jV, ...
   paramS.prob_jV, paramS.sigmaIQ, cS.iqUbV, cS.dbg);

if cS.dbg > 10
   check_bc1.prob_matrix(prIq_jM,  [length(cS.iqUbV), cS.nTypes],  cS);
end


% Compute implied probs using Bayes rule
%  j -> x, IQ -> y
pmS = stats_lh.ProbMatrix2D(prIq_jM, paramS.prob_jV);


% Pr(IQ and j) = Pr(iq | j) * Pr(j)
% pr_qjM = prIq_jM .* (ones([nIq,1]) * paramS.prob_jV(:)');
pr_qjM = pmS.pr_xyM';
prJ_iqM = pmS.prX_yM;

if cS.dbg > 10
   prSum_jV = sum(pr_qjM);
   if any(abs(prSum_jV(:) - paramS.prob_jV) > 1e-4)
      error_bc1('Invalid', cS);
   end
   prSum_qV = sum(pr_qjM, 2);
   if any(abs(prSum_qV(:) - cS.pr_iqV) > 1e-3)  % why so inaccurate?
      error_bc1('Invalid', cS);
   end
end


% Pr(j | IQ) = Pr(j and IQ) / Pr(iq)
% pr_qV = sum(pr_qjM, 2);
% prJ_iqM = pr_qjM' ./ sum(pr_qjM(:)) ./ (ones([cS.nTypes,1]) * pr_qV(:)');

if cS.dbg > 10
   validateattributes(prJ_iqM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [cS.nTypes, nIq]})
   validateattributes(pr_qjM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [nIq, cS.nTypes]})
   
   prSumV = sum(prJ_iqM);
   if any(abs(prSumV - 1) > 1e-3)      % Why so inaccurate? +++
      disp(prSumV);
      error_bc1('Probs do not sum to 1', cS);
   end
end


end