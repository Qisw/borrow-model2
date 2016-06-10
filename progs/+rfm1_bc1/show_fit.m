function show_fit(cohortStr, saveFigures)
% Show fit: One cohort
%{
No test
%}

cS = rfm1_bc1.Const;
nq = length(cS.qClUbV);
ny = length(cS.yClUbV);

c0S = const_bc1(cS.setNo, cS.expNo);
tgS = var_load_bc1(c0S.vCalTargets, c0S);
% frac_sV = tgS.schoolS.frac_scM(:, cS.iCohort);

% paramS = var_load_bc1(c0S.vRfmParameters, c0S);
calResultS = var_load_bc1(c0S.vRfmSolution, c0S);

switch cohortStr
   case 'base'
      iCohort = cS.iCohort;
      outS = calResultS.solBaseS;
   case 'early'
      iCohort = cS.iCohortEarly;
      outS = calResultS.solEarlyS;
   otherwise 
      error('Invalid');
end



%% frac s|q, s|y

for caseStr = 'qy'
   switch caseStr
      case 'q'
         n = nq;
         model_sqM = outS.frac_sqM;
         data_sqM = tgS.schoolS.frac_sqcM(:,:,iCohort);
      case 'y'
         n = ny;
         model_sqM = outS.frac_syM;
         data_sqM = tgS.schoolS.frac_sycM(:,:,iCohort);
      otherwise
         error('Invalid');
   end
   
   if all(~isnan(data_sqM(:)))
      fS = FigureLH('visible', ~saveFigures, 'figType', 'bar');
      fS.new;

      for iq = 1 : n
         subplot(2,2,iq);
         bar([model_sqM(:,iq), data_sqM(:,iq)]);
         xlabel(sprintf('Schooling  --  %s %i', caseStr, iq));
         ylabel('Fraction');
         fS.format;
      end

      fS.save(fullfile(cS.outDir, ['fit_' cohortStr, '_s', caseStr]), saveFigures);
   end
end


%% Frac HSG or college | q or y
% 4 subplots
% row: by q or y
% col: hsg or college entry fractions

caseStrV = 'qqyy';
varStrV = 'hchc';

fS = FigureLH('visible', ~saveFigures, 'figType', 'bar');
fS.new;

for iSub = 1 : 4
   subplot(2,2,iSub);
   switch caseStrV(iSub)
      case 'q'
         % Mass enter / total mass (given q)
         fracEnter_yV = tgS.schoolS.fracEnter_qcM(:, iCohort);
         % Frac at least HSG (given q)
         fracHsg_yV = tgS.schoolS.fracHsg_qcM(:, iCohort);
         modelEnter_yV = outS.fracEnter_qV;
         modelHsg_yV = outS.fracHsg_qV;
      case 'y'
         fracEnter_yV = tgS.schoolS.fracEnter_ycM(:, iCohort);
         fracHsg_yV = tgS.schoolS.fracHsg_ycM(:, iCohort);
         modelEnter_yV = outS.fracEnter_yV;
         modelHsg_yV = outS.fracHsg_yV;
      otherwise
         error('Invalid');
   end
   
   switch varStrV(iSub)
      case 'h'
         dataM = [modelHsg_yV, fracHsg_yV];
         yLabelStr = 'Fraction HSG+';
      case 'c'
         dataM = [modelEnter_yV, fracEnter_yV];
         yLabelStr = 'Fraction CD+';
      otherwise 
         error('Invalid');
   end
   
   bar(dataM);
   xlabel(sprintf('%s quartile', caseStrV(iSub)));
   ylabel(yLabelStr);
   fS.format;
end

fS.save(fullfile(cS.outDir, ['fit_', cohortStr, '_qy']), saveFigures);


end