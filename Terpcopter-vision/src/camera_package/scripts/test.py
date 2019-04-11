import rospy
try:
    sys.path.remove('/opt/ros/kinetic/lib/python2.7/dist-packages')
except:
    pass
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
import redDotDetect
import autoCannyVideo
from yawControl import yaw_control

detector = cv2.SimpleBlobDetector_create()
params = cv2.SimpleBlobDetector_Params()

params.filterByArea = True
params.minArea = 5000
params.maxArea = 100000
params.filterByColor = True
params.blobColor = 255

detector = cv2.SimpleBlobDetector_create(params)
#autoCannyVideo.blob_detect(cv_image,detector)
video = cv2.VideoCapture(1)
while(True):
    ret,frame = video.read()
    autoCannyVideo.objectDetection(frame,detector)




    if cv2.waitKey(1) & 0xff==ord('q'):
        cv2.destroyAllWindows()
        break
