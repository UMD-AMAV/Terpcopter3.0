function missionUpdate = pop(mission, t)
global timestamps
timestamps.behavior_switched_timestamp = t;
[numRow numCol] = size(mission);

if numCol == 1
    missionUpdate{1} = {};
else
    missionUpdate{1} = {};
    for i = 1 : numCol - 1
        missionUpdate{i} = mission{i + 1};
        missionUpdate{i + 1} = {};
    end
end

