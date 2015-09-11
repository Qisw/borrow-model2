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


%%  Work in college
% Time endowment (hours per year)
% 16 hours per day - study time (Babcock Marks) -> 90 hours per week
% outS.timeEndow = 16 * 365 - 32 * 35.6
dataS.timeEndow = 52 * 84;    % how to set this? +++

% If no data available, set to this many hours per week
%  fairly arbitrary +++
dataS.hoursPerWeekDefault = 20 / 3;


end