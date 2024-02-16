import os
import sys
import glob
import time
import math
import cv2
import numpy as np
import torch
import hdf5storage
from random import shuffle
from torch.autograd import Variable
import torch.nn.functional as F
import torch.nn as nn
import scipy.io as sio
import matplotlib.pyplot as plt
from torch.utils.data import TensorDataset, DataLoader

# define index pairs used to connect human body parts.
limb = np.array([[0,1],[0,2],[1,3],[2,4],[5,6],[5,7],[6,8],[7,9],[8,10],[5,11],[6,12],[11,12],[11,13],[12,14],[13,15],[14,16]])

# set PyTorch device to GPU if available, else use CPU.
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
if torch.cuda.is_available():
    print("PyTorch is using GPU.")
    # assuming only one GPU is available
    print("GPU Device:", torch.cuda.get_device_name(0))
else:
    print("PyTorch is using CPU.")

# load data from an HDF5 file.
data = hdf5storage.loadmat('C:/Users/snl/PycharmProjects/Human-Pose-estimation/preprocess/train80singleperson/750.mat', variable_names={'csi_serial', 'frame'})
csi_data = torch.zeros(1, 30*5, 3, 3)
csi_data[0,:,:,: ]= torch.from_numpy(data['csi_serial']).type(torch.FloatTensor).reshape(-1, 3, 3)
frame = data['frame']
# frame = frame[...,::-1]

# load a pre-trained model and set it to evaluation mode.
wisppn = torch.load('C:/Users/snl/PycharmProjects/Human-Pose-estimation/Pre-Trained/WiFiMobNet_weights.pkl', map_location=device)
wisppn = wisppn.eval()

# move data to the device before passing it to the model.
csi_data = Variable(csi_data.to(device))
pred_xy = wisppn(csi_data)
pred_xy = pred_xy.cpu().detach().numpy()

# initialize arrays to store predicted x, y, and coordinates. (three elements)
poseVector_x = np.zeros((1,17))
poseVector_y = np.zeros((1,17))
for index in range(17):
    poseVector_x[0,index] = pred_xy[0,0,index,index]
    poseVector_y[0,index] = pred_xy[0,1,index,index]


# set the desired frame size (height, width)
desired_frame_size = (920, 1900)

# resize the frame to the desired size
frame = cv2.resize(frame, desired_frame_size[::-1], interpolation=cv2.INTER_LINEAR)

while 1:
    # invert the y-axis in the image data
    inverted_frame = cv2.flip(frame, 0)

    # display the image
    plt.imshow(inverted_frame, extent=(0, desired_frame_size[1], 0, desired_frame_size[0] * 1.2))
    for i in range(len(limb)):
        x_values = poseVector_x[0, [limb[i, 0], limb[i, 1]]]
        y_values = poseVector_y[0, [limb[i, 0], limb[i, 1]]]

        plt.plot(x_values, y_values, linestyle="", marker="o")
        plt.plot(poseVector_x[0, [limb[i, 0], limb[i, 1]]], poseVector_y[0,[limb[i, 0], limb[i, 1]]])

        # print coordinates next to the points, illustrating the pose estimation on the visualized frame.
        for j in range(len(x_values)):
            plt.text(x_values[j], y_values[j], f'({x_values[j]:.2f}, {y_values[j]:.2f})', fontsize=10, color='red')
            #plt.plot(poseVector_x[0, [limb[j, 0], limb[j, 1]]], poseVector_y[0,[limb[j, 0], limb[j, 1]]])

    # invert the y-axis to match the original orientation.
    plt.gca().invert_yaxis()

    # rreserve aspect ratio of the plot.
    plt.axis('tight')

    plt.show()
    cv2.waitKey(15)