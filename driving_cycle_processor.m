%% Driving Cycle Data Extraction and Processing
% This script extracts time and speed data from multiple CSV files and combines them
% to create a composite driving cycle for vehicle energy management research.

% Clear workspace and command window
clear all;
clc;

%% File Configuration
% Specify CSV files to be processed
fileNames = {'jrc_data/D1_part1.csv', 'jrc_data/D1_part2.csv', 'jrc_data/D1_part3.csv', 'jrc_data/D1_part5.csv'};
fprintf('Starting driving cycle data processing...\n');

% Initialize data structures
individualData = struct();
combinedData = struct();

% Initialize arrays for combined data
combinedTime = [];
combinedSpeed = [];
combinedEngineSpeed = [];
combinedGear = [];

%% Read CSV Files and Extract Data
for i = 1:length(fileNames)
    try
        % Read CSV file
        fileName = fileNames{i};
        fprintf('Reading file: %s\n', fileName);
        csvData = readtable(fileName);
        
        % Extract data
        timeData = csvData.Time;
        speedData = csvData.Speed;
        engineSpeedData = csvData.Speed;  % Adjust this if Engine Speed has a different column name
        gearData = csvData.Gear;
        
        % Create structure name from file name (remove extension)
        [~, baseName, ~] = fileparts(fileName);
        cycleName = baseName; % Use filename as cycle name
        
        % Store individual file data
        individualData.(cycleName).time = timeData;
        individualData.(cycleName).speed = speedData;
        individualData.(cycleName).engineSpeed = engineSpeedData;
        individualData.(cycleName).gear = gearData;
        
        % Calculate time intervals (for acceleration computation)
        dt = diff(timeData);
        
        % Calculate acceleration (m/s^2)
        accelData = [0; diff(speedData) ./ dt];
        individualData.(cycleName).accel = accelData;
        
        % Calculate key metrics
        individualData.(cycleName).meanSpeed = mean(speedData);
        individualData.(cycleName).maxSpeed = max(speedData);
        individualData.(cycleName).maxAccel = max(accelData);
        individualData.(cycleName).minAccel = min(accelData);
        individualData.(cycleName).stdSpeed = std(speedData);
        individualData.(cycleName).cv = individualData.(cycleName).stdSpeed / individualData.(cycleName).meanSpeed;
        
        fprintf('Successfully processed file: %s\n', fileName);
        fprintf('  Rows: %d\n', length(timeData));
        fprintf('  Mean Speed: %.2f m/s\n', individualData.(cycleName).meanSpeed);
        fprintf('  Max Speed: %.2f m/s\n', individualData.(cycleName).maxSpeed);
        fprintf('  Max Acceleration: %.2f m/s²\n', individualData.(cycleName).maxAccel);
        fprintf('  Min Acceleration: %.2f m/s²\n', individualData.(cycleName).minAccel);
        fprintf('  Speed Std Dev: %.2f m/s\n', individualData.(cycleName).stdSpeed);
        fprintf('  Coefficient of Variation: %.2f\n', individualData.(cycleName).cv);
        
        % Combine data
        % If not the first file, adjust time to make it continuous
        if i == 1
            combinedTime = timeData;
        else
            % Get the last time point from previous file
            lastTime = combinedTime(end);
            % Adjust current file time to start after the previous file ends
            adjustedTime = timeData - timeData(1) + lastTime;
            combinedTime = [combinedTime; adjustedTime];
        end
        
        % Concatenate other data
        combinedSpeed = [combinedSpeed; speedData];
        combinedEngineSpeed = [combinedEngineSpeed; engineSpeedData];
        combinedGear = [combinedGear; gearData];
        
    catch ex
        fprintf('Error processing file %s: %s\n', fileName, ex.message);
    end
end

%% Process Combined Data
fprintf('\nProcessing combined data...\n');

% Store combined data
combinedData.time = combinedTime;
combinedData.speed = combinedSpeed;
combinedData.engineSpeed = combinedEngineSpeed;
combinedData.gear = combinedGear;

% Calculate acceleration for combined data
dt_combined = diff(combinedTime);
accel_combined = [0; diff(combinedSpeed) ./ dt_combined];
combinedData.accel = accel_combined;

% Calculate key metrics for combined data
combinedData.meanSpeed = mean(combinedSpeed);
combinedData.maxSpeed = max(combinedSpeed);
combinedData.maxAccel = max(accel_combined);
combinedData.minAccel = min(accel_combined);
combinedData.stdSpeed = std(combinedSpeed);
combinedData.cv = combinedData.stdSpeed / combinedData.meanSpeed;

fprintf('Combined Data Statistics:\n');
fprintf('  Total Rows: %d\n', length(combinedTime));
fprintf('  Total Duration: %.2f seconds\n', combinedTime(end) - combinedTime(1));
fprintf('  Mean Speed: %.2f m/s\n', combinedData.meanSpeed);
fprintf('  Max Speed: %.2f m/s\n', combinedData.maxSpeed);
fprintf('  Max Acceleration: %.2f m/s²\n', combinedData.maxAccel);
fprintf('  Min Acceleration: %.2f m/s²\n', combinedData.minAccel);
fprintf('  Speed Std Dev: %.2f m/s\n', combinedData.stdSpeed);
fprintf('  Coefficient of Variation: %.2f\n', combinedData.cv);

%% Save Combined Data to MAT Files
try
    % Save complete combined data
    save('combined_driving_data.mat', 'combinedData');
    fprintf('Combined data saved to: combined_driving_data.mat\n');
    
    % Save only time and speed data (as requested)
    time = combinedTime;
    speed = combinedSpeed;
    save('combined_time_speed.mat', 'time', 'speed');
    fprintf('Combined time and speed data saved to: combined_time_speed.mat\n');
    
    % Save individual file data
    save('individual_driving_data.mat', 'individualData');
    fprintf('Individual file data saved to: individual_driving_data.mat\n');
catch ex
    fprintf('Error saving data: %s\n', ex.message);
end

%% Create and Populate Metrics Table
fprintf('\nCalculating driving cycle metrics...\n');

% Get data field names (file names used as cycle names)
cycle_names = fieldnames(individualData);
num_cycles = length(cycle_names);

% Initialize table to store metrics (including CV column)
metrics = table('Size', [num_cycles + 1, 7], ...
    'VariableTypes', {'string', 'double', 'double', 'double', 'double', 'double', 'double'}, ...
    'VariableNames', {'CycleName', 'MeanSpeed', 'MaxSpeed', 'MaxAccel', 'MinAccel', 'StdSpeed', 'CV'});

% Populate table (metrics for individual files)
for i = 1:num_cycles
    cycle_name = cycle_names{i};
    metrics.CycleName(i) = string(cycle_name);
    metrics.MeanSpeed(i) = individualData.(cycle_name).meanSpeed;
    metrics.MaxSpeed(i) = individualData.(cycle_name).maxSpeed;
    metrics.MaxAccel(i) = individualData.(cycle_name).maxAccel;
    metrics.MinAccel(i) = individualData.(cycle_name).minAccel;
    metrics.StdSpeed(i) = individualData.(cycle_name).stdSpeed;
    metrics.CV(i) = individualData.(cycle_name).cv;
end

% Add metrics for combined data
metrics.CycleName(num_cycles + 1) = "Combined";
metrics.MeanSpeed(num_cycles + 1) = combinedData.meanSpeed;
metrics.MaxSpeed(num_cycles + 1) = combinedData.maxSpeed;
metrics.MaxAccel(num_cycles + 1) = combinedData.maxAccel;
metrics.MinAccel(num_cycles + 1) = combinedData.minAccel;
metrics.StdSpeed(num_cycles + 1) = combinedData.stdSpeed;
metrics.CV(num_cycles + 1) = combinedData.cv;

% Display metrics table
disp('Calculated Driving Cycle Key Metrics:');
disp(metrics);

% Save metrics table
try
    save('driving_metrics.mat', 'metrics');
    fprintf('Metrics data saved to: driving_metrics.mat\n');
    
    % Export metrics to CSV
    writetable(metrics, 'driving_metrics.csv');
    fprintf('Metrics data exported to: driving_metrics.csv\n');
catch ex
    fprintf('Error saving metrics data: %s\n', ex.message);
end

%% Plot Speed Curves for Individual Files
figure('Name', 'Individual Speed Curves', 'Position', [100, 100, 1200, 800]);

for i = 1:num_cycles
    cycle_name = cycle_names{i};
    
    subplot(num_cycles, 1, i);
    plot(individualData.(cycle_name).time, individualData.(cycle_name).speed, 'b-', 'LineWidth', 1);
    title(['Driving Cycle: ', cycle_name]);
    xlabel('Time (s)');
    ylabel('Speed (m/s)');
    grid on;
    
    % Add statistical information text
    text(0.02, 0.95, sprintf('Mean Speed: %.2f m/s', individualData.(cycle_name).meanSpeed), ...
        'Units', 'normalized', 'FontSize', 8);
    text(0.02, 0.85, sprintf('Max Speed: %.2f m/s', individualData.(cycle_name).maxSpeed), ...
        'Units', 'normalized', 'FontSize', 8);
    text(0.02, 0.75, sprintf('CV: %.2f', individualData.(cycle_name).cv), ...
        'Units', 'normalized', 'FontSize', 8);
end

% Save figure
saveas(gcf, 'individual_speed_curves.png');
fprintf('Individual speed curves saved to: individual_speed_curves.png\n');

%% Plot Combined Speed Curve
figure('Name', 'Combined Speed Curve', 'Position', [100, 100, 1200, 400]);
plot(combinedData.time, combinedData.speed, 'b-', 'LineWidth', 1);
title('Combined Driving Cycle Speed Curve');
xlabel('Time (s)');
ylabel('Speed (m/s)');
grid on;

% Add statistical information text
text(0.02, 0.95, sprintf('Mean Speed: %.2f m/s', combinedData.meanSpeed), ...
    'Units', 'normalized', 'FontSize', 10);
text(0.02, 0.85, sprintf('Max Speed: %.2f m/s', combinedData.maxSpeed), ...
    'Units', 'normalized', 'FontSize', 10);
text(0.02, 0.75, sprintf('CV: %.2f', combinedData.cv), ...
    'Units', 'normalized', 'FontSize', 10);
text(0.02, 0.65, sprintf('Total Duration: %.2f seconds', combinedData.time(end) - combinedData.time(1)), ...
    'Units', 'normalized', 'FontSize', 10);

% Save figure
saveas(gcf, 'combined_speed_curve.png');
fprintf('Combined speed curve saved to: combined_speed_curve.png\n');

%% Plot File Joining Points Diagram
figure('Name', 'File Joining Diagram', 'Position', [100, 100, 1200, 400]);
plot(combinedData.time, combinedData.speed, 'b-', 'LineWidth', 1);
hold on;

% Calculate and mark joining points
joinPoints = zeros(length(fileNames), 1);
currentIndex = 0;
for i = 1:length(fileNames)
    if i > 1
        currentIndex = currentIndex + length(individualData.(cycle_names{i-1}).time);
        joinPoints(i) = combinedData.time(currentIndex);
        % Draw vertical line at joining point
        plot([joinPoints(i) joinPoints(i)], [0 max(combinedData.speed)], 'r--', 'LineWidth', 1);
        % Add file name label
        text(joinPoints(i) + 10, max(combinedData.speed)*0.9, ['→ ' cycle_names{i}], 'FontSize', 8);
    else
        % Add label for first file
        text(combinedData.time(1) + 10, max(combinedData.speed)*0.9, cycle_names{1}, 'FontSize', 8);
    end
end

title('Driving Cycle Data Joining Diagram');
xlabel('Time (s)');
ylabel('Speed (m/s)');
grid on;

% Save figure
saveas(gcf, 'file_joining_points.png');
fprintf('File joining diagram saved to: file_joining_points.png\n');

fprintf('\nAnalysis complete!\n');