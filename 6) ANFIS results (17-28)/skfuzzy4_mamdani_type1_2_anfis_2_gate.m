% Load the CSV file
data = readtable('water_params_analysis_6.csv');  % Automatically handles headers

% Scale inputs as required
wl_scaled = data.Wl * 100;  % scale level
wf_scaled = data.Wf * 10;   % scale flow

% Prepare input matrix
inputs = [wl_scaled, wf_scaled];

% Load the Sugeno-type FIS
fis = readfis('gate_mamdanitype1_2_anfis_2.fis');

% Batch evaluate all rows at once (no loop needed)
outputs = evalfis(fis, inputs);

% Append result as 'vx' column
data.vx = outputs;

% Constants
g = 9.81;       % gravitational acceleration (m/s^2)
h1 = 1.5;       % upstream head (m)
theta = 0.57;   % angle in degrees (assumed fixed)
v2 = 4.378;      % downstream velocity (m/s)
KL = 0.487;     % head loss coefficient

% Use dynamic h1 from evaluation data
data.h1 = data.Wl;  % Wl as h1 in meters

% Compute h2 using Bernoulli equation with energy loss
% h2 = (1/g) * [0.5*v1^2 + g*h1 - ((1 + KL)/2)*v2^2]
v1_sq_half = 0.5 * data.vx.^2;
% loss_term = 0.5 * (1 + KL) * v2^2;
% data.h2 = (1/g) * (v1_sq_half + g * h1 - loss_term);
v2_sq_half = 0.5 * v2^2;
data.h2 = (1 / g) * (v1_sq_half + g * data.h1 - v2_sq_half);

% Optional: filter out negative h2 values (nonphysical)
data.h2(data.h2 < 0) = 0;

% Add gate column from h2
data.gate = data.h2 * 100 / 1.5;

% Save updated table with predictions
writetable(data, 'skfuzzy4_mamdani_type1.2_anfis_2_gate.csv');
