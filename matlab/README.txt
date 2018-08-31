%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Terpcopter 2019 Installation and Users Guide
% Last Updated: 31-Aug-2018, A. Wolek
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ubuntu 16.04 Installation Procedure: 
---------------------------------------------------------------------------
- Ensure you have MATLAB installed with the Robotics Systems Toolbox
  You can verify this by typing 'rosinit' into the Command Window
    - If you see a message containing 'Initializing ROS master...' then proceed
      with the remainder of the installation.
    - If you do not see this message, and receive an error, you should 
      re-download MATLAB and run the installation procedure (selecting
      Robotics Systems Toolbox')

- Follow instructions for installing ROS Kinetic
  http://wiki.ros.org/kinetic

- Install mavros:
  $ sudo apt-get install ros-kinetic-mavros ros-kinetic-mavros-extras

- Obtain the terpcopter_msgs package and move it into your catkin_ws/src
  e.g. /home/wolek/catkin_ws/src/terpcopter_msgs

- From catkin_ws run:
  $ catkin_make

- Modify the params.terpcopterRosDir field in loadParams.m to give the absolute
  path to your catkin_ws/src folder. Save loadParams.m 

- Run updateMsgs.m and follow on-screen instructions 
  (this will generate custom AMAV ROS messages)

- Run updatePaths.m
  All of the folder icons in the matlab directory window should change from
  transparent to solid (indicating they are now in MATLAB's pathu).
  If you receive a warning that you cannot update pathdef.m  you may need  
  to change permissions of that file. 

- For instructions for installing the MAVLink toolchain:
  https://mavlink.io/en/getting_started/installation.htm

Running the Example Mission:
---------------------------------------------------------------------------
- The first mission requires 5 instances of MATLAB, one for each of the nodes 
  and one for the rosmaster. 

- In each MATLAB window, navigate the the terpcopter19/matlab folder.

- If the subdirectory icons are transparent in the Current Folder window,
  you must run (in each window): 
  >> updatePaths
    
  Note: you can modify your path.def file permanently to avoid this step.

- Next, type the following commands, in the corresponding MATLAB instance:
 
  MATLAB 1: 
  >> launchMaster

  MATLAB 2:
  >> autonomy

  MATLAB 3:
  >> control

  MATLAB 4:
  >> virtual_transmitter

  A short simulation should show a quadcopter taking off, drifiting, and landing.

- To properly shutdown each node run Ctrl+C and 'rosshutdown' or 'clean'.

Creating custom AMAV messages
--------------------------------------------------------------------------- 

- Obtain the terpcopter_msgs package and move it into your catkin_ws/src
  if you have note done so already.
  e.g. /home/wolek/catkin_ws/src/terpcopter_msgs

- Follow instructions to define custom messages in catkin_ws here:
  http://wiki.ros.org/ROS/Tutorials/DefiningCustomMessages

- Your new .msg file should be placed in the terpcopter_msgs/msg folder

- From a terminal, navigate tothe catkin_ws folder, and run:
  $ catkin_make

- In MATLAB, navigate to the terpcopter19/matlab folder and run:
  >> updateMsgs

- Follow the on-screen instructions in the MATLAB Command Window: 
  For example:
        To use the custom messages, follow these steps:

        1. Edit javaclasspath.txt, add the following file locations as new lines, and save the file:

        /home/wolek/catkin_ws/src/matlab_gen/jar/terpcopter_msgs-0.0.0.jar

        2. Add the custom message folder to the MATLAB path by executing:

        addpath('/home/wolek/catkin_ws/src/matlab_gen/msggen')
        savepath

        3. Restart MATLAB and verify that you can use the custom messages. 
           Type "rosmsg list" and ensure that the output contains the generated
           custom message types.


