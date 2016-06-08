function college_plots(saveFigures, setNo)

cS = const_bc1(setNo);
tgS = var_load_bc1(cS.vCalTargets, cS);
nq = length(cS.iqUbV);
ny = length(cS.ypUbV);


for iCohort = 1 : cS.nCohorts
   frac_sqyM = tgS.schoolS.frac_sqycM(:,:,:,iCohort);
   if all(frac_sqyM(:) >= 0)
      frac_qyM = squeeze(sum(frac_sqyM, 1));
      % Make data matrix by [q, y]
      for iPlot = 1 : 2
         if iPlot == 1
            % Fraction entering college (unconditional)
            data_qyM = squeeze(sum(frac_sqyM(cS.iCD : end, :,:))) ./ frac_qyM;
            zStr = 'Fraction college';
            figFn = 'qy_frac_college';
         elseif iPlot == 2
            % Fraction graduating (unconditional)
            data_qyM = squeeze(frac_sqyM(cS.iCG, :,:)) ./ frac_qyM;
            zStr = 'Fraction CG';
            figFn = 'qy_frac_cg';
         else
            error('Invalid');
         end
         
         validateattributes(data_qyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
            '<=', 1, 'size', [nq, ny]})
         
         output_bc1.bar_graph_qy(data_qyM, zStr, saveFigures, cS);
         output_bc1.fig_save(fullfile(cS.dirS.dataOutDir, [figFn, '_', cS.cohortS.shortDescrV{iCohort}]), saveFigures, cS);
      end
   end
end


end