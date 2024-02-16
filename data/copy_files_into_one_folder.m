clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear all;  % Erase all existing variables.
% Specify source and destination folders
source_folder = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\CSI\1229_video';
destination_folder = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\videos';



% Recursively copy files from source to destination
copyFilesRecursive(source_folder, destination_folder);

function copyFilesRecursive(source, destination)
    % Get a list of files and folders in the source directory
    contents = dir(source);

    % Iterate through each item in the source directory
    for i = 1:length(contents)
        item = contents(i);

        % Skip '.' and '..' folders
        if strcmp(item.name, '.') || strcmp(item.name, '..')
            continue;
        end

        % Construct full paths for the source and destination
        source_path = fullfile(source, item.name);
        destination_path = destination;

        % If it's a folder, recursively copy its contents
        if item.isdir

            % Recursively copy files from the subfolder
            copyFilesRecursive(source_path, destination_path);
        else
            % Copy the file to the destination folder
            copyfile(source_path, destination_path);
        end
    end
end


