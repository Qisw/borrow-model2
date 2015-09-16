function int_qyM = interpolate_qy_matrix(m_qyM, iqUbV, ypUbV, forMidPoints, cS)
% Interpolate a matrix by [q,y] to match common group bounds
%{ 
IN:
   forMidPoints :: bool
      true: Assume that m_qyM applies to the interval midpoints
         This is for things like graduation rates
      false: Assume to m_qyM applies to interval upper bounds
         This is for school fractions
%}

%% Make an interpolation object for the data

if forMidPoints
   % Midpoints
   qMidV = vector_lh.midpoints([0; iqUbV(:)]);
   yMidV = vector_lh.midpoints([0; ypUbV(:)]);
else
   qMidV = iqUbV(:);
   yMidV = ypUbV(:);
end

yp_qyM = ones(length(qMidV),1) * yMidV';
iq_qyM = qMidV * ones(1, length(yMidV));
% Change: interpolation for values outside the grid in the data +++
intS = scatteredInterpolant(iq_qyM(:),  yp_qyM(:),  m_qyM(:), 'linear', 'nearest');


%% Interpolate to desired interval midpoints

if forMidPoints
   % Make midpoints for the desired [iq, yp] ranges
   q2MidV = vector_lh.midpoints([0; cS.iqUbV(:)]);
   y2MidV = vector_lh.midpoints([0; cS.ypUbV(:)]);
else
   q2MidV = cS.iqUbV;
   y2MidV = cS.ypUbV;
end

% Interpolate to the new midpoints
yp2_qyM = ones([length(q2MidV), 1]) * y2MidV';
iq2_qyM = q2MidV * ones([1, length(y2MidV)]);

int_qyM = intS([iq2_qyM(:), yp2_qyM(:)]);
int_qyM = reshape(int_qyM, size(iq2_qyM));

validateattributes(int_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [length(cS.iqUbV),  length(cS.ypUbV)]})


end

