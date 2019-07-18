function euler321= myLowPass(euler321raw,alphaLP)

persistent euler321prev

if isempty(euler321prev)
    euler321prev= [0,0,0];
end
    
ind_missing= isnan(euler321raw);
% augment missing measurement
if numel(ind_missing)>0
    euler321raw(ind_missing)= euler321prev(ind_missing);
end
% discrete low-pass filter
euler321= alphaLP*euler321raw + (1-alphaLP)*euler321prev;
euler321prev= euler321;
