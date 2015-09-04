function formatS = formatting(cS)

symS = helper_bc1.symbols;


formatS.iqGroupStr = symS.retrieve('IQ');
formatS.ypGroupStr = 'Family background';

formatS.cohortXLabelStr = 'Cohort';



%% IQ labels

iqStr = symS.retrieve('IQ');
nIq = length(cS.iqUbV);
formatS.iqLabelV = cell(nIq, 1);
for iIq = 1 : nIq
   formatS.iqLabelV{iIq} = sprintf('%s quartile %i',  iqStr, iIq);
end



end