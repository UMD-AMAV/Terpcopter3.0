function [  ] = wscrot( h, R, xc, yc, zc )
%wscrot rotates the object h given about its center, then returns the 
%object to its original location

    x = get(h,'xdata')-xc;
    y = get(h,'ydata')-yc;
    z = get(h,'zdata')-zc;
    [M,N] = size(x);
    xyz = [x(:)'; y(:)'; z(:)'];
    xyz = R*xyz;
    x = reshape(xyz(1,:),M,N)+xc;
    y = reshape(xyz(2,:),M,N)+yc;
    z = reshape(xyz(3,:),M,N)+zc;
    set(h,'xdata',x,'ydata',y,'zdata',z);

end

