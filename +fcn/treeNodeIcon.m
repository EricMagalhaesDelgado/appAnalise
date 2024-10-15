function icon = treeNodeIcon(Type, iconReference)
    icon = '';
    switch Type
        %-----------------------------------------------------------------%
        case 'Receiver'
            if     contains(iconReference, 'RFeye', 'IgnoreCase', true)
                icon = 'logoCRFS_32.png';
            elseif contains(iconReference, {'FSL','FSVR','FSW','EB500','ETM'}, 'IgnoreCase', true)
                icon = 'logoR&S_32.png';
            elseif contains(iconReference, {'N9344C', 'N9936B'}, 'IgnoreCase', true)
                icon = 'logoKeySight_32.png';
            elseif contains(iconReference, 'MS2720T', 'IgnoreCase', true)
                icon = 'logoAnritsu_32.png';
            elseif contains(iconReference, 'SA2500', 'IgnoreCase', true)
                icon = 'logoTek_32.png';
            elseif contains(iconReference, 'CWSM2', 'IgnoreCase', true)
                icon = 'logoCellPlan_32.png';
            end

        %-----------------------------------------------------------------%
        case 'DataType'
            if     strcmpi(iconReference, 'SpectralData')
                icon = 'Playback_32.png';
            elseif strcmpi(iconReference, 'Occupancy')
                icon = 'Occupancy_32.png';
            end
    end
end