clear all;

close all;

clc;

[file,path] = uigetfile();

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
pitch_d = data(:,2);
pitch_abs = data(:,3);
pitch_err = data(:,4);
stick_pitch = data(:,5);
roll_d = data(:,6);
roll_abs = data(:,7);
roll_err = data(:,8);
stick_roll = data(:,9);


%  1        fprintf(,'%3.3f,',t);
%  2       fprintf(pFile,'%3.3f,',Pitch_d);
%  3       fprintf(pFile,'%3.3f,',absolutePitch);
%  4       fprintf(pFile,'%3.3f,',PitchError);
%  5       fprintf(pFile,'%3.3f,',Roll_d);
%  6       fprintf(pFile,'%3.3f,',absoluteRoll);
%  7      fprintf(pFile,'%3.3f\n',RollError);

figure(1);
subplot(2,1,1)
plot(t,pitch_d,'r-','linewidth',2);
hold on;
plot(t,pitch_abs,'b-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Pitch (deg)');
set(gca,'FontSize',16);
subplot(2,1,2)
plot(t,pitch_err,'k-','linewidth',2);
hold on
plot(t,stick_pitch,'g-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Pitch Error (deg)');
set(gca,'FontSize',16);

figure(2);
subplot(2,1,1)
plot(t,roll_d,'r-','linewidth',2);
hold on;
plot(t,roll_abs,'b-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Roll (deg)');
set(gca,'FontSize',16);
subplot(2,1,2)
plot(t,roll_err,'k-','linewidth',2);
hold on
plot(t,stick_roll,'g-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Roll Error (deg)');
set(gca,'FontSize',16);
