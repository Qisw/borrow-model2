function outS = symbols
% Return struct with latex strings for symbols
%{
To make notation consistent
Each field name must be a valid latex command!
%}


%% Demographics

nameV = {'age',   'ageMax'};
symbolV = {'a',   'A'};

outS = SymbolTableLH(nameV, symbolV);



%% Endowments

% Free consumption / leisure in college: cColl, lColl

nameV = {'hhType',   'ability',     'famIncome',   'cColl',    'lColl',    'IQ',    'collCost',    'abilSignal', ...
   'nTypes',  'meanEndow', 'stdEndow'};
symbolV = {'j',      'x',           'y_{p}',       '\bar{c}',  '\bar{l}',  'IQ',    '\tau',        'm', ...
   'J',  '\mu', '\sigma'};

outS = outS.add(nameV, symbolV);


%% Work

% Skill prices (so to speak): pvEarnSchool

nameV = {'pvEarn',   'pvEarnSchool'};
symbolV = {'Y',      '\bar{Y}'};

outS = outS.add(nameV, symbolV);


%% College 

nameV    = {'prGradParam',    'tSchool',  'collLength',  'prefShockEntry',    'pTransfer',      'collegeWage'};
symbolV  = {'\pi',            'A_{s}',    'A_{CG}',      '\eta',              'z',              'w_{coll}'};

outS = outS.add(nameV, symbolV);

% Prob of continuing after year 2 in college; probContinue
% Prob of graduating after 4 years (versus 5): probGradFour
nameV    = {'valueEntry',  'probContinue',   'probGradFour'};
symbolV  = {'V_{1}',       '\pi',            '\pi_{4}'};

outS = outS.add(nameV, symbolV);

% Beliefs after learning that student does not drop out after year 2
outS = outS.add('prAbilGrad',  '\Pr(x|j,CG)');



%% Other

% Prob grad HS function
nameV = {'probGradHs'};
symbolV = {'\pi_{HSG}'};

outS = outS.add(nameV, symbolV);


%% Data

nameV = {'betaIq',      'betaYp'};
symbolV = {'\beta_{IQ}',   '\beta_{F}'};

outS = outS.add(nameV, symbolV);



end