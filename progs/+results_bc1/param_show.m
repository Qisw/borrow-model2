function param_show(saveFigures, setNo, expNo)
%{
Checked: 2015-Sep-1
%}


cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
paramS = param_load_bc1(setNo, expNo);
% aggrS = var_load_bc1(cS.vAggregates, cS);
% tgS = var_load_bc1(cS.vCalTargets, cS);
% iCohort = cS.iCohort; 
nIq = length(cS.iqUbV);
outDir = cS.paramDir;

% Mean ability by m
mean_abil_j(saveFigures, paramS, cS);


%% Return to schooling by ability
% Assuming first year of work start for all s
if 1
   % Discount lifetime earnings to age 1
   pvEarn_saM = zeros(cS.nSchool,cS.nAbil);
   for iSchool = 1 : cS.nSchool
      tStart = cS.ageWorkStartM(iSchool,1);
      discFactor = paramS.R .^ (tStart - 1);
      pvEarn_saM(iSchool,:) = squeeze(paramS.pvEarn_tsaM(tStart,iSchool,:)) ./ discFactor;
   end
   
   % Log pv earn difference by [a,s]
   dLogPv_saM = log(pvEarn_saM) - ones(cS.nSchool, 1) * log(pvEarn_saM(cS.iHSG, :));
   validateattributes(dLogPv_saM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nSchool, cS.nAbil]});

   fh = results_bc1.plot_by_abil(dLogPv_saM', saveFigures, cS);   
   ylabel('Log lifetime earnings gap');
   legend(cS.sLabelV, 'location', 'southoutside', 'orientation', 'horizontal');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(outDir, 'lty_return_a'), saveFigures, cS);
end




%%  Plot(pr(iq | j))
if 1
   fh = results_bc1.plot_by_m(paramS.prIq_jM', saveFigures, cS);
   ylabel('Pr(IQ | m)');
   legend(cS.formatS.iqLabelV, 'location', 'north');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(outDir, 'endow_pr_iq_m'), saveFigures, cS);
end



%% Distribution of endowments (joint)
if 1
   for iPlot = 1 : 3
      if iPlot == 1
         % m / yp
         xV = paramS.m_jV;
         xStr = 'Ability signal';
         yV = log(paramS.yParent_jV);
         yStr = 'Log yParent';
         wtV = paramS.prob_jV;
         figName = 'endow_yp_m';
      elseif iPlot == 2
         % m / p
         xV = paramS.m_jV;
         xStr = 'Ability signal';
         yV = paramS.pColl_jV;
         yStr = 'College cost';
         wtV = paramS.prob_jV;
         figName = 'endow_p_m';
      elseif iPlot == 3
         % yp / p
         xV = log(paramS.yParent_jV);
         xStr = 'Log yParent';
         yV = paramS.pColl_jV;
         yStr = 'College cost';
         wtV = paramS.prob_jV;
         figName = 'endow_p_yp';
      else
         error('Invalid');
      end
      
      [~, corrCoeff] = distrib_lh.cov_w(xV, yV, wtV, cS.missVal, cS.dbg);
      
      fh = output_bc1.fig_new(saveFigures, []);
      plot(xV, yV, 'o', 'color', figS.colorM(1,:));
      xlabel(xStr);
      ylabel(yStr);
      text(0.1, 0.1, sprintf('Correlation %.2f', corrCoeff), 'Units', 'normalized');
      output_bc1.fig_format(fh, 'line');
      output_bc1.fig_save(fullfile(outDir, figName), saveFigures, cS);
   end
end



end


%% E(a|j)
function mean_abil_j(saveFigures, paramS, cS)
   figS = const_fig_bc1;
   
   % Compute E(a | j)
   meanA_jV = nan([cS.nTypes, 1]);
   for j = 1 : cS.nTypes
      meanA_jV(j) = sum(paramS.prob_a_jM(:, j) .* paramS.abilGrid_aV);
   end
   
   fh = output_bc1.fig_new(saveFigures, []);
   hold on
   plot(paramS.m_jV,  meanA_jV, 'o', 'color', figS.colorM(1,:));
   plot([-2,2], [-2,2], 'k-');
   hold off;
   xlabel('m');
   ylabel('E(a|j)');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.paramDir, 'endow_eOfa_j'), saveFigures, cS);
end