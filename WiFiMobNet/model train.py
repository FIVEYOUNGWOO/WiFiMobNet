import os
import sys
import glob
import time
import math
import numpy as np
import torch
import hdf5storage
import tensorflow as tf
from random import shuffle
from torch.autograd import Variable
import torch.nn.functional as F
import torch.nn as nn
import scipy.io as sio
from torch.utils.data import TensorDataset, DataLoader
from StudentNet.wisppn_resnet import ResNet, ResidualBlock, Bottleneck

# check and print the TensorFlow GPU version.
print("TensorFlow version:", tf.__version__)

# check if GPU is available for TensorFlow and print the available GPU devices.
if tf.config.list_physical_devices('GPU'):
    print("TensorFlow is using GPU.")
    # Print GPU devices
    physical_devices = tf.config.list_physical_devices('GPU')
    for device in physical_devices:
        print(f"GPU Device: {device.name}")
else:
    print("TensorFlow is using CPU.")
gpus = tf.config.experimental.list_physical_devices('GPU')
print("Available GPUs:", len(gpus))


# setting batch size, number of epochs, and learning rate for the training process.
# batch_size = 30
batch_size = 1
num_epochs = 120
learning_rate = 0.001

# the JSON matrix label changed to 18 to 17. Because, the last value inserted '0' value, It make a mis-understanding of the StudentNet.
def getMinibatch(file_names):
    file_num = len(file_names)
    # the CSI shape considered the 3X3 MIMO-OFDM.
    # where 3X3 is number of trnamsit/receive antennas, and 30X5 denote number of sub-carrieres X consecutive CSI samples per a second.
    csi_data = torch.zeros(file_num, 30*5, 3, 3)
    jmatrix_label = torch.zeros(file_num, 4, 17, 17)
    # jmatrix_label = torch.zeros(file_num, 4, 18, 18)
    
    # load each file's data into the tensors.
    for i in range(file_num):
        data = hdf5storage.loadmat(file_names[i], variable_names={'csi_serial', 'jointsMatrix'})
        
        #changed view to reshape
        csi_data[i, :, :, :] = torch.from_numpy(data['csi_serial']).type(torch.FloatTensor).reshape(-1, 3, 3)
        jmatrix_label[i, :, :, :] = torch.from_numpy(data['jointsMatrix']).type(torch.FloatTensor)
    return csi_data, jmatrix_label

# set the device to GPU if available, else use CPU.
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
if torch.cuda.is_available():
    print("PyTorch is using GPU.")
    
    # assuming only one GPU is available
    print("GPU Device:", torch.cuda.get_device_name(0))
else:
    print("PyTorch is using CPU.")
    
# load .mat files from a specified directory for training.
mats = glob.glob('C:/Users/snl/PycharmProjects/Human-Pose-estimation/preprocess/train80singleperson/*.mat')
mats_num = len(mats)
batch_num = int(np.floor(mats_num/batch_size))

# initialize the Student model, loss function, optimizer, and learning rate scheduler.
wisppn = ResNet(ResidualBlock, [2, 2, 2, 2]).to(device)
criterion_L2 = nn.MSELoss().to(device)
optimizer = torch.optim.Adam(wisppn.parameters(), lr=learning_rate)
scheduler = torch.optim.lr_scheduler.MultiStepLR(optimizer, milestones=[10, 15, 20, 25, 30], gamma=0.5)

# set model to training mode.
wisppn.train()

# training loop for the specified number of epochs.
for epoch_index in range(num_epochs):
    scheduler.step()
    start = time.time()
    # shuffling the dataset for each epoch.
    shuffle(mats)
    loss_x = 0
    
    # process each minibatch.
    for batch_index in range(batch_num):
        if batch_index < batch_num:
            file_names = mats[batch_index*batch_size:(batch_index+1)*batch_size]
        else:
            file_names = mats[batch_num*batch_size:]

        csi_data, jmatrix_label = getMinibatch(file_names)
        csi_data = Variable(csi_data.to(device))
        xy = Variable(jmatrix_label[:, 0:2, :, :].to(device))
        confidence = Variable(jmatrix_label[:, 2:4, :, :].to(device))

        pred_xy = wisppn(csi_data)
        loss = criterion_L2(torch.mul(confidence, pred_xy), torch.mul(confidence, xy))

        print(loss.item())
        optimizer.zero_grad()

        loss.backward()
        optimizer.step()

    endl = time.time()

# save the trained model to a specified path.
torch.save(wisppn, 'C:/Users/snl/PycharmProjects/Human-Pose-estimation/Pre-Trained/WiFiMobNet_weights.pkl')