function xout= myLowPass2(xprev,xraw,alphaLP)
    
ind_missing= isnan(xraw);
% augment missing measurement
if numel(ind_missing)>0
    xraw(ind_missing)= xprev(ind_missing);
end
% discrete low-pass filter
xout= alphaLP*xraw + (1-alphaLP)*xprev;
