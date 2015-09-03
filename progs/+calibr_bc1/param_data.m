function dataS = param_data(cS)

% Use weighted regressions for betaIq, betaYp?
dataS.regrIqYpWeighted = true;

% Computing cohort schooling from CPS
% Use this age range
dataS.cohSchoolAgeRangeV = [25, 50];

% Use median earnings to construct profiles
dataS.useMedianForProfiles = true;

% Assign each cohort college costs for this age
dataS.collCostAge = 20;

end