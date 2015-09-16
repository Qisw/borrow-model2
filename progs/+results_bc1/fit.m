function fit(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
outS = var_load_bc1(cS.vCalResults, cS);
nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);


%% School fractions
if 1
   ds = outS.devV.dev_by_name('frac s');
   fh = output_bc1.fig_new(saveFigures, []);
   bar([ds.modelV(:), ds.dataV(:)]);
   xlabel(cS.sLabelV)
   ylabel('Fraction');
   legend({'Model', 'Data'}, 'location', 'southoutside', 'orientation', 'horizontal');
   figures_lh.axis_range_lh([NaN, NaN, 0, 1]);
   output_bc1.fig_format(fh, 'bar');
   output_bc1.fig_save(fullfile(cS.fitDir, 'school_fractions'), saveFigures, cS);
end


%% Fit by [q, y]
% Each figure is "flattened" into 2 figures with 4 subplots
if 1
   ds = outS.devV.dev_by_name('mass qy');
   [fhIq, fhYp, fhIqV, fhYpV] = output_bc1.fit_qy(ds.modelV, ds.dataV, 'Fraction', saveFigures, cS);
   
   figure(fhIq);
   output_bc1.fig_save(fullfile(cS.fitDir, 'qy_mass_byIq'), saveFigures, cS);
   figure(fhYp);
   output_bc1.fig_save(fullfile(cS.fitDir, 'qy_mass_byYp'), saveFigures, cS);
end


%% Prob enter college | IQ  /  prob grad | IQ  /   also by yp
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