#!/usr/bin/env python
# Copyright (c) 2019, AMAV Team.
# All rights reserved.
## Image processing code for the target detection and alignment


import rospy
import cv2
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

# publisher function, punlishes the video from the plugged-in camera
def imagePublisher():
    cap = cv2.VideoCapture(1)
    pub = rospy.Publisher('camera', Image, queue_size=10)
    rospy.init_node('imagePublisher', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        ret, frame = cap.read()
        image_message = CvBridge().cv2_to_imgmsg(frame, encoding="passthrough")
        pub.publish(image_message)
        rate.sleep()
#main loop
if __name__ == '__main__':
    try:
        imagePublisher()
    except rospy.ROSInterruptException:
        pass
