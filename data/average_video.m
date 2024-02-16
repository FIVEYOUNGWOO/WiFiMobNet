% Demo to extract frames and get the mean frame.

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 22;
% Specify the file name
file_name = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\AlphaPose-pytorch\examples\demo\list-coco-demo.txt';
fileID = fopen(file_name, 'w');

% % Open the rhino.avi demo movie that ships with MATLAB.
% % First get the folder that it lives in.
% folder = fileparts(which('0.mp4')); % Determine where demo folder is (works with all versions).
% % Pick one of the two demo movies shipped with the Image Processing Toolbox.
% % Comment out the other one.
% movieFullFileName = fullfile(folder, '0.mp4');
folder = uigetdir('*.mp4','Import Image Folder');% Get images folder path and name
% folder = 'C:\Users\s5281592\Downloads\CSI data\SNL_stop_motions\video files\0_24_handsup';
A=dir(folder);% Save the directory files into A
valid_entries = ~ismember({A.name}, {'.', '..'});
A = A(valid_entries);
k=0;
for n=1:length(A)
        if A(n).isdir==0
            k=k+1;
     temp(k) = str2num(strtok(A(n).name, '.'));
        end
end
[S,idx] = sort(temp,'ascend');
k=0;
for n=1:length(A)
% movieFullFileName = fullfile(folder, 'traffic.avi');
% Check to see that it exists.
    if A(n).isdir==0
        k=k+1;
movieFullFileName = fullfile(folder, A(idx(k)).name);
if ~exist(movieFullFileName, 'file')
  strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', movieFullFileName);
  response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
  if strcmpi(response, 'OK - choose a new movie.')
    [baseFileName, folderName, FilterIndex] = uigetfile('*.avi');
    if ~isequal(baseFileName, 0)
      movieFullFileName = fullfile(folderName, baseFileName);
    else
      return;
    end
  else
    return;
  end
end

try
  videoObject = VideoReader(movieFullFileName)
  % Determine how many frames there are.
  numberOfFrames = videoObject.NumberOfFrames;
  vidHeight = videoObject.Height;
  vidWidth = videoObject.Width;

  numberOfFramesWritten = 0;
  % Prepare a figure to show the images in the upper half of the screen.
  % figure;
  %   screenSize = get(0, 'ScreenSize');
  % Enlarge figure to full screen.
  set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

  % Loop through the movie, getting mean frame.
  for frame = 1 : numberOfFrames
    % Extract the frame from the movie structure.
    thisFrame = read(videoObject, frame);
    % This code for average
    % temp = read(videoObject, frame);
    % sx = 100;
    % sy = 600;
    % thisFrame = temp(sx:sx+359,sy:sy+639,:);

    % Display it
    hImage = subplot(1, 2, 1);
    image(thisFrame);
    axis('on', 'image');
    caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
    title(caption, 'FontSize', fontSize);
    drawnow; % Force it to refresh the window.

    % Calculate the mean frame.
    if frame == 1
      sumFrame = double(thisFrame);
    else
      sumFrame = sumFrame + double(thisFrame);
    end
    meanFrame = uint8(sumFrame / frame);

    % Plot the mean gray levels.
    hPlot = subplot(1, 2, 2);
    imshow(meanFrame);
    axis('on', 'image');
    caption = sprintf('Mean of %d frames', frame);
    title(caption, 'FontSize', fontSize);
    drawnow;

    % Update user with the progress.  Display in the command window.
    progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
    disp(progressIndication);
  end

  % % Alert user that we're done.
  % finishedMessage = sprintf('Done!  It processed %d frames of\n    "%s"', numberOfFrames, movieFullFileName);
  % disp(finishedMessage); % Write to command window.
  % uiwait(msgbox(finishedMessage)); % Also pop up a message box.

catch ME
  % Some error happened if you get here.
  strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
  uiwait(msgbox(strErrorMessage));
end
image_paths = fullfile(folder,[strtok(A(idx(k)).name, '.'),'.png']);
imwrite(meanFrame,image_paths);
fprintf(fileID, '%s\n', image_paths);
    end
end
fclose(fileID);
