function fit(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
outS = var_load_bc1(cS.vCalResults, cS);
aggrS = var_load_bc1(cS.vAggregates, cS);
paramS = var_load_bc1(cS.vParams, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);
nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);


%% Lifetime earnings
if 1
   dataV = log(paramS.earnS.tgPvEarn_sV);
   modelV = aggrS.pvEarnMeanLog_sV;
   fh = output_bc1.fig_new(saveFigures, []);
   bar([modelV(:), dataV(:)] - dataV(cS.iHSG));
   ylabel('Log lifetime earnings');
   legend({'Model', 'Data'}, 'location', 'southoutside', 'orientation', 'horizontal');
   output_bc1.fig_format(fh, 'bar');
   output_bc1.fig_save(fullfile(cS.fitDir, 'log_lty'), saveFigures, cS);
   %return;
end


%% School fractions
if 1
   ds = outS.devV.dev_by_name('frac s');
   fh = output_bc1.fig_new(saveFigures, []);
   bar([ds.modelV(:), ds.dataV(:)]);
   ylabel('Fraction');
   legend({'Model', 'Data'}, 'location', 'southoutside', 'orientation', 'horizontal');
   figures_lh.axis_range_lh([NaN, NaN, 0, 1]);
   output_bc1.fig_format(fh, 'bar');
   output_bc1.fig_save(fullfile(cS.fitDir, 'school_fractions'), saveFigures, cS);
end


%% School fractions by IQ or yp
if 1
   % Plot by IQ or yp
   for iPlot = 1 : 2
      if iPlot == 1
         % Is this a target?
         isTarget = cS.tgS.tgFrac_sq;
         data_sxM = tgS.schoolS.frac_sqcM(:,:,cS.iCohort);
         model_sxM = aggrS.sqS.mass_sqM;
         xStr = cS.formatS.iqGroupStr;
         suffixStr = cS.formatS.iqSuffixStr;
      elseif iPlot == 2
         isTarget = cS.tgS.tgFrac_sy;
         data_sxM = tgS.schoolS.frac_sycM(:,:,cS.iCohort);
         model_sxM = aggrS.syS.mass_syM;         
         xStr = cS.formatS.ypGroupStr;
         suffixStr = cS.formatS.ypSuffixStr;
      end
      % Mass should sum to 1
      model_sxM = model_sxM ./ sum(model_sxM(:));
      
      % Are there data?
      if isTarget  &&  any(~isnan(data_sxM(:)))
         fh = output_bc1.fig_new(saveFigures, figS.figOpt4S);
         
         for iSchool = 1 : cS.nSchool
            % Are there data for this school group?
            if ~isnan(data_sxM(iSchool,1))
               subplot(2,2,iSchool);
               bar([model_sxM(iSchool,:)',  data_sxM(iSchool, :)']);
               xlabel(xStr);
               ylabel(['Fraction ', cS.sLabelV{iSchool}]);
               figures_lh.axis_range_lh([NaN, NaN, 0, 1]);
               output_bc1.fig_format(fh, 'bar');
            end
         end
         
         output_bc1.fig_save(fullfile(cS.fitDir, ['school_fractions', suffixStr]), saveFigures, cS);
      end
   end
end




%% Targets by IQ or yp
if 1
   % What can be on the x axis
   xIq = 1;
   xYp = 2;
   xStrV = {cS.formatS.iqGroupStr, cS.formatS.ypGroupStr};
   xValueV = {1 : nIq,  1 : nYp};
   prefixStrV = {'iq_',  'yp_'};
   
   % Names match cal_dev names
   nameV = {'enter/iq',    'grad/iq',    'enter/yp',    'grad/yp',  'yp/iq',  ...
      'yp/yp',  'hours/yp',  'hours/iq',  'earn/yp',  'earn/iq', ...
      'debtFracGradsIq',  'debtFracGradsYp',  'debtMeanGradsIq',  'debtMeanGradsYp', ...
      'z/yp', 'z/iq',  'hsg/yp',  'hsg/iq'};
   xTypeV = [xIq, xIq, xYp, xYp, xIq,     xYp, xYp, xIq, xYp, xIq, ...
      xIq, xYp,  xIq, xYp,    xYp, xIq, xYp, xIq];
   yStrV = {'Fraction entering college',  'Fraction graduating from college', ...
      'Fraction entering college',  'Fraction graduating from college',  'Parental income',  ...
      'Parental income',  'Hours worked',  'Hours worked',  'Earnings',  'Earnings', ...
      'Fraction with debt', 'Fraction with debt',  'Mean debt', 'Mean debt', ...
      'Transfers', 'Transfers', 'Prob HSG', 'Prob HSG'};
   figFnV = {'enter',   'grad',    'enter',    'grad',   'transfer',  ...
      'yp',  'hours',  'hours',  'earn',  'earn', ...
      'debtfrac', 'debtfrac',  'debtmean', 'debtmean', ...
      'transfer', 'transfer', 'prob_hsg', 'prob_hsg'};
   % y axis range
   yMinV = [0, 0, 0, 0, 0,       0, 0, 0, 0, 0,    0, 0, 0, 0,    0, 0, 0, 0];
   yMaxV = [1, 1, 1, 1, NaN,    NaN, NaN, NaN, NaN, NaN,    1, 1, NaN, NaN,      NaN, NaN, 1,1];
   
   for iPlot = 1 : length(nameV)
      ds = outS.devV.dev_by_name(nameV{iPlot});
      
      if ~isempty(ds)
         xType = xTypeV(iPlot);
         
         % Not all cohorts have this target
         fh = output_bc1.fig_new(saveFigures, []);
         bar(xValueV{xType}, [ds.modelV(:), ds.dataV(:)]);
         xlabel(xStrV{xType});
         ylabel(yStrV{iPlot});
         legend({'Model', 'Data'}, 'location', 'northwest');
         figures_lh.axis_range_lh([NaN, NaN, yMinV(iPlot), yMaxV(iPlot)]);
         output_bc1.fig_format(fh, 'bar');
         output_bc1.fig_save(fullfile(cS.fitDir, [prefixStrV{xType}, figFnV{iPlot}]), saveFigures, cS);
      end
   end
end



end