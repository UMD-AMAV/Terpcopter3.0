function [view_tt,time_new]= make_viewpoint(time,vpoint,vtime,Twindow)


dt= mean(diff(time));
twHalf= ceil(Twindow/dt/2);

tchange= [];
vchange= [];
for ii= 1:numel(vtime)-2;
    tind    = find(time>vtime(ii+1),1,'first');
    tchange = [tchange, tind-twHalf, tind+twHalf];
    vchange = [vchange, vpoint(ii,:)', vpoint(ii+1,:)'];
end
% augment start and end
tstart = find(time>vtime(1),1,'first');
tend   = find(time<vtime(end),1,'last');
tend   = min(tend,numel(time));
tchange = [tstart,tchange,tend];
vchange = [vpoint(1,:)',vchange,vpoint(end,:)'];
time_new = time(tstart:tend);

%% interpolate
for dim = 1:numel(vpoint(1,:))
    view_tt(:,dim) = pchip(tchange,vchange(dim,:),tchange(1):tchange(end))';
end
