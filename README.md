# WiFiMobNet (early version)
: WiFi-Camera fusion-based object mobility detection and motion estimation via Teacher-Studnet multimodal AI approach

* This repository is part of an early-stage WiFi and camera data fusion-based human detection and motion estimation project. Through the '*Project Manual.doc*', you can utilize the initial project after adjusting it to the environment.
* The goal of our research is to develop a multimodal-based computer vision technology to detect and track objects beyond walls by adding IEEE 802.11 standard WiFi signals.
  
* A multimodal approach that additionally utilizes WiFi signals can complement problems such as obstacles and object obscuration that occur in existing camera-based security and computer vision through the radio frequency (RF) signal characteristics.


# Evaluation of WiFi-camera multimodal approach
- We tested the trained model with 100 random samples. The results indicate that the pre-trained multimodal model can closely estimate real human posture for each sample. However, the model requires further improvement to estimate object motion more accurately and adaptively in different environments. In our future work, we plan to expand the multimodal approach to include multiple Teacher-Student architectures and federated learning to achieve zero configuration.

<table>
  <tr>
    <td><img src="/README_images/estimation 1.png" width="500" height="320"/></td>
    <td><img src="/README_images/estimation 2.png" width="500" height="320"/></td>
  </tr>
</table>

# Project Members
#### [Youngwoo Oh](https://ohyoungwoo.com/) (M.S. student, Project leader from May 2023 to Feb. 2024 (for 10 months))
- Integrated data fusion between WiFi signals and captured video from the router and cameras by developing the [Linux toolkit codes](https://github.com/FIVEYOUNGWOO/IEEE-802.11n-CSI-Camera-Synchronization-Toolkit).
- Responsible for data fusion and SW/HW configuration and Produced a Teacher-Student approach to detect and track objects beyond walls and obstacles.
- Wrote papers for the [2024 Winter Conference on Korea Information and Communications Society (KICS)](https://conf.kics.or.kr/) titled "*Collection and Analysis of CSI in IEEE 802.11n Wireless LAN Environments for WiFi Signal-Based Human Mobility Detection (special session)*" and "*Design and Implementation of a MultiModal Learning Model for RF-Based Object Tracking Methods (recent results)*".

#### Islam Helemy (Ph.D. student, Project member)
- Responsible for the development of the Multimodal AI and the pre-processing to generate training data pairs (CSI samples-captured images).
- He will receive a *project leader* position on this future project after Mar. 2024.

#### Iftikhar Ahmad (Ph.D. student, Project member)
- Focused on developing and investigating the Teacher network in the multimodal AI model.

#### Manal Mosharaf (M.S. student, Project member)
- Engaged in developing and investigating the Student network in the multimodal AI model.
- Responsible for an analysis of WiFi signal features according to human posture and movement.

#### [Jungtae Kang](https://kangjeongtae.com/) (Undergraduate student, Project follower)
- Investigation of pose adjacency matrix for Student Network training.
- Tuning the multimodal learning model in terms of optimizing hyper-parameters.
- In his future research, he will follow up on this "*Novel multi-modal approaches-based object detection/tracking/recognition methods*".
