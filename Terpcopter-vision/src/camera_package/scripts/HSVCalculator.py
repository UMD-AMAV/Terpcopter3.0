# File Description
# This script can be used for tuning any color from the HSV coloe space
# It generates an HSV tracbar to change the HSV values for the mask and tune it

import cv2
import numpy as np
import matplotlib.pyplot as plt

def nothing(x):
    pass

cap = cv2.VideoCapture(1)
cv2.namedWindow("Trackbars",)
cv2.createTrackbar("lh","Trackbars",0,179,nothing)
cv2.createTrackbar("ls","Trackbars",0,255,nothing)
cv2.createTrackbar("lv","Trackbars",0,255,nothing)
cv2.createTrackbar("uh","Trackbars",179,179,nothing)
cv2.createTrackbar("us","Trackbars",255,255,nothing)
cv2.createTrackbar("uv","Trackbars",255,255,nothing)

while True:
    ret, frame = cap.read()
    height, width = frame.shape[:2]
    hsv = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
    kernel = np.ones((5,5), np.uint8)

    lh = cv2.getTrackbarPos("lh","Trackbars")
    ls = cv2.getTrackbarPos("ls","Trackbars")
    lv = cv2.getTrackbarPos("lv","Trackbars")
    uh = cv2.getTrackbarPos("uh","Trackbars")
    us = cv2.getTrackbarPos("us","Trackbars")
    uv = cv2.getTrackbarPos("uv","Trackbars")

    l_tuned = np.array([lh,ls,lv])
    u_tuned = np.array([uh,us,uv])
    
    mask = cv2.inRange(hsv, l_tuned, u_tuned)
    mask_erode = cv2.erode(mask, kernel, iterations = 2)
    result = cv2.bitwise_and(frame,frame,mask=mask)

    cv2.imshow("Obstacle",frame)
    cv2.imshow("mask",mask)
    cv2.imshow("result",result)
    cv2.imshow("maskEroded", mask_erode)
    key = cv2.waitKey(1)
    if key == 27:
         break

cap.release()
cv2.destroyAllWindows()