% Financing shares
function finShareS = finshare_tg(cS)
   % Read data
   % Each row is a study. We pick some out by hand
   tbM = readtable(fullfile(cS.dataDir, 'percent_from_source.xlsx'));
   
   % Get fields that could be Nan
   savingV = tbM.Savings;
   savingV(isnan(savingV)) = 0;
   grantV = tbM.Scholarships;
   grantV(isnan(grantV)) = 0;
   vetV = tbM.Veterans_Vocational;
   vetV(isnan(vetV)) = 0;
   loanV = tbM.Loans;
   loanV(isnan(loanV)) = 0;
   % Other will be split between family and work
   otherV = tbM.Other;
   otherV(isnan(otherV)) = 0;
   
   % Family includes savings
   familyV = tbM.Family + savingV + 0.5 * otherV;
   earnV = tbM.StudentWork + 0.5 * otherV;
   
   % Total subtracts scholarships and vet funding
   totalV = 100 - grantV - vetV;
   
   finShareS.familyShare_cV = nan([cS.nCohorts, 1]);
   finShareS.workShare_cV = nan([cS.nCohorts, 1]);
   finShareS.loanShare_cV = nan([cS.nCohorts, 1]);
   
   for iCohort = 1 : cS.nCohorts
      % Which study for this cohort?
      bYear = cS.bYearV(iCohort);
      if bYear <= 1950
         % Hollis for all of those
         iRow = find(strncmp(tbM.Study, 'Hollis', 6));
         if length(iRow) ~= 1
            error('Study not found');
         end
         
         validateattributes(totalV(iRow), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
            '>', 80, '<=', 100})
         
         finShareS.familyShare_cV(iCohort) = familyV(iRow) / totalV(iRow);
         validateattributes(finShareS.familyShare_cV(iCohort), {'double'}, ...
            {'finite', 'nonnan', 'nonempty', 'real', '>', 0.20, '<', 1})
         finShareS.workShare_cV(iCohort) = earnV(iRow) / totalV(iRow);
         validateattributes(finShareS.workShare_cV(iCohort), {'double'}, ...
            {'finite', 'nonnan', 'nonempty', 'real', '>', 0.05, '<', 0.80})
         finShareS.loanShare_cV(iCohort) = loanV(iRow) / totalV(iRow);
      end
   end
end