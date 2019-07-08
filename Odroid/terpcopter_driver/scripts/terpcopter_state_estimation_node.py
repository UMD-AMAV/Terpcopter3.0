#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String, Float32
from mavros_msgs.msg import AttitudeTarget,State, Thrust, RCIn
from mavros_msgs.srv import SetMode, SetModeRequest, SetModeResponse
from geometry_msgs.msg import PoseStamped, Vector3, Quaternion
from sensor_msgs.msg import BatteryState, JointState
import config
import tf.transformations
import numpy as np
import time

#MOCAP
from nav_msgs.msg import Odometry 

class state_estimate:

	def __init__(self):

		self.filter_mocap = False
		self.filter_vio = False

		self.mocap_filt_wind = np.zeros(9)
		self.vio_filt_wind = np.zeros(9)

		self.use_mocap = True
		self.mocap_model_name = 'quad_1'

		self.mocap_cb_flag = False
		self.mocap_data = Odometry()
		self.mocap_sub = rospy.Subscriber('/mocap_data' + str(self.mocap_model_name) + '/odom', Odometry, self.mocap_callback)

		self.vio_data = Odometry()
		self.vio_sub = rospy.Subscriber('/camera/odom/sample', Odometry, self.vio_callback)

		
		self.vision_pub = rospy.Publisher('/mavros/vision_pose/pose', PoseStamped, queue_size = 10)
		self.vision_data = PoseStamped()


	def mocap_callback(self,data):

		self.mocap_data = data

		if self.filter_mocap:

			## TODO: Write filter

	def vio_callback(self,data):

		self.vio_data = data

	def publish_state(self):


		rate = rospy.Rate(100) # 10hz

		
		while not rospy.is_shutdown():


			if not self.mocap_cb_flag:
				print("\nCan't receive mocap messages.\n")

			if use_mocap == True:

				self.vision_data.pose = self.mocap_data.pose.pose
				# self.vision_data.header.stamp = rospy.Time.now()
				self.vision_data.header = self.mocap_data.header

			else:
				self.vision_data.pose = self.vio_data.pose.pose
				self.vision_data.header = self.vio_data.header

			self.vision_pub.publish(vision_data)

			rate.sleep()






def main():
	rospy.init_node('terpcopter_state_estimation_node', anonymous=True)

	test = state_estimate()
	test.publish_state()

if __name__ == '__main__':
	try:
		main()
	except rospy.ROSInterruptException:
		pass
