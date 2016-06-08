function plots(saveFigures, setNo)

cS = const_bc1(setNo);
figS = const_fig_bc1;


%% CPI
if 1
   cpiS = econ_lh.CpiLH(cS.cpiBaseYear);
   fh = output_bc1.fig_new(saveFigures, []);
   yearV = 1900 : 2020;
   cpiV = cpiS.retrieve(yearV);
   idxV = find(~isnan(cpiV));
   plot(yearV(idxV), cpiV(idxV), figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   xlabel('Year');
   ylabel('CPI');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'cpi_year'), saveFigures, cS);   
end

%% Detrending factors for real variables
if 1
   yearV = 1900 : 2020;
   [~, detrendV] = data_bc1.detrending_factors(yearV, setNo);
   idxV = find(~isnan(detrendV));

   fh = output_bc1.fig_new(saveFigures, []);
   plot(yearV(idxV), detrendV(idxV), figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   xlabel('Year');
   ylabel('Detrending factors for real variables');
   output_bc1.fig_format(fh, 'line');
   output_bc1.fig_save(fullfile(cS.dataOutDir, 'detrend_real'), saveFigures, cS);   
   
end


end