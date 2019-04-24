import rospy
import cv2
import numpy as np
from std_msgs.msg import Bool
from std_msgs.msg import Float32

    
def dropOffDetection(frame):
    pubDropOffX = rospy.Publisher('targetPixelX', Float32, queue_size=10)
    pubDropOffY = rospy.Publisher('targetPixelY', Float32, queue_size=10)
    pubDropOffDetected = rospy.Publisher('targetDetected', Bool, queue_size=10)
    dropOffDetected = False
    centerX, centerY = -10000.0, -10000.0
    h_image,w_image= frame.shape[:2] #here we store width and height of frame
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    v = np.median(frame)
    lower = int(max(0,(1.0-0.33)*v))
    higher = int(max(255,(1.0+0.33)*v))
    kernel = np.ones((5,5), np.uint8)
    lower_red = np.array([0,70,50])
    higher_red = np.array([10,255,255])
    lower_white = np.array([0,0,222])
    higher_white = np.array([102,141,255])
    masking_red = cv2.inRange(hsv_frame, lower_red, higher_red)
    masking_white = cv2.inRange(hsv_frame, lower_white, higher_white)
    #masking_target = cv2.bitwise_or(masking_red, masking_white)
    frame_blur_red = cv2.bilateralFilter(masking_red, 9, 75, 75)
    frame_blur_white = cv2.bilateralFilter(masking_white, 9, 75, 75)
    #rgb_img = cv2.cvtColor(frame_blur, cv2.COLOR_GRAY2BGR)
    #frame_blur_gray = cv2.cvtColor(rgb_img, cv2.COLOR_BGR2GRAY)
    redCenter = []
    redContour = []
    whiteCenter= []
    whiteContour = []
    autoEdge_red = cv2.Canny(frame_blur_red, lower, higher)
    #contours_red, hierarchy = cv2.findContours(autoEdge_red,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)
    i,contours_red, hierarchy = cv2.findContours(autoEdge_red,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)     
    contourFoundRed = False
    if len(contours_red) > 0:
          c = max(contours_red,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
          for c1 in contours_red:
               (x,y,w,h) = cv2.boundingRect(c1)
               if w > 80 and h > 80:
                     approx = cv2.approxPolyDP(c1, 0.01*cv2.arcLength(c1, True), True)
                     if(len(approx) > 10):
                            contourFoundRed = True
                            ellipse = cv2.fitEllipse(c1)
                            M = cv2.moments(c1)
                            cX = int(M["m10"] / M["m00"])
                            cY = int(M["m01"] / M["m00"])
                            #cv2.ellipse(frame,ellipse,(0,255,255),2)
                            (xf,yf,wf,hf) = cv2.boundingRect(c1)
                            #cv2.putText(frame,'Dropoff Detected', (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
                            #cv2.drawContours(frame, c1, -1, (0,255,0), 2)
                            redContour.append(ellipse)
                            redCenter.append((cX,cY))
                            break
    autoEdge_white = cv2.Canny(frame_blur_white, lower, higher)
    #contours_white, hierarchy = cv2.findContours(autoEdge_white,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)
    i,contours_white, hierarchy = cv2.findContours(autoEdge_white,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)     
    contourFoundWhite = False
    if len(contours_white) > 0:
          c = max(contours_white,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
          for c1 in contours_white:
               (x,y,w,h) = cv2.boundingRect(c1)
               if w > 80 and h > 80:
                     approx = cv2.approxPolyDP(c1, 0.01*cv2.arcLength(c1, True), True)
                     if(len(approx) > 10):
                            contourFoundWhite = True
                            ellipse = cv2.fitEllipse(c1)
                            M = cv2.moments(c1)
                            cX = int(M["m10"] / M["m00"])
                            cY = int(M["m01"] / M["m00"])
                            #cv2.ellipse(frame,ellipse,(255,0,0),2)
                            (xf,yf,wf,hf) = cv2.boundingRect(c1)
                            #cv2.putText(frame,'Dropoff Detected', (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
                            #cv2.drawContours(frame, c1, -1, (0,255,0), 2)
                            whiteContour.append(ellipse)
                            whiteCenter.append((cX,cY))
                            break
    if(contourFoundRed and contourFoundWhite):
        if(abs(redCenter[0][0] - whiteCenter[0][0]) < 10 and abs(redCenter[0][1] - whiteCenter[0][1]) < 10):
            cv2.ellipse(frame, redContour[0], (0,255,0),2)
            cv2.putText(frame,'Dropoff Detected Strong Detection', redCenter[0], cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
            dropOffDetected = True
            centerX = (w_image/2 - redCenter[0][0])
            centerY = (h_image/2 - redCenter[0][1])
        else:
            cv2.ellipse(frame, redContour[0], (0,255,255),2)
            cv2.putText(frame,'Dropoff Detected Weak Detection', redCenter[0], cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
            dropOffDetected = True
            centerX = (w_image/2 - redCenter[0][0])
            centerY = (h_image/2 - redCenter[0][1])

    elif(contourFoundRed and (not contourFoundWhite)):
            cv2.ellipse(frame, redContour[0], (0,255,255),2)
            cv2.putText(frame,'Dropoff Detected Weak Detection', redCenter[0], cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
            dropOffDetected = True
            centerX = (w_image/2 - redCenter[0][0])
            centerY = (h_image/2 - redCenter[0][1])
    

    pubDropOffDetected.publish(dropOffDetected)
    pubDropOffX.publish(centerX)
    pubDropOffY.publish(centerY)
    cv2.imshow("DropOffTarget", frame)
    #cv2.imshow("Blure Frame", frame_blur)
    cv2.waitKey(1)

'''
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
'''
