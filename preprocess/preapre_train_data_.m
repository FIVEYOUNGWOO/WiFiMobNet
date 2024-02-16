clear all;
close all;
clc;
program_path=cd;                                                % Save old path 
csi_folder_path = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\CSI_data';% Get images folder path and name
cd (csi_folder_path);                                         % Change matlab directory into images folder
A=dir('*.mat');
cd(program_path)
k=0;
for n=1:length(A)
        if A(n).isdir==0
            k=k+1;
     temp(k) = str2num(strtok(A(n).name, '.'));
        end
end
[S,idx] = sort(temp,'ascend');
output_folder = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\preprocess\train80singleperson';
image_folder_path = 'C:\Users\snl\PycharmProjects\Human-Pose-estimation\videos';% Get images folder path and name
fname = ['C:\Users\snl\PycharmProjects\Human-Pose-estimation\AlphaPose-pytorch\examples\res\alphapose-results.json'];
cd (image_folder_path);                                         % Change matlab directory into images folder
AI=dir('*.png');
cd(program_path)

if ~isempty(dir(fname))
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
end
for n=1:length(AI)
image_path = fullfile(image_folder_path,AI(idx(n)).name);
frame = imread(image_path);

joints=val(n).keypoints;
x = joints(1:3:end);
y = joints(2:3:end);
c = joints(3:3:end);

jointsVector = [x;y;c;c];

jointsMatrix = zeros([4,18,18]);

for row = 1:17
    for column = 1:17
        if row == column
            jointsMatrix(:,row,column) = [x(row),y(row),c(row),c(row)];
        else
            jointsMatrix(:,row,column) = [x(row)-x(column),y(row)-y(column),c(row)*c(column),c(row)*c(column)];
        end 
    end
end
load(fullfile(csi_folder_path,A(idx(n)).name), 'csi_serial');

save(fullfile(output_folder,[strtok(A(idx(n)).name, '.'),'.mat']), 'csi_serial', 'frame', 'jointsVector', 'jointsMatrix', '-v7.3')

% Plot the frame
%figure;
%imshow(frame);
%hold on;

% Plot joint positions on top of the frame
%for i = 1:numel(x)
%   plot(x(i), y(i), 'ro', 'MarkerSize', 10);
%end
% Add any additional visualization, such as lines connecting joints in the matrix

%hold off;
end