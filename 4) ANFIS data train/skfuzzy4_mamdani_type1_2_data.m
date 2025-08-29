% Load the CSV file
data = readtable('new_water_params_6.csv');  % Automatically handles headers

% Scale inputs as required
wl_scaled = data.Wl * 100;  % scale level
wf_scaled = data.Wf * 10;   % scale flow

% Prepare input matrix
inputs = [wl_scaled, wf_scaled];

% Batch evaluate all rows at once (no loop needed)
outputs = data.vx;

% Save updated table with predictions
writetable(data, 'skfuzzy4_mamdani_type1.2_vx.csv');

new_data = [inputs, outputs];