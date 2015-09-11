function aggr_show(saveFigures, setNo, expNo)

cS = const_bc1(setNo, expNo);
% figS = const_fig_bc1;
paramS = param_load_bc1(setNo, expNo);
% hhS = var_load_bc1(cS.vHhSolution, cS);
aggrS = var_load_bc1(cS.vAggregates, cS);
tgS = var_load_bc1(cS.vCalTargets, cS);

outFn = fullfile(cS.outDir, 'aggr_stats.txt');
fp = fopen(outFn, 'w');

fprintf(fp, '\nAggregate statistics\n');

school_stats(fp, aggrS, paramS, cS);
financial_stats(fp, aggrS, cS);


%% BetaIq, betaYp
if 1
   mBetaIq = aggrS.qyS.betaIq;
   mBetaYp = aggrS.qyS.betaYp;

   fmtStr = '  betaIq: %5.2f    betaYp: %5.2f \n';
   fprintf(fp, 'Model:  ');
   fprintf(fp, fmtStr, mBetaIq, mBetaYp);
   fprintf(fp, 'Data:   ');
   fprintf(fp, fmtStr, tgS.schoolS.betaIq_cV(cS.iCohort), tgS.schoolS.betaYp_cV(cS.iCohort));
end


fclose(fp);
type(outFn);

end

% ---------------- end of main function


%% Stats by schooling
function school_stats(fp, aggrS, paramS, cS)
   statS = var_load_bc1(cS.vAggrStats, cS);
   fprintf(fp, '\nStats by schooling\n');
   
   fprintf(fp, 'E{a | s}:  ');
   fprintf(fp, '%.2f   ',  statS.abilMean_sV);
   fprintf(fp, '\n');
   
   fprintf(fp, 'Mean log lifetime earnings, discounted to work start: \n');
   fprintf(fp, '    %.2f',  aggrS.pvEarnMeanLog_sV);
   fprintf(fp, '\n');
   fprintf(fp, '    fixed(s):  ');
   fprintf(fp, '%.2f  ',  log(paramS.earnS.tgPvEarn_sV(cS.iHSG)) + paramS.earnS.eHat_sV);
   fprintf(fp, '\n');
   fprintf(fp, '    ability part(s):  ');
   fprintf(fp, '%.2f  ',  paramS.earnS.phi_sV .* (statS.abilMean_sV - paramS.earnS.aBar));
   fprintf(fp, '\n');
end


%% Financial stats
function financial_stats(fp, aggrS, cS)
   fprintf(fp, '\nFinancial stats\n');
   fprintf(fp, '  Fraction of spending paid by earnings: %.2f   debt: %.2f   transfers: %.2f \n', ...
      aggrS.entrantYear2S.fracEarnings, aggrS.entrantYear2S.fracDebt, aggrS.entrantYear2S.fracTransfers);
end


