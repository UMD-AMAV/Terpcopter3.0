function sendAhsCmd(src,stateEstimateMsg,mission,autonomyParams,ahsCmdPublisher)

% unpack statestimate
t = stateEstimateMsg.Time;
z = stateEstimateMsg.Up;
fprintf('Received Msg, Quad Alttiude is : %3.3f m\n', z );

currentBehavior = 1; 
    
if mission.config.firstLoop == 1
    disp('Behavior Manager Started')
    % initialize time variables 
    mission.variables.initial_event_time = datetime;  
    mission.variables.behavior_switched_timestamp = datetime;
    mission.variables.behavior_satisfied_timestamp = datetime;
    mission.config.firstLoop = false; % ends the first loop
end

name = mission.bhv{currentBehavior}.name;
flag = mission.bhv{currentBehavior}.completion.status;
ahs = mission.bhv{currentBehavior}.ahs;
completion = mission.bhv{currentBehavior}.completion;

if flag == true
        disp('completion is true. move to next behavior');
        mission.bhv = pop(mission.bhv);
    else
        disp('checking to see what the current behavior is') 
        
        %Set Handles within each behavior
        
        %switch to 
        %Eval command eval([mission.bhv(CurrentBehavior).name,status)
        switch name
            case 'bhv_takeoff'
                 disp('takeoff behavior');
                 
% % % a crude sequence of three behaviors 
% % tol = 0.1;
% % if ( z <= 2-tol && t <= 10 || t <= 10 ) 
% %    z_d = 1; 
% %    disp('BHV_Takeoff')
% % elseif ( t <= 20 ) 
% %    z_d = 1.5; 
% %    disp('BHV_ConstantAltitude')   
% % else
% %    z_d = 0.2;
% %    disp('BHV_Land')
% % end


% publish
ahsCmdMsg = rosmessage('terpcopter_msgs/ahsCmd');
ahsCmdMsg.AltitudeMeters = z_d;
%send(ahsCmdPublisher, ahsCmdMsg);
fprintf('Published Ahs Cmd. Alt : %3.3f \n', z_d );


end