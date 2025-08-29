% Load the CSV file
data = readtable('water_params_analysis_6.csv');  % Automatically handles headers

% Scale inputs as required
wl_scaled = data.Wl * 100;  % scale level
wf_scaled = data.Wf * 10;   % scale flow

% Prepare input matrix
inputs = [wl_scaled, wf_scaled];

% Load the Sugeno-type FIS
fis = readfis('gate_mamdani_anfis_2.fis');

% Batch evaluate all rows at once (no loop needed)
outputs = evalfis(fis, inputs);

% Append result as a new column
data.gate = outputs;

% Save updated table with predictions
writetable(data, 'skfuzzy4_mamdani_type1.2_anfis_2_normal.csv');

