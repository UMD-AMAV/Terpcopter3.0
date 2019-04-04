function [] = plotkalmanTxt
fileID = 'kalmanlog.txt';

% [dt K predictX predictY velX velY]
A = load(fileID, '-ascii');

flag=0;

end