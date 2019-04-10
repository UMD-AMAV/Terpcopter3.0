try:
    sys.path.remove('/opt/ros/kinetic/lib/python2.7/dist-packages')
except:
    pass

import cv2
import numpy as np
import math

def eucdist(x1,y1,x2,y2):
    dist = math.sqrt((x1-x2)**2 + (y1-y2)**2)
    return dist


def HBase(frame):
    h_image,w_image= frame.shape[:2] #here we store width and height of frame
    # clahe = cv2.createCLAHE(clipLimit= 2.0) #Contrast Limited Adaptive Histogram Equilization to remove glares
    # frame1 = clahe.apply(cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY))
    hsv_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV) #convert RGB color scheme to HSV color scheme for better color recognition
    v = np.median(frame)
    lower = int(max(0,(1.0-0.33)*v))
    higher = int(max(255,(1.0+0.33)*v))
    kernel = np.ones((5,5), np.uint8)
    lower_black = np.array([0,0,0])
    higher_black = np.array([180,255,30])
    masking_black = cv2.inRange(hsv_frame, lower_black, higher_black) #with both the yellow color limits we detect yellow color from the image

    frame_blur = cv2.bilateralFilter(masking_black, 9, 75, 75)

    autoEdge = cv2.Canny(frame_blur, lower, higher)
    im, contours, hierarchy = cv2.findContours(autoEdge,cv2.RETR_CCOMP,cv2.CHAIN_APPROX_NONE) #for different version of OpenCV we only have 2 values to unpack from findContour
    #im2, contours, hierarchy = cv2.findContours(autoEdge,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE) #finding the contour around the yellow region
    contourFound = 0
    i = 1
    j = 1
    cnt = []
    cntNumber = 0
    hbaseContour = []
    if len(contours) > 0:
          contourFound = 1
          c = max(contours,key = cv2.contourArea) #finding maximum from the set of contours in the given frame
          for c1 in contours:
               (x,y,w,h) = cv2.boundingRect(c1)
               area = cv2.contourArea(c1)
               if area > 5000:  #Tune the area value
                     approx = cv2.approxPolyDP(c1, 0.01*cv2.arcLength(c1, True), True)
                     if(len(approx) > 11 and len(approx) < 13 and j == 1): #Number of edges for H are 12
                            cnt.append(c1)
                            (xf,yf,wf,hf) = cv2.boundingRect(c1)
                            hbaseContour.append([xf-5,yf-5,wf+5,hf+5])
                            cv2.rectangle(frame, (xf,yf), (xf+wf,yf+hf), (0, 255, 0), 1)
                            cv2.putText(frame,'HomeBase', (x+w, y+h), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0),2, lineType=cv2.LINE_AA)
                            j = 0
                            M = cv2.moments(c1)
                            if (M['m00'] != 0):
                                cX = int(M['m10']/M['m00'])
                                cY = int(M['m01']/M['m00'])
                                cv2.circle(frame, (cX,cY),8,(0,0,255),-1)
                            cv2.circle(frame, (int(w_image/2),int(h_image/2)),8,(0,255,0),-1)
                            hError = (w_image/2 - cX)
                            vError = (h_image/2 - cY)
                            cv2.putText(frame,"HError = " + str(hError), (20,20), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0),2, lineType=cv2.LINE_AA)
                            cv2.putText(frame,"VError = " + str(vError), (20,50), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0),2, lineType=cv2.LINE_AA)
          cntNumber += 1
    #Detects the probable lines within the detected home base.
    #We calculate the angle of longest line
    linesP = cv2.HoughLinesP(autoEdge, 1, np.pi / 180, 50, None, 50, 10)
    maxL = 0
    if(len(hbaseContour) > 0):
        if linesP is not None:
            for i in range(0, len(linesP)):
                l = linesP[i][0]
                if(l[0] > hbaseContour[0][0] and l[2] > hbaseContour[0][0] and l[0] < (hbaseContour[0][0] + hbaseContour[0][2]) and l[2] < (hbaseContour[0][0] + hbaseContour[0][2])):
                    if(l[1] > hbaseContour[0][1] and l[3] > hbaseContour[0][1] and l[1] < (hbaseContour[0][1] + hbaseContour[0][3]) and l[3] < (hbaseContour[0][1] + hbaseContour[0][3])):
                        if(eucdist(l[0],l[1],l[2],l[3]) > maxL):
                            longestLine = l
                            maxL = eucdist(l[0],l[1],l[2],l[3])

        cv2.line(frame, (longestLine[0], longestLine[1]), (longestLine[2], longestLine[3]), (0,0,255), 3, cv2.LINE_AA)
        y = longestLine[1] - longestLine[3]
        x = longestLine[0] - longestLine[2]
        angle = math.atan2(y,x)
        angle = math.degrees(angle)
        cv2.putText(frame,"Angle = " + str(angle), (20,80), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0),2, lineType=cv2.LINE_AA)
    # cv2.imshow("Canny out",frame1)


    # cv2.waitKey(1)
    return frame

def main():
    cap = cv2.VideoCapture(1)
    while(True):
        ret, frame = cap.read()
        frame = HBase(frame)
        cv2.imshow("HomeBase", frame)
        if cv2.waitKey(1)& 0xff==ord('q'):
            cv2.destroyAllWindows()
            break
if __name__ == '__main__':
    main()
