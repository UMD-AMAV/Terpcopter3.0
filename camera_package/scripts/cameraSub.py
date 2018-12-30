#!/usr/bin/env python
# Copyright (c) 2019, AMAV Team.
# All rights reserved.
## Image processing code for the target detection and alignment

import rospy
import cv2
import numpy as np
import math
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

#image callback function, no need to change this
def callbackImage(data):
    rospy.loginfo('I heard ')
    cv_image = CvBridge().imgmsg_to_cv2(data, desired_encoding="passthrough")
    imageProcessing(cv_image)
    
#subscriber function which subscribes to the camera topic
def imageSubscriber():
    rospy.init_node('imageSubscriber', anonymous=True)
    rospy.Subscriber('camera', Image, callbackImage)

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()
    
# this is the function where we can make changes to perform image processing tasks 
def imageProcessing(frame):
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    w,h= frame.shape[:2]
    lower_red = np.array([0,70,50])  #set the lower bound for red
    higher_red = np.array([10,255,250]) #set the higher bound for red
    masking = cv2.inRange(hsv_frame, lower_red, higher_red) #with both the red color limits we detect red color from the image 
	
    ret,thresh = cv2.threshold(masking,127,255,0)
    im2, contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)
    
    if len(contours) > 0:
		c = max(contours,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
		M = cv2.moments(c) #finding the centre of that contour
		cX = int(M['m10'] / M['m00'])
		cY = int(M['m01'] / M['m00'])
		cv2.line(frame,(cX,0),(cX, w),(0,255,0),1)
		cv2.line(frame,(0,cY),(h, cY),(0,255,0),1)
		cv2.circle(frame,(cX,cY ), 5 ,(0,0,255),-1) #to locate the centre of frame which we assume to be quad
		cv2.line(frame,(h/2,w/2),(cX, w/2),(0,0,255),1)
		cv2.line(frame,(h/2,w/2),(h/2, cY),(0,0,255),1)
		distx = math.sqrt(math.pow(h/2-cX,2))
		disty = math.sqrt(math.pow(w/2-cY,2))
		#cv2.drawContours(frame, contours, -1, (0,255,0), 1)
		
	#print distx,"  ", disty
    distX = str(int(distx))#"{:2d}".format(dist)
    distY = str(int(disty))
	#The output is displayed on the frame in the form of:
	#  (dist in X axis)   move (direction)     to reach the goal
	#  (dist in Y axis)   move (direction)     to reach the goal
    cv2.putText(frame,distX, (10, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    cv2.putText(frame,distY, (10, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    if cX>h/2:
        cv2.putText(frame,"move right", (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    else: 
	cv2.putText(frame,"move left", (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    if cY>w/2:
	cv2.putText(frame,"move down", (100, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    else: 
	cv2.putText(frame,"move up", (100, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    #no need to show image while running the code
    cv2.imshow("frames", frame)
    cv2.waitKey(3)
    

# main loop 
if __name__ == '__main__':
    imageSubscriber()
