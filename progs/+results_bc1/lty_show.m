function lty_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
figS = const_fig_bc1;
paramS = param_load_bc1(setNo, expNo);
outDir = cS.paramDir;



%% 3D plot: pvEarn_sa
% First work start age
if 1
   discFactor_sV = paramS.R .^ (cS.ageWorkStartM(:,1) - cS.age1);
   for iPlot = 1 : 2
      pvEarn_saM = zeros(cS.nSchool, cS.nAbil);
      for iSchool = 1 : cS.nSchool
         pvEarn_saM(iSchool,:) = paramS.earnS.pvEarn_tsaM(cS.ageWorkStartM(iSchool,1), iSchool, :);
      end
      
      if iPlot == 1
         figFn = 'pvearn_sa';
      elseif iPlot == 2
         % Discounted to age 1
         pvEarn_saM = pvEarn_saM ./ (discFactor_sV(:) * ones([1, cS.nAbil]));
         figFn = 'pvearn_age1_sa';
      else
         error('Invalid');
      end
      
      fh = output_bc1.fig_new(saveFigures, []);
      bar3(log(pvEarn_saM) - log(pvEarn_saM(1,1)));
      xlabel('Ability');
      ylabel('Schooling');
      zlabel('Log lifetime earnings');
      colormap(figS.colorMap);
      view([-135, 30]);
      output_bc1.fig_format(fh, 'bar');
      output_bc1.fig_save(fullfile(outDir, figFn), saveFigures, cS);
   end
end


end