function icon = layoutTreeNodeIcon(receiverName)

    if     contains(receiverName, 'RFeye', 'IgnoreCase', true)
        icon = 'logoCRFS_32.png';
    elseif contains(receiverName, {'FSL','FSVR','FSW','EB500','ETM'}, 'IgnoreCase', true)
        icon = 'logoR&S_32.png';
    elseif contains(receiverName, {'N9344C', 'N9936B'}, 'IgnoreCase', true)
        icon = 'logoKeySight_32.png';
    elseif contains(receiverName, 'MS2720T', 'IgnoreCase', true)
        icon = 'logoAnritsu_32.png';
    elseif contains(receiverName, 'SA2500', 'IgnoreCase', true)
        icon = 'logoTek_32.png';
    elseif contains(receiverName, 'CWSM2', 'IgnoreCase', true)
        icon = 'logoCellPlan_32.png';
    else
        icon = '';
    end
end