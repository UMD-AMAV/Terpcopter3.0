function [pos, vid_miss] = augment_data(pos,pos_prev)

% find index with data missing
mat = (pos == 0);
vid_miss = sum(mat,1) > 0;
vid_miss = vid_miss(:);

% augment with previous data
indmiss= find(pos==0);
pos(indmiss)= pos_prev(indmiss);
pos = pos(:);
