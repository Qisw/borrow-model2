function prob_show(saveFigures, setNo, expNo)

if nargin < 2
   expNo = [];
end

cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
paramS = param_load_bc1(setNo, expNo);
aggrS = var_load_bc1(cS.vAggregates, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);
% iCohort = cS.iCohort; 

massGrad_qyM = squeeze(aggrS.qyS.mass_sqyM(cS.iCG,:,:));

% By j: prob grad, conditional on entry
prGrad_jV = aggrS.aggr_jS.mass_sjM(cS.iCG, :)' ./ aggrS.aggr_jS.massColl_jV;


%% Entry and Grad Probs by [q, y]
if 1
   for iPlot = 1 : 2
      if iPlot == 1
         model_qyM = aggrS.qyS.massColl_qyM ./ aggrS.qyS.mass_qyM;
         zStr = 'Entry rate';
         fnStr = 'qy_prob_enter';
      elseif iPlot == 2
         model_qyM = massGrad_qyM ./ aggrS.qyS.mass_qyM;
         zStr = 'Graduation rate (unconditional)';
         fnStr = 'qy_prob_grad';
      else
         error('Invalid');
      end

      output_bc1.bar_graph_qy(model_qyM, zStr, saveFigures, cS);
      output_bc1.fig_save(fnStr, saveFigures, cS);

   end
end


%% Compare Entry and Grad Probs by [q, y] with data
if ~isnan(tgS.schoolS.fracGrad_qycM(1,1,cS.iCohort))  &&  1
   for iPlot = 1 : 2
      if iPlot == 1
         data_qyM = tgS.schoolS.fracEnter_qycM(:,:,cS.iCohort);
         model_qyM = aggrS.qyS.massColl_qyM ./ aggrS.qyS.mass_qyM;
         zStr = 'Entry rate';
         fnStr = 'qy_prob_enter';
      elseif iPlot == 2
         data_qyM = tgS.schoolS.fracGrad_qycM(:,:,cS.iCohort);
         model_qyM = massGrad_qyM ./ aggrS.qyS.mass_qyM;
         zStr = 'Graduation rate (unconditional)';
         fnStr = 'qy_prob_grad';
      else
         error('Invalid');
      end
      
      % One subplot per yp quartile
      fh = output_bc1.fig_new(saveFigures, figS.figOpt4S);
      for iy = 1 : length(cS.ypUbV)
         subplot(2,2,iy);
         bar([model_qyM(:,iy), data_qyM(:,iy)], 'grouped');   
         figures_lh.axis_range_lh([NaN, NaN, 0, 1]);
         xlabel('IQ quartile');  
         zlabel(zStr);
         if iy == 1
            legend({'Model', 'Data'});
         end
         colormap(figS.colorMap);
         output_bc1.fig_format(fh, 'bar');
      end
      
      output_bc1.fig_save(fullfile(cS.fitDir, fnStr), saveFigures, cS);
      
      
      % The same with IQ subplots
      fh = output_bc1.fig_new(saveFigures, figS.figOpt4S);
      for iIq = 1 : length(cS.iqUbV)
         subplot(2,2,iIq);
         bar([model_qyM(iIq,:)', data_qyM(iIq,:)'], 'grouped');      
         figures_lh.axis_range_lh([NaN, NaN, 0, 1]);
         xlabel('yp quartile');  
         zlabel(zStr);
         if iy == 1
            legend({'Model', 'Data'});
         end
         colormap(figS.colorMap);
         output_bc1.fig_format(fh, 'bar');
      end
      output_bc1.fig_save(fullfile(cS.fitDir, [fnStr, '_byIq']), saveFigures, cS);
   end
end


%% Prob grad | j
if 1
   % Sort types by prob grad (conditional on entry)
   sortM = sortrows([prGrad_jV, aggrS.aggr_jS.mass_jV]);
   
   fh = output_bc1.fig_new(saveFigures, []);
   plot(cumsum(sortM(:,2)), sortM(:,1), 'o', 'color', figS.colorM(1,:));
   xlabel('Signal percentile');
   ylabel('Graduation probability');
   figures_lh.axis_range_lh([NaN NaN 0 1]);
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.paramDir, 'prob_grad_j'), saveFigures, cS);
end


%% Prob grad | a
if 1
   fh = output_bc1.fig_new(saveFigures, []);
   plot(cumsum(paramS.prob_aV), paramS.prGrad_aV, figS.lineStyleV{1});
   xlabel('Ability percentile');
   ylabel('Graduation probability');
   figures_lh.axis_range_lh([NaN NaN 0 1]);
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.paramDir, 'prob_grad_a'), saveFigures, cS);
end




end