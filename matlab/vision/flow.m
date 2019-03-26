% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end

image_sub = rossubscriber('/camera/image_raw/compressed');
%opticFlow = opticalFlowLK('NoiseThreshold',0.0005);
msg = receive(image_sub,2);
image = readImage(msg);
image_gray = rgb2gray(image);
img1 = im2double(image_gray);
block_size = 55;

    r = robotics.Rate(30);
    reset(r);

while (1)
    msg = receive(image_sub,2);
    waitfor(r);
    image = readImage(msg);
    image_gray = rgb2gray(image);
    img2 = im2double(image_gray);
    hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'BlockSize', [block_size block_size]);
    hbm.OutputValue = 'horizontal and Vertical components in complex form';
    halphablend = vision.AlphaBlender;
    motion = hbm(img1, img2);
    img12 = halphablend(img2,img1);
    [X, Y] = meshgrid(1:block_size:size(img1,2),1:block_size:size(img1,1));
    imshow(img12)
    %flow_lines = estimateFlow(opticFlow,image_gray);
    
    imshow(image)
    hold on 
    quiver(X(:),Y(:),real(motion(:)), imag(motion(:)),0)
    motion_x_agregated = sum(real(motion(:)))/10;
    motion_y_agregated = sum(imag(motion(:)))/10;
    plot([320 320+motion_x_agregated],[240 240+motion_y_agregated],'LineWidth',4)
    %ar = annotation('arrow');
    %ar.Color = 'blue';
    %ar.X = [240 240+motion_x_agregated];
    %ar.X = [320 320+motion_y_agregated];
    %plot(flow_lines, 'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off
    img1 = img2;
end