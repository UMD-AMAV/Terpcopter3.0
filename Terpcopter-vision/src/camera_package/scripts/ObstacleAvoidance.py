import rospy
import cv2
import numpy as np
from std_msgs.msg import Bool

# Function to detect the obstacle
def obstacleDetection(frame,detector_obst):
    #Initialize the publisher which publishes True if the obstacle is detected
    FlagIP = rospy.Publisher('targetObst',Bool,queue_size=10)

    ###########################################################################
    #Detection Pipeline
    height, width = frame.shape[:2]
    hsv = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
    l_pink_tuned = np.array([123,10,45])    #Tuned Lower HSV values
    u_pink_tuned = np.array([180,255,255])  #Tuned Higher HSV values
    mask = cv2.inRange(hsv, l_pink_tuned, u_pink_tuned)
    mask_erode = cv2.erode(mask, kernel, iterations = 2)
    result = cv2.bitwise_and(frame,frame,mask=mask)

    keypoints = detector_obst.detect(result)
    draw = cv2.drawKeypoints(frame, keypoints, np.array([]), (0,0,0), cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    obstacleDetected = False

    #Draw a circular spot on the obstacle center
    if (keypoints!=[]):
        (x,y) = keypoints[0].pt
        x = int(x)
        y= int(y)
        cv2.circle(frame,(x,y), 12 ,(128,0,128),-1) #to locate the centre of frame which we assume to be quad
        obstacleDetected = True
    ###########################################################################
    #Publish the boolean
    FlagIP.publish(obstacleDetected)
    cv2.imshow("Obstacle",frame)