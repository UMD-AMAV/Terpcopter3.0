%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Terpcopter 2019 Installation and Users Guide
% Last Updated: 07-Sep-2018, A. Wolek
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ubuntu 16.04 Installation Procedure: 
---------------------------------------------------------------------------

- Install git:
  $ sudo apt install git-all

- Clone the TerpCopter2019 Repository
  $ git clone https://github.com/UMD-AMAV/TerpCopter2019.git

- Ensure you have MATLAB installed with the Robotics Systems Toolbox
  You can verify this by typing 'rosinit' into the Command Window
    - If you see a message containing 'Initializing ROS master...' then proceed
      with the remainder of the installation.
    - If you do not see this message, and receive an error, you should 
      re-download MATLAB and run the installation procedure (selecting
      Robotics Systems Toolbox')

- Install the interface for ROS Custom messages:
  https://www.mathworks.com/matlabcentral/fileexchange/49810-robotics-system-toolbox-interface-for-ros-custom-messages

- Follow instructions for installing ROS Kinetic
  http://wiki.ros.org/kinetic

- Install mavros:
  $ sudo apt-get install ros-kinetic-mavros ros-kinetic-mavros-extras

- If the above command produces the follwing error (or similar):
	produces the error:
	Setting up runit (2.1.2-3ubuntu1) ...
	start: Unable to connect to Upstart: Failed to connect to socket /com/ubuntu/upstart: Connection refused
	
 Try running the following commands and then repeate the mavros and mavros-extras install:
$ sudo apt-get purge runit
$ sudo apt-get autoremove


- Obtain the terpcopter_msgs package and move it into your catkin_ws/src
  e.g. /home/wolek/catkin_ws/src/terpcopter_msgs

- From catkin_ws run:
  $ catkin_make

- Modify the params.terpcopterRosDir field in loadParams.m to give the absolute
  path to your catkin_ws/src folder. Do not modify params.env.terpcopterMatlabMsgs. 
  Save loadParams.m 

- Run updatePaths.m
  All of the folder icons in the matlab directory window should change from
  transparent to solid (indicating they are now in MATLAB's pathu).
  If you receive a warning that you cannot update pathdef.m  you may need  
  to change permissions of that file. 

- Run updateMsgs.m and follow on-screen instructions 
  (this will generate custom AMAV ROS messages)

- For instructions for installing the MAVLink toolchain:
  https://mavlink.io/en/getting_started/installation.htm

Running the Example Mission:
---------------------------------------------------------------------------
- The first mission requires 4 instances of MATLAB, one for each of the nodes 
  and one for the rosmaster. 

- If you can only start a single instance of MATLAB from the GUI, then launch
  each one from the terminal with the command:
  $ matlab &

  If you receive the error: "No command 'matlab' found"
  Then, you must update your PATH variable.
    - first determine where the 'matlab' program is located by running:
      $ sudo updatedb
      $ locate bin/matlab  
    - You should see a folder such as: /usr/local/MATLAB/R2018a/bin/matlab
    - Open your .bashrc file for editing
      $ gedit ~/.bashrc
    - Scroll to the bottom and add the following line:
      PATH=$PATH:/usr/local/MATLAB/R2018a/bin/
      Note: change the above line to match your specific system (i.e., to match
      the output from the locate bin/matlab) command
    - Click save, and close gedit
    - Run your .bashrc script for the change to take effect
      $ source ~/.bashrc
    - You can confirm the PATH has been updated by check that your entry has 
      been added:
      $ echo $PATH

- In each MATLAB window, navigate the the terpcopter19/matlab folder.

- If the subdirectory icons are transparent in the Current Folder window,
  you must run (in each window): 
  >> updatePaths
    
  Note: you can modify your path.def file permanently to avoid this step.
  Note: It is important that you run the updatePaths step before calling any ROS
  related functions (e.g., rosinit, rosmsg list) 

- Once you have updated your path, you can verify that the terpcopter_msgs are
  available to matlab by runing:
  >> rosmsg list

  and scrolling through the list to see terpcopter_msgs listed.

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

- Install the interface for ROS Custom messages (if you have not done so):
  https://www.mathworks.com/matlabcentral/fileexchange/49810-robotics-system-toolbox-interface-for-ros-custom-messages

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


