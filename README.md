# TerpCopter 3.0

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

 ## Manual Launch 
 # Launch Following nodes on Odroid
```
roslaunch mavros px4.launch
```
In a new terminal [2]
```
cd amav_ws
roslaunch terpcopter_driver/terpcopter_teraranger_node.launch 
```
## MATLAB GUI Launch 
Edit the loadParams.m file env variables accordingly.

cd GUI and launch Master_GUI.m 

# Flow Probe Node

## Setting up on odroid
- The teensy board on which the flow probe is attached might not work (Serial input pauses after a few lines). Follow instructions on this link to install the latest UDEV Rules for the board : https://www.pjrc.com/teensy/49-teensy.rules

- The serial porst need root access to run. Try steps in this link to change : https://askubuntu.com/a/58122

## Running
- Power on odroid and connect pixhawk. Connect flowprobe only after pixhawk powers on (else serial port changes. can change this in code but better than correcting it everytime just follow this order for connection).
- Run command in terminal : 
```
roslaunch terpcopter_driver terpcopter_flow_probe_node.launch
```
- Node publishes velocity in standard float32 message. Might print 2 values in terminal. Ignore second value.
- Note the value of the velocity and corresponding direction of quadrotor. Mount according to marked side on flowprobe pointing to front of the drone. If no mark present adjust for sign in code.

# Flow Probe Nodes

- The teensy board on which the flow probe is attached might not work (Serial input pauses after a few lines). Follow instructions on this link to install the latest UDEV Rules for the board : https://www.pjrc.com/teensy/49-teensy.rules

- The serial porst need root access to run. Try steps in this link to change : https://askubuntu.com/a/58122


# Issues Noticed

When launching launch files one might get "... is not a launch file". If this is the case: 

cd into workspace catkin_ws 

```
source ./devel/setup.bash 
```

## Odroid Desktop no launch bar fix: source: https://ubuntuforums.org/showthread.php?t=2337119
```
1) Open a hard terminal again using [Crtl]+[Alt]+[F1] - and log in if necessary
2) $ cd ~/.config/dconf
3) $ rm user
4) $ cp user.bak user
5) $ kill -9 -1


# Terpcopter-Vision
- Start the drone and ssh into odroid `ssh odroid@192.168.1.88` and password `odroid`
- Launch the camera node from the odroid 
```
roslaunch terpcopter_driver terpcopter_camera_node.launch
```
- To run vision algorithms download the Terpcopter-vision folder and extract the src file in a catkin workspace and make using `catkin_make`
- Then run the perception using 
```
rosrun camera_package cameraSub.py

## No IMU Data fix: 

When a camera is connected mavros is not able to pull topics from pixhawk due to usb port issue. To fix: 

1. Unplug all usb connections from Odroid
2. Plug pixhawk usb and launch mavors
3. Now connect rest of the usb's back

# Links for SD Card cloning

Resize and clone in linux: 
1) http://www.knight-of-pi.org/how-to-shrink-raspberry-pi-sd-card-images-with-gparted-and-dd/
2) https://askubuntu.com/questions/227924/sd-card-cloning-using-the-dd-command
3) https://www.cyberciti.biz/faq/linux-unix-dd-command-show-progress-while-coping/


