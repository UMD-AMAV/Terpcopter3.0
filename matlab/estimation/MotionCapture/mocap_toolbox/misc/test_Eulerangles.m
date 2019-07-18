% test Euler 321 and 123 conversion

[h1,hdata1]= draw_quad;hold on
[h2,hdata2]= draw_quad;
grid on, box on
xlabel('x'),ylabel('y')
daspect([1 1 1])
view([-1 -1 1])

%---- euler 123 -------
phi1   = 30/180*pi;
theta1 = 0/180*pi;
psi1   = 80/180*pi;
angles1= [phi1,theta1,psi1];
% rotational matrix
R1= Euler2Rmat(angles1,123);
for hind= 1:numel(h1)
    move_body(h1{hind},hdata1(hind,:),[0 0 0],R1)
end

pause

%---- euler 321 -------
angles2 = Rmat2Euler(R1,321);
disp(angles2/pi*180)
% rotational matrix
R2= Euler2Rmat(angles2,321);
for hind= 1:numel(h2)
    move_body(h2{hind},hdata2(hind,:),[0 0 0],R2)
end


