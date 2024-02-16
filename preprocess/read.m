clear all;
close all;
clc;

% File paths
output_folder = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\preprocess\train80singleperson';
file_name = '520.mat';

% Load the '10.mat' file
data = load(fullfile(output_folder, file_name));

% Extract data from the loaded file
frame = data.frame;
jointsMatrix = data.jointsMatrix;

% Plot the frame
figure;
imshow(frame);
hold on;

% Iterate through all keypoints in jointsMatrix and plot valid ones
for row = 1:size(jointsMatrix, 2)
    for column = 1:size(jointsMatrix, 3)
        x = jointsMatrix(1, row, column);
        y = jointsMatrix(2, row, column);

        % Check if the keypoint is valid (not zero)
        for i = 1:numel(x)
           plot(x(i), y(i), 'ro', 'MarkerSize', 10);
        end
    end
end
% Set the axis limits to match the frame size
xlim([0, size(frame, 2)]);
ylim([0, size(frame, 1)]);
% Add x and y axes
axis on;