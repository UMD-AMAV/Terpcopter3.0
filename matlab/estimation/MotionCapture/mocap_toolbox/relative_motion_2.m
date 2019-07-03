
function [Dr, dDr, Dv, Dpos, Dvel] = relative_motion_2(X,Y,Z,Xdot,Ydot,Zdot)
% Dr   : range
% dDr  : range rate
% Dv   : distance in velocity space
% Dpos : relative position
% Dvel : relative velocity

N= numel(X);
r = [X'; Y'; Z'];
v = [Xdot'; Ydot'; Zdot'];

%% Range, Range-rate, and Distance in velocity space
DR  = zeros(N,N);
dDR = zeros(N,N);
DV  = zeros(N,N);
for kk=1:N
    for jj=kk+1:N
        rkj = r(:,kk)-r(:,jj);
        vkj = v(:,kk)-v(:,jj);
        Rkj = sqrt(rkj(1)*rkj(1)+rkj(2)*rkj(2)+rkj(3)*rkj(3));
        DR(kk,jj) = Rkj; 
        %dDR(kk,jj)= dot(rkj,vkj)/Rkj;
        %dDR(kk,jj)= rkj'*vkj/Rkj;
        %dDR(kk,jj)= (rkj(1)*vkj(1)+rkj(2)*vkj(2)+rkj(3)*vkj(3))/Rkj;
        DV(kk,jj) = sqrt(vkj(1)*vkj(1)+vkj(2)*vkj(2)+vkj(3)*vkj(3));
    end 
end
DR  = DR+DR';
dDR = dDR+dDR';
DV  = DV+DV';

%% Relative position 
DX = ones(N,1)*X'-X*ones(1,N);
DY = ones(N,1)*Y'-Y*ones(1,N);
DZ = ones(N,1)*Z'-Z*ones(1,N);

%% Relative velocity
DXdot = ones(N,1)*Xdot'-Xdot*ones(1,N);
DYdot = ones(N,1)*Ydot'-Ydot*ones(1,N);
DZdot = ones(N,1)*Zdot'-Zdot*ones(1,N);


Dr= DR;
dDr= dDR;
Dv= DV;
Dpos= {DX,DY,DZ};
Dvel= {DXdot,DYdot,DZdot};
