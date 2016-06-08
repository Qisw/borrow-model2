function fit_qy(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
% figS = const_fig_bc1;
outS = var_load_bc1(cS.vCalResults, cS);
aggrS = var_load_bc1(cS.vAggregates, cS);
% paramS = var_load_bc1(cS.vParams, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);
% nIq = length(cS.iqUbV);
% nYp = length(cS.ypUbV);


% Fit by [q, y]
% Each figure is "flattened" into 2 figures with 4 subplots
if 1
   ds = outS.devV.dev_by_name('mass qy');
   if ~isempty(ds)
      [fhIq, fhYp, fhIqV, fhYpV] = output_bc1.fit_qy(ds.modelV, ds.dataV, 'Fraction', saveFigures, cS);

%       figure(fhIq);
      set(0, 'CurrentFigure', fhIq)
      output_bc1.fig_save(fullfile(cS.fitDir, 'qy_mass_byIq'), saveFigures, cS);
      set(0, 'CurrentFigure', fhYp)
%       figure(fhYp);
      output_bc1.fig_save(fullfile(cS.fitDir, 'qy_mass_byYp'), saveFigures, cS);
   end
end


%% Fraction HSG+ (universe: HSG)
if cS.tgS.tgHsgFracHsgPlus_qy
   model_qyM = aggrS.qyUniverseHsgS.massHsgPlus_qyM;
   data_qyM = tgS.schoolS.hsgS.massHsgPlus_qycM(:,:,cS.iCohort);
   
   if any(~isnan(data_qyM(:)))
      [fhIq, fhYp, fhIqV, fhYpV] = output_bc1.fit_qy(model_qyM ./ sum(model_qyM(:)), data_qyM ./ sum(data_qyM(:)), ...
         'Fraction HSG+', saveFigures, cS);

%       figure(fhIq);
      set(0, 'CurrentFigure', fhIq)
      output_bc1.fig_save(fullfile(cS.fitDir, 'hsg_massHsgPlus_qy_byIq'), saveFigures, cS);
%       figure(fhYp);
      set(0, 'CurrentFigure', fhYp)
      output_bc1.fig_save(fullfile(cS.fitDir, 'hsg_massHsgPlus_qy_byYp'), saveFigures, cS);
   end
end


%% Fraction enter | q,y  (universe: HSG)
if cS.tgS.tgHsgCollegeQy
   data_qyM = tgS.schoolS.hsgS.fracEnter_qycM(:,:,cS.iCohort);
   model_qyM = aggrS.qyUniverseHsgS.fracEnter_qyM;

   if any(~isnan(data_qyM(:)))
      [fhIq, fhYp, fhIqV, fhYpV] = output_bc1.fit_qy(model_qyM ./ sum(model_qyM(:)), data_qyM ./ sum(data_qyM(:)), ...
         'Fraction entering college', saveFigures, cS);

%       figure(fhIq);
      set(0, 'CurrentFigure', fhIq)
      output_bc1.fig_save(fullfile(cS.fitDir, 'hsg_fracEnter_qy_byIq'), saveFigures, cS);
%       figure(fhYp);
      set(0, 'CurrentFigure', fhYp)
      output_bc1.fig_save(fullfile(cS.fitDir, 'hsg_fracEnter_qy_byYp'), saveFigures, cS);
   end
end

end