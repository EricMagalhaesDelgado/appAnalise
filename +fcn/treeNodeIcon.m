function icon = treeNodeIcon(Type, Value)

    switch Type
        %-----------------------------------------------------------------%
        case 'Receiver'
            if     contains(Value, 'RFeye', 'IgnoreCase', true);        icon = 'Instr_CRFS.png';
            elseif contains(Value, {'FSL','FSVR','FSW','EB500','ETM'}); icon = 'Instr_R&S.png';
            elseif contains(Value, {'N9344C', 'N9936B'});               icon = 'Instr_KeySight.png';
            elseif contains(Value, 'MS2720T');                          icon = 'Instr_Anritsu.png';
            elseif contains(Value, 'SA2500');                           icon = 'Instr_Tektronix.png';
            elseif contains(Value, 'CWSM2');                            icon = 'Instr_CellPlan.png';
            end

        %-----------------------------------------------------------------%
        case 'DataType'
            switch Value
                case 'SpectralData';                                    icon = 'LT_playback.png';
                case 'Occupancy';                                       icon = 'LT_OCC.png';
            end
    end

    if ~exist('icon', 'var')
        icon = '';
    end
end