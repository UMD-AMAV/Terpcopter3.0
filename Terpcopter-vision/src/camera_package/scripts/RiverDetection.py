#File Description: This is a library script for river detection
# implementation of river detection pipeline -> (Detect blue color-get the borders-apply RANSAC for orientation)
import rospy
import cv2
import numpy as np
import math
from std_msgs.msg import Float32
from std_msgs.msg import Bool

def finEuc(x1,x2,y1,y2):
    ans = math.sqrt(((x1-y1)**2) + ((x2-y2)**2))
    return ans

def riverDetection(frame,pubRiverXleft,pubRiverXright,pubRiverPitch,pubRiverDetected) :
	fx =  398.0713021078931
	fy = 397.9156958293253
	cx = 329.564990755235
	cy =  258.3104012769753

	k1 = -0.3148776462826097
	k2 = 0.1025927078109733
	p1 = -0.0005061499742218966
	p2 = -0.0004452786525987435
	k3 = 0
	dist = np.array([[fx,0,cx],[0,fy,cy],[0,0,1]])
	d = np.array([k1,k2,p1,p2,k3])
	h_image,w_image= frame.shape[:2] #here we store width and height of frame
	frame = cv2.undistort(frame, dist, d)
	hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition

	v = np.median(frame)
	lower = int(max(0,(1.0-0.33)*v))
	higher = int(max(255,(1.0+0.33)*v))
	kernel = np.ones((5,5), np.uint8)
	lower_river = np.array([73,152,37]) 
	higher_river = np.array([179,255,255])
	masking_river = cv2.inRange(hsv_frame, lower_river, higher_river)
	frame_blur_river = cv2.bilateralFilter(masking_river, 9, 75, 75)
	erosion = cv2.erode(frame_blur_river,kernel,iterations = 1)
	autoEdge_river = cv2.Canny(erosion, lower, higher)
	rowArray = np.where(autoEdge_river > 0)[0]
	colArray = np.where(autoEdge_river > 0)[1]
	flag=False
	pitchPoint=-10000
	yMin1 = -10000
	yMin2 = -10000
	if (rowArray.shape[0]!=0):
		flag=True

		xMax = np.argmax(colArray)
		xMin = np.argmin(colArray)
		yMin1 = 240 - np.max(rowArray[xMin])
		yMin2 = 240 - np.max(rowArray[xMax])
		print(yMin1)
		centerRow = autoEdge_river[:,320]
		#print(centerRow.shape)
		pitchPoint = np.where(centerRow>0)[0]
		#print(pitchPoint)
		if (len(pitchPoint)!=0):	
			pitchPoint = 240 - np.max(pitchPoint)
		#Publish values	
	pubRiverPitch.publish(pitchPoint)
	pubRiverXleft.publish(yMin1)
	pubRiverXright.publish(yMin2)
	pubRiverDetected.publish(flag)
	#pitchPoint = np.where(centerRow>0)[1]
	#poitchDist = np.arg 
	#print(pitchPoint)   
	######################################################################
	#Detecting lines in the blue colored masked image line given in green
	'''
	linesP = cv2.HoughLinesP(autoEdge_river, 1, np.pi / 180, 50, None, 50, 10)
	lineLengths = []
	lineLinePoint = []
	if linesP is not None:
		for i in range(0, len(linesP)):
		    l = linesP[i][0]
		    
		    length = finEuc(l[0],l[2],l[1],l[3])
		    lineLengths.append(length)
		    lineLinePoint.append(l)

	maxL = 0
	for i in range(0,len(lineLengths)):
		for j in range(0,len(lineLengths)):
		    if(lineLengths[i]  > lineLengths[j]):
		        temp = lineLengths[i]
		        lineLengths[i] = lineLengths[j]
		        lineLengths[j] = temp
		        tempP = lineLinePoint[i]
		        lineLinePoint[i] = lineLinePoint[j]
		        lineLinePoint[j] = tempP

	l = lineLinePoint[0]
	'''
	#cv2.line(frame, (l[0], l[1]), (l[2], l[3]), (0,255,255), 3, cv2.LINE_AA)
	######################################################################
	#Draw contours where yellow contours are area thresholed contours and red are all the possible contours
	img, contours_river, hierarchy = cv2.findContours(frame_blur_river,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) 
	if len(contours_river) > 0:
		  c = max(contours_river,key = cv2.contourArea)
		  #for c1 in contours_river:
		       #cv2.drawContours(frame, c1, -1, (0,0,255),1)
		       #print(cv2.contourArea(c1))
		       #if(cv2.contourArea(c1)>9000 and cv2.contourArea(c1)<35000):
		            #cv2.drawContours(frame, c1, -1, (0,255,255), 1)

	cv2.imshow("Target", frame)
	# cv2.imshow("Eroded", erosion)
	cv2.imshow("Edges", autoEdge_river)
	cv2.waitKey(1)
	#################################################
	# Use this code when not connected to ros master

	#cap = cv2.VideoCapture(0)

	#path = "C:\DesktopExtra\AMAV\Terpcopter3.0\Terpcopter-vision\src\camera_package\scripts\TestData1\image"
	#it = 100
	#while(True) :
	#    ret, frame = cap.read()
	#    #pa = path + str(it) + ".png"
	#    #frame = cv2.imread(pa)
	##    riverDetection(frame)
	#    key = cv2.waitKey(10)
	#    #it += 1
	#    if key == 27:
	#         break
	##################################################
	#cap.release()
	#cv2.destroyAllWindows()
