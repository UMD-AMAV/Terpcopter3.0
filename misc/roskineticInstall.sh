#! /bin/bash
#AUTHOR: SAIMOULI KATRAGADDA
#LAST UPDATED: 09/21/2018
set -e

echo "Setting up source list"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

echo "setting up your keys" 

sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

echo "updating"
sudo apt-get update 

#echo "will restart"
#sudo restart now

echo "insatlling ros base package"
sudo apt-get install ros-kinetic-ros-base

echo "Initializing rosdep" 
sudo rosdep init
rosdep update

echo "Environment setup"
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "Installing Dependencies" 
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential

echo "Installing MAVROS" 
sudo apt-get install ros-kinetic-mavros ros-kinetic-mavros-extras

echo "Insatlling catkin tools"
sudo apt-get install python-catkin-tools

echo "Installing gazebo msgs"
sudo apt-get install ros-kinetic-gazebo-msgs

echo "Installing cv bridge for vision"
sudo apt-get install ros-kinetic-cv-bridge

echo "you are set to use ros! GO AMAV TERPS!"
