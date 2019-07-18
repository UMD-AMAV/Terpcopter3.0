function [handle, hdata]= draw_quad

handle= {};
h_ind= 1;

%BODY--------------------------------------------------------------------%
% param
bW= .02;
bL= .04;
% handle
hbody_data= {[-1 1 1 -1 -1]*bL,[-1 -1 1 1 -1]*bW/2,[1 1 1 1 1]*0.001};
hbody= patch(hbody_data{1},hbody_data{2},hbody_data{3});hold on
set(hbody,'facecolor','k')
handle{h_ind}= hbody;  h_ind= h_ind+1;

%ROTOR-------------------------------------------------------------------%
% param
rotorR= .04;
rotorPos= .05;
% handle
rotorX= [1 1 -1 -1]*rotorPos;
rotorY= [-1 1 1 -1]*rotorPos;
hrotor_data= cell(4,3);
hrotor= cell(1,4);
cc= [1 1 0;
     1 1 0;
     .5 .5 .5;
     .5 .5 .5];
for ii= 1:4
    ang= linspace(0,2*pi,20); 
    ang= [ang,ang(1)];
    hrotor_data{ii,1}= rotorR*cos(ang)+rotorX(ii);
    hrotor_data{ii,2}= rotorR*sin(ang)+rotorY(ii);
    hrotor_data{ii,3}= zeros(size(ang));
    hrotor{ii}= patch(hrotor_data{ii,1},hrotor_data{ii,2},hrotor_data{ii,3});
    hrotor{ii}.FaceLighting= 'gouraud';
    set(hrotor{ii},'facecolor',cc(ii,:),'facealpha',.5,'edgecolor',[1 1 1]*.3)
    
    handle{h_ind}= hrotor{ii}; h_ind= h_ind+1;
end

%Stack-------------------------------------------------------------------%
hdata= [hbody_data;
        hrotor_data];
    