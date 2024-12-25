# WiFiMobNet (early version)
: WiFi-Camera fusion-based object mobility detection and motion estimation via Teacher-Studnet multimodal AI approach
* This repository is part of an early-stage WiFi and camera sensor fusion-based human detection and motion estimation project. Through the '*Project Manual.doc*', you can utilize the initial project after adjusting it to the environment. Our research aims to develop a multimodal-based computer vision technology to detect and track objects beyond walls by adding IEEE 802.11 standard WiFi signals. A multimodal approach utilizing WiFi signals can complement problems such as obstacles and object obscuration in existing camera-based security and computer vision through the radio frequency (RF) signal characteristics.

# Teacher-student architecture for person pose estimation
* We implemented a Teacher-Student architecture framework to train on captured WiFi signals and images. The **Teacher** network utilizes a **Person Detector** and a **Pose Regressor** to decide precise position coordinates $(x', y', c')$, serving as ground truth data. The **Student** network encodes WiFi signals to estimate motion, extracting relevant features through an **Encoder-Decoder** structure.
* The **Pose Adjacent Matrix (PAM)** serves as a shared representation between the Teacher and Student networks, facilitating the alignment of pose estimations. PAM enables the Student network to refine its predictions by minimizing the similarity loss with the Teacher's output, effectively transferring information through knowledge distillation and enhancing motion estimation accuracy. 
* Specifically, the prediction process minimizes the similarity loss between the Teacher's output $(x', y', c')$ and the Student's predictions $(x*, y*)$, where $c'$ represents an entropy coefficient contributing to the loss function.

![Teacher-Student Framework](/README_images/teacher-student.PNG)

# Evaluation of WiFi-camera multimodal approach
- We tested the trained model with 100 random samples. The results indicate that the pre-trained multimodal model can closely estimate real human posture for each sample. However, the model requires further improvement to estimate object motion more accurately and adaptively in different environments. In our future work, we plan to expand the multimodal approach to include multiple Teacher-Student architectures and federated learning to achieve zero configuration.

<table>
  <tr>
    <td><img src="/README_images/estimation_1.png" width="320" height="280"/></td>
    <td><img src="/README_images/estimation_2.png" width="320" height="280"/></td>
    <td><img src="/README_images/estimation_3.png" width="320" height="280"/></td>
  </tr>
</table>

# Project Members
#### [Youngwoo Oh](https://ohyoungwoo.com/) (M.S. student, Project leader from May 2023 to Feb. 2024 (for 10 months))
- Integrated sensor fusion between WiFi signals and captured video from the conventional WiFi router and USB camera by developing the [Linux toolkit codes](https://github.com/FIVEYOUNGWOO/IEEE-802.11n-CSI-Camera-Synchronization-Toolkit).
- Responsible for sensor fusion and SW/HW configuration and Produced a Teacher-Student approach to detect and track objects beyond walls and obstacles.
- Wrote papers for the [2024 Winter Conference on Korea Information and Communications Society (KICS)](https://conf.kics.or.kr/) titled "*Collection and Analysis of CSI in IEEE 802.11n Wireless LAN Environments for WiFi Signal-Based Human Mobility Detection (special session)*" and "*Design and Implementation of a MultiModal Learning Model for RF-Based Object Tracking Methods (recent results)*".

#### Islam Helemy (Ph.D. student, Project member)
- Responsible for developing the Multimodal AI and the pre-processing to generate training data pairs (CSI samples-captured images).
- He will receive a *project leader* position on this future project after Mar. 2024.

#### Iftikhar Ahmad (Ph.D. student, Project member)
- Focused on developing and investigating the Teacher network in the multimodal AI model.

#### Manal Mosharaf (M.S. student, Project member)
- Developed and investigated the Student network using the multimodal AI model.
- Responsible for analysis of the WiFi signal features according to human posture and movement.

#### [Jungtae Kang](https://kangjeongtae.com/) (Undergraduate student, Project follower)
- Investigation of pose adjacency matrix for Student Network training.
- Tuning the multimodal learning model in terms of optimizing hyper-parameters.
- In his future research, he will follow up on this "*Novel multi-modal approaches-based object detection/tracking/recognition methods*".
