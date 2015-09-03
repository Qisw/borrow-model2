function median_wage_show(saveFigures, setNo)

cS = const_bc1(setNo);
figS = const_fig_bc1;

cpsS = const_cpsbc(cS.cpsSetNo);
loadS = var_load_cpsbc(cpsS.vAggrStats, [], cS.cpsSetNo);
idxV = find(loadS.medianWage_tV > 0);

yearV = cpsS.yearV;
refYrIdx = find(yearV == 2000);

[outV, outRealV] = data_bc1.detrending_factors(yearV, setNo);


fh = output_bc1.fig_new(saveFigures);
hold on;

iLine = 1;
yV = log(loadS.medianWage_tV);
yV = yV - yV(refYrIdx);
plot(yearV(idxV),  yV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));

iLine = iLine + 1;
yV = loadS.meanLogWage_tV;
yV = yV - yV(refYrIdx);
plot(yearV(idxV),  yV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));

iLine = iLine + 1;
yV = log(outRealV);
yV = yV - yV(refYrIdx);
plot(yearV(idxV),  yV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));

hold off;
xlabel('Year');
ylabel('Constant dollars');
legend({'CPS median wage',  'CPS mean log wage',  'Log disposable income'}, 'location', 'southeast');
output_bc1.fig_format(fh, 'line');
output_bc1.fig_save(fullfile(cS.dataOutDir, 'detrending_factors'), saveFigures, cS);


end