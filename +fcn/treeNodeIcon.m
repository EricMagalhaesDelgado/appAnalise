function icon = treeNodeIcon(Type, Value)

    Value = lower(Value);

    switch Type
        %-----------------------------------------------------------------%
        case 'Receiver'
            if     contains(Value, 'rfeye');                            icon = 'Instr_CRFS.png';
            elseif contains(Value, {'fsl','fsvr','fsw','eb500','etm'}); icon = 'Instr_R&S.png';
            elseif contains(Value, {'n9344C', 'n9936B'});               icon = 'Instr_KeySight.png';
            elseif contains(Value, 'ms2720T');                          icon = 'Instr_Anritsu.png';
            elseif contains(Value, 'sa2500');                           icon = 'Instr_Tektronix.png';
            elseif contains(Value, 'cwsm2');                            icon = 'Instr_CellPlan.png';
            end

        %-----------------------------------------------------------------%
        case 'DataType'
            switch Value
                case 'spectraldata';                                    icon = 'LT_playback.png';
                case 'occupancy';                                       icon = 'LT_OCC.png';
            end
    end

    if ~exist('icon', 'var')
        icon = '';
    end
end