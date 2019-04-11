import rospy
import cv2
import numpy as np
import math
from std_msgs.msg import String
from sensor_msgs.msg import Image
from sensor_msgs.msg import CompressedImage
from cv_bridge import CvBridge, CvBridgeError
from _feedback import feedback


def yaw_control(frame):
    rospy.Subscriber('/stateEstimate', stateEstimate, callbackYaw)
    yaw_des = math.atan(dy/dx)
    # yaw_est = from state estimate
    # dt = time error
    err_yaw = yaw_est - yaw_des
    err_yaw_dot = (yaw_est - yaw_des)/dt
    err_yaw_sum += err_yaw_sum*dt


    u = -kp*err_yaw -kd*err_yaw_dot - ki*err_yaw_sum
