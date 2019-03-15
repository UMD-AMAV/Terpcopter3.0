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

Odroid Desktop no launch bar fix: source: https://ubuntuforums.org/showthread.php?t=2337119
```
1) Open a hard terminal again using [Crtl]+[Alt]+[F1] - and log in if necessary
2) $ cd ~/.config/dconf
3) $ rm user
4) $ cp user.bak user
5) $ kill -9 -1
```
