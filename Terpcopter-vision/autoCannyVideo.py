import cv2
import numpy as np
import math
import skimage.transform
video = cv2.VideoCapture(1)
if not video:
 print "NO video found!!"
while True:
#frame = cv2.imread("drop1.png") #Capture the current frame in the video
    ret,frame = video.read()
    w_image,h_image= frame.shape[:2] #here we store width and height of frame
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    v = np.median(frame)
    lower = int(max(0,(1.0-0.33)*v))
    higher = int(max(255,(1.0+0.33)*v))
	#lower_yellow = np.array([10,94,140])  #set the lower bound for yellow
	#higher_yellow = np.array([40,255,255]) #set the higher bound for yellow
    lower_red = np.array([0,70,50])
    higher_red = np.array([10,255,255])
    lower_black = np.array([0,0,0])
    higher_black = np.array([180,255,30])
    masking_black = cv2.inRange(hsv_frame, lower_black, higher_black) #with both the yellow color limits we detect yellow color from the image
    masking_red = cv2.inRange(hsv_frame, lower_red, higher_red)
    #frame_blur = cv2.GaussianBlur(masking,(3, 3), 0)
    frame_blur = cv2.bilateralFilter(masking_black, 9, 75, 75)
    autoEdge = cv2.Canny(frame_blur, lower, higher)
    #ret,thresh = cv2.threshold(masking_black,127,255,0) #making the image binary
    im2, contours, hierarchy = cv2.findContours(autoEdge,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) #finding the contour around the yellow region
    contourFound = 0
    src = np.array([[0,0],[w_image-2,0],[0,h_image-2]], dtype = "float32")
    final = np.array([[0,0],[w_image,0],[0,h_image]], dtype = "float32")
    M = cv2.getAffineTransform(src, final)
    if len(contours) > 0:
          contourFound = 1
          c = max(contours,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
          for c1 in contours:
               (x,y,w,h) = cv2.boundingRect(c1)
               if w > 80 and h > 80:

                     approx = cv2.approxPolyDP(c1, 0.01*cv2.arcLength(c1, True), True)
                     #print(len(approx))
                       #cv2.rectangle(frame, (x,y), (x+w,y+h), (0, 255, 0), 2)
                     if(len(approx) == 4):
                            (xf,yf,wf,hf) = cv2.boundingRect(c1)
                            extLeft = tuple(c1[c1[:, :, 0].argmin()][0])
                            extRight = tuple(c1[c1[:, :, 0].argmax()][0])
                            extTop = tuple(c1[c1[:, :, 1].argmin()][0])
                            extBot = tuple(c1[c1[:, :, 1].argmax()][0])
                            cv2.putText(frame,'PickArea Detected', (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 0, 0),2, lineType=cv2.LINE_AA)
                            cv2.drawContours(frame, c1, -1, (0,255,255), 2)
                            cv2.circle(frame, extLeft, 5, (0, 0, 255), -1)
                            cv2.circle(frame, extRight, 6, (0, 255, 0), -1)
                            cv2.circle(frame, extTop, 7, (255, 0, 0), -1)
                            cv2.circle(frame, extBot, 8, (255, 255, 0), -1)
                            cv2.circle(frame, (xf,yf), 10, (0, 0, 255), -1)
                            cv2.circle(frame, (xf+wf,yf+hf), 11, (0, 255, 0), -1)
                            cv2.circle(frame, (xf+wf,yf), 12, (255, 0, 0), -1)
                            cv2.circle(frame, (xf,yf+hf), 13, (255, 255, 0), -1)
                            cv2.rectangle(frame, (xf,yf), (xf+wf,yf+hf), (0, 255, 0), 2)
                            previous = np.array([extLeft,extRight,extTop,extBot], dtype = "float32")
                            final = np.array([[xf,yf],[xf+wf,yf+hf],[xf+wf,yf],[xf,yf+hf]], dtype = "float32")
                            H,status = cv2.findHomography(previous,final)
                            warp = cv2.warpPerspective(frame,H,(frame.shape[1],frame.shape[0]))
                            # M = cv2.getAffineTransform(previous, final)
                            # warp = skimage.transform.rotate(frame,30)
                            cv2.imshow("Wrapping", warp)
                            break
    frame_blur_red = cv2.bilateralFilter(masking_red, 9, 75, 75)
    autoEdge_red = cv2.Canny(frame_blur_red, lower, higher)
    #ret,thresh = cv2.threshold(masking_black,127,255,0) #making the image binary
    im2_red, contours_red, hierarchy_red = cv2.findContours(autoEdge_red,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) #finding the contour around the yellow region
    contourFound = 0
    if len(contours_red) > 0:
          contourFound = 1
          c = max(contours_red,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
          for c1 in contours_red:
               (x,y,w,h) = cv2.boundingRect(c1)
               if w > 80 and h > 80:

                     approx = cv2.approxPolyDP(c1, 0.01*cv2.arcLength(c1, True), True)
                     #print(len(approx))
                       #cv2.rectangle(frame, (x,y), (x+w,y+h), (0, 255, 0), 2)
                     if(len(approx) > 10):
                            (xf,yf,wf,hf) = cv2.boundingRect(c1)
                            extLeft = tuple(c1[c1[:, :, 0].argmin()][0])
                            extRight = tuple(c1[c1[:, :, 0].argmax()][0])
                            extTop = tuple(c1[c1[:, :, 1].argmin()][0])
                            extBot = tuple(c1[c1[:, :, 1].argmax()][0])
                            previous = np.array([extLeft,extRight,extTop,extBot], dtype = "float32")
                            final = np.array([[xf,yf],[xf+wf/2,yf+hf/2],[xf+wf/2,yf],[xf,yf+hf/2]], dtype = "float32")
                            cv2.putText(frame,'Dropoff Detected', (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 0),2, lineType=cv2.LINE_AA)
                            cv2.drawContours(frame, c1, -1, (0,255,0), 2)
                            cv2.circle(frame, extLeft, 8, (0, 0, 255), -1)
                            cv2.circle(frame, extRight, 8, (0, 255, 0), -1)
                            cv2.circle(frame, extTop, 8, (255, 0, 0), -1)
                            cv2.circle(frame, extBot, 8, (255, 255, 0), -1)
                            cv2.circle(frame, (xf,yf+hf/2), 10, (0, 0, 255), -1)
                            cv2.circle(frame, (xf+wf,yf+hf/2), 10, (0, 255, 0), -1)
                            cv2.circle(frame, (xf+wf/2,yf), 10, (255, 0, 0), -1)
                            cv2.circle(frame, (xf+wf/2,yf+hf), 10, (255, 255, 0), -1)
                            H,status = cv2.findHomography(previous,final)
                            warp = cv2.warpPerspective(frame,H,(frame.shape[1],frame.shape[0]))
                            cv2.imshow("Wrapping", warp)
                            break
    #final = np.array([[xf,yf+hf/2],[xf+wf,yf+hf/2],[xf+wf/2,yf],[xf+wf/2,yf+hf]], dtype = "float32")
    # warp = cv2.warpAffine(frame, M, (w_image, h_image))
    cv2.imshow("Image", frame)
    key = cv2.waitKey(25)
    if key == 27:
        cv2.destroyAllWindows()
        #cv2.waitKey(0)
video.release()
cv2.destroyAllWindows()
