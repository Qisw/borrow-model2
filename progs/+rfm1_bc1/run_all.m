function run_all

% Calibrate and save
rfm1_bc1.calibrate;

% Show how not conditionin on IQ affects results
rfm1_bc1.counterfactuals;

end