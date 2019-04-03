#File Description: This is a library script for river detection
# implementation of river detection pipeline -> (Detect blue color-get the borders-apply RANSAC for orientation)
import cv2
import numpy as np
    
def riverDetection(frame):
    h_image,w_image= frame.shape[:2] #here we store width and height of frame
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    v = np.median(frame)
    lower = int(max(0,(1.0-0.33)*v))
    higher = int(max(255,(1.0+0.33)*v))
    kernel = np.ones((5,5), np.uint8)
    lower_river = np.array([0,0,51])
    higher_river = np.array([102,255,255])
    masking_river = cv2.inRange(hsv_frame, lower_river, higher_river)
    frame_blur_river = cv2.bilateralFilter(masking_river, 9, 75, 75)

    
    cv2.imshow("Target", frame_blur_river)
    
#################################################
# Use this code when not connected to ros master
cap = cv2.VideoCapture(1)

while cap.isOpened():
    ret, frame = cap.read()
    dropOffDetection(frame)
    key = cv2.waitKey(1)
    if key == 27:
         break
##################################################
cap.release()
cv2.destroyAllWindows()