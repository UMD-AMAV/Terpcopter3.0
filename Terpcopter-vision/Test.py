import cv2
import numpy as np
import math
import skimage.transform
def main():

    img = cv2.imread('/home/abhinav/CMSC-733/Abhi1625_hw0/Phase1/BSDS500/Images/1.jpg')
    w,h,_ = img.shape
    hsv_frame = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    filter = cv2.bilateralFilter(img, 9,25,25)
    v = np.median(filter)
    lower = int(max(0,(1.0-0.33)*v))
    higher = int(max(255,(1.0+0.33)*v))
    Edge = cv2.Canny(filter, lower, higher)
    Edge_y = skimage.transform.rotate(Edge,60)
    w_image,h_image = Edge_y.shape
## Using Affine Transform
    src = np.array([[0,0],[w-2,0],[0,h-2]], dtype = "float32")
    final = np.array([[0,0],[w_image,0],[0,h_image]], dtype = "float32")
    M = cv2.getAffineTransform(src, final)
    warp = cv2.warpAffine(src, M, (w_image, h_image))
    cv2.imshow('Edges',Edge_y)
    cv2.imshow('warp',warp)
    key = cv2.waitKey(0)
    if key==27:
        cv2.imwrite('img',  Edge_y)
        cv2.destroyAllWindows()



if __name__ == '__main__':
    main()
