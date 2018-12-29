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

# Image Processing

For working with the camera_package following are the instructions

Clone the repository by using the following command
 
 ```
 git clone https://github.com/UMD-AMAV/Terpcopter3.0
 ```
 
 Now, create a catkin workspace for running rosnode.
 ```
 cd
 mkdir catkin_ws/src
 ```
 
 Now, from the Terpcopter3.0 folder created in the home directory, copy the camera_package and paste it in the newly created workspace with path (~/catkin_ws/src)
 
 Now build the package
 ```
 cd ~/catkin_ws
 catkin_make
 source devel/setup.bash
 ``` 
 To run the scripts
 Open 3 terminals
 In 1st terminal, open roscore
 ```
 roscore
 ```
 In 2nd terminal, run publisher
 ```
 cd ~/catkin_ws
 source devel/setup.bash
 rosrun camera_package cameraPub.py
 ```
 In 3rd terminal, run subscriber
 ```
 cd ~/catkin_ws
 source devel/setup.bash
 rosrun camera_package cameraSub.py
 ```
