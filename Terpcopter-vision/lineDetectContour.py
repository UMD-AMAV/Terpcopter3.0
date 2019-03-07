import cv2
import numpy as np
import math

#video = cv2.VideoCapture('haartest.mp4')#vid1.mp4 To capture the video from PC Memory
video = cv2.VideoCapture(1)
if not video:
 print "NO video found!!"
while True:
	ret,frame = video.read() #Capture the current frame in the video
	if type(frame) == type(None):
		print("!!! Couldn't read frame!")
		break
	#frame = cv2.imread("caution_tape_noisy.jpg")
	w,h= frame.shape[:2] #here we store width and height of frame
	hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition

	#lower_yellow = np.array([10,94,140])  #set the lower bound for yellow
	#higher_yellow = np.array([40,255,255]) #set the higher bound for yellow
        lower_yellow = np.array([0,70,50])
        higher_yellow = np.array([10,255,255])
	masking = cv2.inRange(hsv_frame, lower_yellow, higher_yellow) #with both the yellow color limits we detect yellow color from the image

	ret,thresh = cv2.threshold(masking,127,255,0) #making the image binary
	im2, contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) #finding the contour around the yellow region
	contourFound = 0
	if len(contours) > 0:
                contourFound = 1
		c = max(contours,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
		M = cv2.moments(c) #finding the centre of that contour

		cX = int(M['m10'] / M['m00'])
		cY = int(M['m01'] / M['m00'])
		(x,y,w,h) = cv2.boundingRect(c)
                if w > 80 and h > 80:
                    cv2.rectangle(frame, (x,y), (x+w,y+h), (0, 255, 0), 2)
		cv2.line(frame,(cX,0),(cX, w),(0,255,0),1)
		cv2.line(frame,(0,cY),(h, cY),(0,255,0),1)
		cv2.circle(frame,(cX,cY ), 5 ,(0,0,255),-1) #to locate the centre of frame which we assume to be quad
		cv2.line(frame,(h/2,w/2),(cX, w/2),(0,0,255),1)
		cv2.line(frame,(h/2,w/2),(h/2, cY),(0,0,255),1)
		distx = math.sqrt(math.pow(h/2-cX,2))
		disty = math.sqrt(math.pow(w/2-cY,2))
		#cv2.drawContours(frame, contours, -1, (0,255,255), 2)

        if(contourFound == 1):
            print distx,"  ", disty
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

        cv2.imshow ("frames", thresh)
        cv2.imshow ("framesActual", frame)

	key = cv2.waitKey(25)
	if key == 27:
		break
video.release()
cv2.destroyAllWindows()
