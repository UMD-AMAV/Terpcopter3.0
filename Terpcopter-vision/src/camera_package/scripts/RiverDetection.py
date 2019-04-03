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
    erosion = cv2.erode(frame_blur_river,kernel,iterations = 1)
    autoEdge_river = cv2.Canny(erosion, lower, higher)
    ######################################################################
    #Detecting lines in the blue colored masked image line given in green
    linesP = cv2.HoughLinesP(autoEdge_river, 1, np.pi / 180, 50, None, 50, 10)
    if linesP is not None:
        for i in range(0, len(linesP)):
            l = linesP[i][0]
            cv2.line(frame, (l[0], l[1]), (l[2], l[3]), (0,255,0), 3, cv2.LINE_AA)
    
    ######################################################################
    #Draw contours where yellow contours are area thresholed contours and red are all the possible contours
    contours_river, hierarchy = cv2.findContours(frame_blur_river,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) 
    if len(contours_river) > 0:
          c = max(contours_river,key = cv2.contourArea)
          for c1 in contours_river:
               cv2.drawContours(frame, c1, -1, (0,0,255), 1)
               #print(cv2.contourArea(c1))
               if(cv2.contourArea(c1)>9000 and cv2.contourArea(c1)<35000):
                    cv2.drawContours(frame, c1, -1, (0,255,255), 2)
    
    cv2.imshow("Target", frame)
    cv2.imshow("Edges", autoEdge_river)
    
#################################################
# Use this code when not connected to ros master
cap = cv2.VideoCapture(1)

while cap.isOpened():
    ret, frame = cap.read()
    riverDetection(frame)
    key = cv2.waitKey(1)
    if key == 27:
         break
##################################################
cap.release()
cv2.destroyAllWindows()