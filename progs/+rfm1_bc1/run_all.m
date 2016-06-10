function run_all

saveFigures = 1;

% Preparation
rfm1_bc1.prep;

% Calibrate and save
rfm1_bc1.calibrate;

% Show model fit
rfm1_bc1.show_fit('base', saveFigures);
rfm1_bc1.show_fit('early', saveFigures);

% Show parameters
rfm1_bc1.show_params;

% Show how not conditionin on IQ affects results
rfm1_bc1.counterfactuals;

end