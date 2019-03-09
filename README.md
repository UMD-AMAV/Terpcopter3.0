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
```
