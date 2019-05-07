close all
clear all



I = rgb2gray(imread('image2.png'));
tic
points = detectORBFeatures(I);%,"NumOctaves",2,"MetricThreshold",1000,"NumScaleLevels",4,"ROI",[size(I,2)/4 (size(I,1)*1.1)/4 (size(I,2)*2)/4 (size(I,1)*2.5)/4]);
[features, valid_points] = extractFeatures(I, points.selectStrongest(50),"Method","ORB","BlockSize",5,"Upright",true,"FeatureSize",128);
%strong_point = valid_points.selectStrongest(50);
%strong_feature = extractFeatures(I,strong_point);
%hold on
I2 = rgb2gray(imread('image2.png'));
I2 = I2(150:end,220:end,:);
points2 = detectORBFeatures(I2);%,"NumOctaves",2,"MetricThreshold",1000,"NumScaleLevels",4);
[features2, valid_points2] = extractFeatures(I2, points2.selectStrongest(50),"Method","ORB","BlockSize",5,"Upright",true,"FeatureSize",128);
%strong_point2 = valid_points2.selectStrongest(5);
%strong_feature2 = extractFeatures(I,strong_point2);
[indexPairs,matchmetric] = matchFeatures(features,features2, "Method", 'Exhaustive',"MatchThreshold",80,"MaxRatio",0.9,"Unique",true,"Metric","SSD");
matchedPoints1 = valid_points(indexPairs(:,1));
matchedPoints2 = valid_points2(indexPairs(:,2));

%Display the matching points. The data still includes several outliers, but you can see the effects of rotation and scaling on the display of matched features.

%legend('matched points 1','% matched points 2');

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedPoints2, matchedPoints1, 'affine');%,"Confidence",99,"MaxDistance",200);
Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc)
thetaRecovered = atan2(ss,sc)*180/pi
toc

figure; imshow(I); hold on;
plot(valid_points,'showOrientation',true);
figure; imshow(I2); hold on; plot(valid_points2,'showOrientation',true);
figure; showMatchedFeatures(I,I2,matchedPoints1,matchedPoints2);


outputView = imref2d(size(I));
recovered  = imwarp(I2,tform,'OutputView',outputView);
figure, imshowpair(I,recovered,'montage')
