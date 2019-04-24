function completionFlag = bhv_point_to_direction(completion, bhvTime)
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end