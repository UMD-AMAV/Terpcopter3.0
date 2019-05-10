#!/usr/bin/env python
# Copyright (c) 2019, AMAV Team.
# All rights reserved.
## Image processing code for the target detection and alignment

import rospy
import cv2
import numpy as np
import math
from std_msgs.msg import String
from std_msgs.msg import Float32
from sensor_msgs.msg import Image
from sensor_msgs.msg import CompressedImage
from cv_bridge import CvBridge, CvBridgeError
from _feedback import feedback
from _stateEstimate import stateEstimate
from _targetPose import targetPose
# import ObstacleDetection
import ObstacleAvoidance
import HBaseDetector
import DropOffDetection
global frameCounter
try:
    sys.path.remove('/opt/ros/kinetic/lib/python2.7/dist-packages')
except:
    pass


###############################################################################
# Image callback function
# Description
#       Callback function that subscribes to '/terpcopter/cameras/forward/image/compressed' topic
# Input Parameter: data - RGB image frame data of datatype-(CompressedImage)

def callbackImage(data):
    
    np_array = np.fromstring(data.data,np.uint8)   #Loading data in np array
    cv_image = cv2.imdecode(np_array, cv2.IMREAD_COLOR)  #Convert image to openCV format

    ###########################################################################
    #Target Detection
    '''
    detector_target = cv2.SimpleBlobDetector_create()
    params1 = cv2.SimpleBlobDetector_Params()
    # Initializing the parameters for color detection using the method of (Blob Detection)
    params1.filterByArea = True
    params1.minArea = 5000
    params1.maxArea = 100000
    params1.filterByColor = True
    params1.blobColor = 255

    detector_target = cv2.SimpleBlobDetector_create(params1)
    '''
    ###########################################################################
    #Obstacle Detection
    #detector_obst = cv2.SimpleBlobDetector_create()
    #params2 = cv2.SimpleBlobDetector_Params()
    # Initializing the parameters for color detection using the method of (Blob Detection)
    #params2.filterByArea = True
    #params2.minArea = 5000
    #params2.maxArea = 100000000
    #params2.filterByColor = True
    #params2.blobColor = 255

    #detector_obst = cv2.SimpleBlobDetector_create(params2)
    ###########################################################################
    # Call external libraries to perform Vision tasks
    # Functions: ObstacleAvoidance - Detects the (pink)obstacle blob in the image frame
    #                   Input Parameters: Image frame in openCV image format, blob detection parameter object
    #            ObstacleDetection - Detects the targets and publishes the Herror
    #                   Input Parameters: Image frame in openCV image format, blob detection parameter object
    #ObstacleAvoidance.obstacleDetection(cv_image, detector_obst)
    # ObstacleDetection.objectDetect(cv_image,detector_target)
    HBaseDetector.HBase(cv_image)
    #DropOffDetection.dropOffDetection(cv_image)

###############################################################################
# Horizontal Error callback function
# Description
#       Callback function that subscribes to 'targetPose' topic
# Input Parameter: data - Data contains horizontal and vertical error of the terpcopter from the detected object in pixel
#                         Also the name of the object detected- (targetPose - [float32, floar32, String])

def callBackError(data):
    hError = data.u     #Horizontal error in pixel Also used as the yawSetpoint
    ###########################################################################
    # Publisher used to publish the yawSetpoint data
    pub = rospy.Publisher('yawSetpoint', Float32, queue_size=10)
    rate = rospy.Rate(10)
    pub.publish(hError)
    rate.sleep()

###############################################################################
# Subscriber Function for the Vision Node
# Description
#           This function handles all the subscription of topics required by the perception of the terpcopter
def imageSubscriber():
    #Subscription Node
    rospy.init_node('imageSubscriber', anonymous=True)
    ###########################################################################
    # Subscribers
    rospy.Subscriber('/camera/image_raw/compressed', CompressedImage, callbackImage, queue_size=1, buff_size=5000000, tcp_nodelay=True)
    rospy.Subscriber('targetPose',targetPose,callBackError)

    rospy.spin()

# main loop
if __name__ == '__main__':
    global frameCounter
    frameCounter = 0
    imageSubscriber()
