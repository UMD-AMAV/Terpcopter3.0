#include <stdio.h>      // standard input / output functions
#include <stdlib.h>
#include <string>     // string function definitions
#include <unistd.h>     // UNIX standard function definitions
#include <fcntl.h>      // File control definitions
#include <errno.h>      // Error number definitions
#include <termios.h>    // POSIX terminal control definitions
#include "ros/ros.h"
#include "std_msgs/Float32.h"

// TODO :  
// - Add serial port close command at end
// - Add check in while loop if port is open, 
//   if not cycle through other ACM ports
// - fix mavros serial port issue (mostly change this serial port to ACM1)
// - Comment code

int main(int argc, char** argv)
{
int flowPort, res, cnt;
struct termios oldtio,newtio;
char buf[255];
char airspeedX[3];
char airspeedY[3];
uint8_t ii = 0;
float flowvec[2];
bool STOP =false;

ros::init(argc, argv, "terpcopter_flow_probe_node");
ros::NodeHandle nh("~");

std::string portStr;
nh.param("serial_port", portStr, std::string("/dev/ttyACM1"));

int baudrate;
nh.param("baudrate", baudrate, 9600);

// Publishers
ros::Publisher fp = nh.advertise<std_msgs::Float32>("flowProbe", 1);

ros::Rate loop_rate(10);


// Open serial port
// O_RDWR - Read and write
// O_NOCTTY - Ignore special chars like CTRL-C

flowPort = open(portStr.c_str(), O_RDWR | O_NOCTTY);

if (flowPort == -1)
{
ROS_ERROR("%s could not open serial port %s", ros::this_node::getName().c_str(), portStr.c_str());
return false;
}
else
{
fcntl(flowPort, F_SETFL, 0);
}

memset(&newtio,0,sizeof(newtio)); // clear struct for new port settings

cfsetispeed(&newtio, baudrate); // Input port speed
cfsetospeed(&newtio, baudrate); // Output port speed

newtio.c_cflag &= ~PARENB; // no parity bit
newtio.c_cflag &= ~CSTOPB; // 1 stop bit
newtio.c_cflag &= ~CSIZE; // Only one stop bit
newtio.c_cflag |= CS8; // 8 bit word

newtio.c_iflag = 0; // Raw output since no parity checking is done
newtio.c_oflag = 0; // Raw output
newtio.c_lflag = 0; // Raw input is unprocessed
//newtio.c_cflag = 0;

newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
newtio.c_cc[VMIN]     = 5;   /* blocking read until 5 chars received */

tcflush(flowPort, TCIFLUSH);
tcsetattr(flowPort, TCSANOW, &newtio);

ROS_INFO("sdf");
while (STOP == false) 
{       
	std_msgs::Float32 msg;
	
	res = read(flowPort,buf,255);   
	buf[res]=0;               
	ROS_INFO(":%s:%d", buf, res);
	for (ii=0; ii<2; ii++) 
	{
		airspeedX[ii] = buf[ii+1];
		airspeedY[ii] = buf[ii+3];
	}
	airspeedX[2] = '\0';
	airspeedY[2] = '\0';

	flowvec[0] = ((atoi(airspeedX)-50.0f)/5.0f); 
	flowvec[1] = (atoi(airspeedY)-50.0f)/5.0f; 
	
	ROS_INFO(" :%f :%f \n",flowvec[0],flowvec[1]);

	msg.data = flowvec[0];
	
	fp.publish(msg);
	
	loop_rate.sleep();

}
ros::spin();

return 0;

}
