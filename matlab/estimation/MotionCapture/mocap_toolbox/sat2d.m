function [xsat,ysat] = sat2d(x,y,rmax)
% Saturate the magnitude of 2d vectors to rmax.
% The ratio is conserved; i.e.,
% xsat:ysat = x:y.
 
aMag= sqrt(x.^2+y.^2);
aSat= min(rmax, aMag);
aRatio= aSat./(aMag+eps);  % Keep the ratio between aX and aY
xsat= x.*aRatio;
ysat= y.*aRatio;