function outS = solve(conditionOnIq, frac_sV, paramS, cS)
% Solve model given parameters and school fractions
%{
IN
   conditionOnIq :: logical
      does hh condition on IQ when choosing s?
   frac_sV
      target school fractions
%}

n = cS.nEndow;

% Make blank solution object
outS = rfm1_bc1.Solution;


%% Input check
if cS.dbg > 10
   assert(isa(conditionOnIq, 'logical'));
   checkLH.prob_check(frac_sV, 1e-6);
   % Code below assumes that 'a' is first endowment
   assert(isequal(cS.idxA, 1));
end


%% Draw endowments

endowS = rfm1_bc1.Endowments(paramS, cS);
outS.covM = endowS.covM;
randM = endowS.draw_endowments(cS.nSim);

% E(a | info)
outS.eaV = endowS.conditional_distrib_abil(conditionOnIq, randM);

% How much does conditioning on IQ reduce var(a)?
[~, outS.condVarAbil] = endowS.conditional_distrib_abil(true, randM(1,:));
[~, outS.condVarAbilNoIq] = endowS.conditional_distrib_abil(false, randM(1,:));



%% Assign schooling, IQ, yp groups

cumFracSV = cumsum(frac_sV);
cumFracSV(end) = 1;
outS.sClassV = distribLH.class_assign(outS.eaV, [], cumFracSV, cS.dbg);
validateattributes(outS.sClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', cS.nSchool})

outS.yClassV = distribLH.class_assign(randM(:, cS.idxY), [], cS.yClUbV, cS.dbg);
validateattributes(outS.yClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', length(cS.yClUbV)})

outS.qClassV = distribLH.class_assign(randM(:, cS.idxQ), [], cS.qClUbV, cS.dbg);
validateattributes(outS.qClassV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', length(cS.qClUbV)})


%% Aggregates

% Compute frac s,q and frac s,y

outS.frac_sqM = accumarray([outS.sClassV, outS.qClassV], 1) ./ cS.nSim;
outS.frac_syM = accumarray([outS.sClassV, outS.yClassV], 1) ./ cS.nSim;

% Mean q | s
outS.iqMean_sV = accumarray(outS.sClassV, randM(:, cS.idxQ), [cS.nSchool, 1], @mean);
validateattributes(outS.iqMean_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nSchool, 1]})

% Mean y | s
outS.yMean_sV = accumarray(outS.sClassV, randM(:, cS.idxY), [cS.nSchool, 1], @mean);

if cS.dbg > 10
   for iSchool = 1 : cS.nSchool
      sIdxV = find(outS.sClassV == iSchool);
      checkLH.approx_equal(mean(randM(sIdxV, cS.idxQ)), outS.iqMean_sV(iSchool), 1e-5, []);
   end
end

% These are computed like the corresponding calibration targets
[outS.fracHsg_qV, outS.fracEnter_qV] = frac_enter_hsg('q', outS, cS);
[outS.fracHsg_yV, outS.fracEnter_yV] = frac_enter_hsg('y', outS, cS);


%% Self-test

if cS.dbg > 10
   rfm1_bc1.solve_test(outS, frac_sV, paramS, cS);
end


% Diagnostics
if 0
   corrM = corrcoef(outS.eaV, randM(:, cS.idxA));
   fprintf('Corr a, E(a): %.3f \n', corrM(1,2));
   corrM = corrcoef(randM(:, cS.idxQ),  outS.eaV);
   fprintf('Corr q, E(a): %.3f \n', corrM(1,2));
   corrM = corrcoef(randM(:, cS.idxQ),  outS.sClassV);
   fprintf('Corr q, s: %.3f \n', corrM(1,2));
end

end



%% Local: implied stats about schooling given q or y
function [fracHsgV, fracEnterV] = frac_enter_hsg(caseStr, outS, cS)
   switch caseStr
      case 'q'
         % Joint prob object, for easy computation of conditionals
         syS = statsLH.ProbMatrix2D('pr_xyM', outS.frac_sqM);
      case 'y'
         % Joint prob object, for easy computation of conditionals
         syS = statsLH.ProbMatrix2D('pr_xyM', outS.frac_syM);
      otherwise
         error('Invalid');
   end

   % Model: frac enter | y
   fracEnterV = sum(syS.prX_yM(cS.iCD : end, :))';

   % Model: frac hsg or more | y
   fracHsgV = sum(syS.prX_yM(cS.iHSG : end, :))';
end