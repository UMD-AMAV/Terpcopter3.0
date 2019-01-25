# TerpCopter 3.0

# Overview
This repository contains work done for AHS micro aerial vehicle challenge 

# ROSTerpcopterModule
This module requires ros kinetic and catkin worspace installed in your local
system. 

- To build the module in your catkin_ws copy and paste all the folders inside
 ROSTerpcopterModule into catkin_ws/src folder and run catkin build 
 
 # Launch Following nodes on Odroid
```
roslaunch mavros px4.launch
```
In a new terminal [2]
```
cd amav_ws
```
```
roslaunch terpcopter_driver/terpcopter_teraranger_node.launch 
```
# Issues Noticed

When launching launch files one might get "... is not a launch file". If this is the case: 

```
source ./devel/setup.bash 
```

# Flow Probe Nodes

- The teensy board on which the flow probe is attached might not work (Serial input pauses after a few lines). Follow instructions on this link to install the latest UDEV Rules for the board : https://www.pjrc.com/teensy/49-teensy.rules

- The serial porst need root access to run. Try steps in this link to change : https://askubuntu.com/a/58122