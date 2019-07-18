function move_body(h,hdata,Rcg,Rmat)
% h     : handle to plotted object
% hdata : cell that contains xyz data of points in the body frame
% Rcg   : translation
% Rmat  : rotational matrix I^R^B (converts coordinates in body frame to
%                                  those in Inertial frame).

% get XYZ date in body frame
xb = hdata{1};
yb = hdata{2};
zb = hdata{3};

% Rotate about body c.g.
xyz = [xb(:)'; yb(:)'; zb(:)'];
xyz = Rmat*xyz;

% Translate
[M,N] = size(xb);
xI = reshape(xyz(1,:),M,N)+Rcg(1);
yI = reshape(xyz(2,:),M,N)+Rcg(2);
zI = reshape(xyz(3,:),M,N)+Rcg(3);

% update plot
set(h,'xdata',xI,'ydata',yI,'zdata',zI);

