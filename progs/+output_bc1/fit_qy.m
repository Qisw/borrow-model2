function [fhIq, fhYp, fhIqV, fhYpV] = fit_qy(model_qyM, data_qyM, zStr, saveFigures, cS)
% Show a bar graph by [IQ, yp] quartile

nIq = length(cS.iqUbV);
nYp = length(cS.ypUbV);
figS = const_fig_bc1;


% Figure by IQ

fhIq = output_bc1.fig_new(saveFigures, figS.figOpt4S);
fhIqV = zeros(nIq, 1);

for iIq = 1 : nIq
   fhIqV(iIq) = subplot(2,2,iIq);
   bar([model_qyM(iIq,:)', data_qyM(iIq,:)'])
   xlabel('Parental income quartile');
   ylabel(zStr);
   output_bc1.fig_format(fhIq, 'bar');   
end


% Figure by Yp

fhYp = output_bc1.fig_new(saveFigures, figS.figOpt4S);
fhYpV = zeros(nYp, 1);

for iYp = 1 : nYp
   fhYpV(iYp) = subplot(2,2,iYp);
   bar([model_qyM(:, iYp), data_qyM(:, iYp)])
   xlabel('IQ quartile');
   ylabel(zStr);
   output_bc1.fig_format(fhYp, 'bar');   
end


end