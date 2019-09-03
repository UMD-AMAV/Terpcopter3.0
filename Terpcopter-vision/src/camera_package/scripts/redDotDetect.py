import rospy
import cv2
import numpy as np
import math
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
from _feedback import feedback
from _targetPose import targetPose
# import redDotDetect
# import autoCannyVideo
# global hError, vError

def imageProcessing(frame):
    pubIP = rospy.Publisher('targetPose', targetPose, queue_size=10)
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    w,h= frame.shape[:2]
    autoEdge = cv2.Canny(frame, 300, 600)
    im2, contours, hierarchy = cv2.findContours(autoEdge,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)

    if len(contours) > 0:
		contour_detected = 1
		c = max(contours,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
		M = cv2.moments(c) #finding the centre of that contour
		if(M['m00']!=0):
			cX = int(M['m10'] / M['m00'])
			cY = int(M['m01'] / M['m00'])
		else:
			cX=0
			cY=0
		cv2.line(frame,(int(w/2),0),(int(w/2), w),(0,255,0),1)
		cv2.line(frame,(0,cY),(h, cY),(0,255,0),1)
		cv2.circle(frame,(cX,cY ), 5 ,(0,0,255),-1) #to locate the centre of frame which we assume to be quad
		cv2.line(frame,(h/2,w/2),(cX, w/2),(0,0,255),1)
		cv2.line(frame,(h/2,w/2),(h/2, cY),(0,0,255),1)
		distx = math.sqrt(math.pow(h/2-cX,2))
		disty = math.sqrt(math.pow(w/2-cY,2))
		#cv2.drawContours(frame, contours, -1, (0,255,0), 1)
    else:
    		contour_detected = 0

	#print distx,"  ", disty
    if(contour_detected==1):
    	distX = str(int(distx))#"{:2d}".format(dist)
    	distY = str(int(disty))
    #error in horizontal direction
    	hError = int(distx);
    #error in vertical direction
    	vError = int(disty);
        if cX>h/2:
        	cv2.putText(frame,"move right", (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
        else:
        	hError = (-1)*hError
		cv2.putText(frame,"move left", (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
        if cY>w/2:
		cv2.putText(frame,"move down", (100, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
        else:
        	vError = (-1)*vError
		cv2.putText(frame,"move up", (100, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    else:
        distX = "Nan"#"{:2d}".format(dist)
    	distY = "Nan"
    #error in horizontal direction
    	hError = 0;
    #error in vertical direction
    	vError = 0;

	#The output is displayed on the frame in the form of:
	#  (dist in X axis)   move (direction)     to reach the goal
	#  (dist in Y axis)   move (direction)     to reach the goal
    cv2.putText(frame,distX, (10, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)
    cv2.putText(frame,distY, (10, 200), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255),2, lineType=cv2.LINE_AA)

    #no need to show image while running the code
    #a = feedback()
    a = targetPose()
    #a.datafb = [hError,vError]
    a.u = hError
    a.v = vError
    a.targetName = 'RedDot'
    pubIP.publish(a)
    cv2.imshow("frames", autoEdge)
    cv2.waitKey(3)
    # return hError, vError
