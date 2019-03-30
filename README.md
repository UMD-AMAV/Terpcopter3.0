# TerpCopter 3.0

# Clone
To clone Snapy branch
```
git clone -b snapy --single-branch https://github.com/UMD-AMAV/Terpcopter3.0.git
```

# Overview
This repository contains work done for AHS micro aerial vehicle challenge 

# ROSTerpcopterModule
This module requires ros kinetic and catkin worspace installed in your local
system. 

- To build the module in your catkin_ws copy and paste all the folders inside
 ROSTerpcopterModule into catkin_ws/src folder and run catkin build 
 
 ## Choosing Master and Slave 
Terpcopter team choose Buggy/ snappy drone to be the master and slave to be GNC laptops. To reflect the setup, make the following changes in your Laptop's bashrc:
```
nano ~/.bashrc 
export ROS_MASTER_URI=http://<ip address of the drone>:11311
export ROS_HOSTNAME= <ip of laptop>
```
on snappy/buggy drone 
```
nano ~/.bashrc 
export ROS_MASTER_URI=http://<ip address of the drone>:11311
export ROS_HOSTNAME= <ip of the drone>
```

## Snapdragon Launch 
 # SSH into Snapdragon by 
```
ssh linaro@<ip> 
pwd: linaro

sudo su
pwd: linaro
```
 # Launch px4 
```
cd linaro
./px4 mainapp.config
```
In a new terminal [2] launch mavros/ VIO
```
cd linaro
roslaunch vio_ws/src/ros-examples/launch/mavros_vislam.launch
```
## MATLAB GUI Launch 
Edit the loadParams.m file env variables accordingly.

Run Master_GUI.m script and launch rest of the nodes by pushing the button 

# Issues Noticed

When launching launch files one might get "... is not a launch file". If this is the case: 

cd into workspace catkin_ws 

```
source ./devel/setup.bash 
```

Odroid Desktop no launch bar fix: source: https://ubuntuforums.org/showthread.php?t=2337119
```
1) Open a hard terminal again using [Crtl]+[Alt]+[F1] - and log in if necessary
2) $ cd ~/.config/dconf
3) $ rm user
4) $ cp user.bak user
5) $ kill -9 -1
```
