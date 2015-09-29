function syS = aggr_syj(aggrS, hhS, paramS, cS)
% Aggregates:  By [school, y, j]
%{
Essentially the same code as by [s, q, j]
   Should avoid that repetition +++

Checked: 2015-Aug-25
%}

frac_yV = diff([0; cS.ypUbV]);
nYp = length(cS.ypUbV);

% Mass by [s y] = sum over all j in yp class
syS.mass_syM = zeros([cS.nSchool, nYp]);
for iYp = 1 : nYp
   jIdxV = find(paramS.endowS.ypClass_jV == iYp);
   syS.mass_syM(:, iYp) = sum(aggrS.aggr_jS.mass_sjM(:, jIdxV), 2);
end


% Fraction s | yp = mass(s,y) / mass(y)
syS.fracS_yM = nan([cS.nSchool, nYp]);
for i1 = 1 : nYp
   syS.fracS_yM(:,i1) = syS.mass_syM(:,i1) ./ sum(syS.mass_syM(:,i1));
end

syS.massEnter_yV = sum(syS.mass_syM(cS.iCD : cS.nSchool, :), 1);
syS.massEnter_yV = syS.massEnter_yV(:);

syS.massHsgPlus_yV = sum(syS.mass_syM(cS.iHSG : cS.nSchool, :), 1);
syS.massHsgPlus_yV = syS.massHsgPlus_yV(:);

% Fractions conditional on HSG
syS.fracEnter_yV = syS.massEnter_yV ./ syS.massHsgPlus_yV;
syS.fracGrad_yV  = syS.mass_syM(cS.iCG, :)' ./ syS.massHsgPlus_yV;

   

   
%% Self test   
if cS.dbg > 10
   validateattributes(syS.mass_syM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, 'size', [cS.nSchool, nYp]})
   validateattributes(syS.fracS_yM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nSchool, nYp], 'positive', '<', 1})
   % Mass(s,q) should sum to mass by yp
   sumV = sum(syS.mass_syM);
   if any(abs(sumV(:) ./ aggrS.totalMass - frac_yV) > 5e-3)    % why so imprecise? +++
      error('Invalid');
   end
end

end