clear all; close all; clc;
% addpath('./results');

% uint8 ULTRASOUND=0
% uint8 INFRARED=1
% std_msgs/Header header
%   uint32 seq
%   time stamp
%   string frame_id
% uint8 radiation_type
% float32 field_of_view
% float32 min_range
% float32 max_range
% float32 range

global terarangeroneMsg;
terarangeroneMsg = rosmessage('sensor_msgs/Range');
terarangeroneMsg.FieldOfView = 0;
terarangeroneMsg.MinRange = 0;
terarangeroneMsg.MaxRange = 0;
terarangeroneMsg.Range_= 0;

plotTerarangeroneNode = robotics.ros.Node('/plotTerarangerone');
pTerarangeroneSub = robotics.ros.Subscriber(plotTerarangeroneNode,'/terarangerone','sensor_msgs/Range',{@terarangeroneCallback});

msg = receive(pTerarangeroneSub,20);

fname = sprintf('plotTerarangerone_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM'));
fid=fopen(fname,'a');

% Add loop to check if the command is received
  while(1)
% if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end   
    field_of_view = terarangeroneMsg.FieldOfView;
    min_range = terarangeroneMsg.MinRange;
    max_range = terarangeroneMsg.MaxRange;
    range = terarangeroneMsg.Range_;
    data = [field_of_view min_range max_range range];
    fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4));
    pause(0.1);
  end
fclose(fid);