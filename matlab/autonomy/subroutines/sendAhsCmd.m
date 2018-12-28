function sendAhsCmd(src,stateEstimateMsg,autonomyParams,ahsCmdPublisher)

% unpack statestimate
t = stateEstimateMsg.Time;
z = stateEstimateMsg.Up;
fprintf('Received Msg, Quad Alttiude is : %3.3f m\n', z );


% a crude sequence of three behaviors 
tol = 0.1;
if ( z <= 2-tol && t <= 10 || t <= 10 ) 
   z_d = 1; 
   disp('BHV_Takeoff')
elseif ( t <= 20 ) 
   z_d = 1.5; 
   disp('BHV_ConstantAltitude')   
else
   z_d = 0.2;
   disp('BHV_Land')
end


% publish
ahsCmdMsg = rosmessage('terpcopter_msgs/ahsCmd');
ahsCmdMsg.AltitudeMeters = z_d;
%send(ahsCmdPublisher, ahsCmdMsg);
fprintf('Published Ahs Cmd. Alt : %3.3f \n', z_d );


end