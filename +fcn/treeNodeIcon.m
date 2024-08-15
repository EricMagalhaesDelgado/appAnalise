function icon = treeNodeIcon(Type, Value)

    Value = lower(Value);

    switch Type
        %-----------------------------------------------------------------%
        case 'Receiver'
            if     contains(Value, 'rfeye');                            icon = 'logoCRFS_32.png';
            elseif contains(Value, {'fsl','fsvr','fsw','eb500','etm'}); icon = 'logoR&S_32.png';
            elseif contains(Value, {'n9344C', 'n9936B'});               icon = 'logoKeySight_32.png';
            elseif contains(Value, 'ms2720T');                          icon = 'logoAnritsu_32.png';
            elseif contains(Value, 'sa2500');                           icon = 'logoTektronix_32.png';
            elseif contains(Value, 'cwsm2');                            icon = 'logoCellPlan_32.png';
            end

        %-----------------------------------------------------------------%
        case 'DataType'
            switch Value
                case 'spectraldata';                                    icon = 'Playback_32.png';
                case 'occupancy';                                       icon = 'Occupancy_32.png';
            end
    end

    if ~exist('icon', 'var')
        icon = '';
    end
end