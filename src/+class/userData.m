classdef userData

    properties
        %-----------------------------------------------------------------%
        customPlayback        = struct('Type', 'auto', 'Parameters', [])

        occCache              = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod             = struct('RelatedIndex', [], 'SelectedIndex', [], 'CacheIndex', [])

        channelLibIndex       = []
        channelManual         = struct('Name', {}, 'Band', {}, 'FirstChannel', {}, 'LastChannel', {}, 'StepWidth', {}, 'ChannelBW', {}, 'FreqList', {}, 'Reference', {}, 'FindPeaksName', {})

        bandLimitsStatus      = false
        bandLimitsTable       = table('Size', [0, 2],                        ...
                                      'VariableTypes', {'double', 'double'}, ...
                                      'VariableNames', {'FreqStart', 'FreqStop'})

        Emissions             = table(uint32([]), [], [], true(0,1), {}, struct('Description', {}, 'ChannelAssigned', {}, 'DriveTest', {}), ...
                                      'VariableNames', {'Index', 'Frequency', 'BW', 'isTruncated', 'Detection', 'UserData'})

        measCalibration       = table('Size', [0, 4],                                    ...
                                      'VariableTypes', {'cell', 'cell', 'cell', 'cell'}, ...
                                      'VariableNames', {'Name', 'Type', 'oldUnitLevel', 'newUnitLevel'})

        reportFlag            = false
        reportOCC             = []
        reportDetection       = [] % struct('ManualMode', 0, 'Algorithm', {}, 'Parameters', {})
        reportClassification  = [] % struct('Algorithm', {}, 'Parameters', {})
        reportPeaksTable      = []
        reportExternalFiles   = table('Size', [0, 4],                                    ...
                                      'VariableTypes', {'cell', 'cell', 'cell', 'int8'}, ...
                                      'VariableNames', {'Type', 'Tag', 'Filename', 'ID'});
        reportChannelTable    = []
        reportChannelAnalysis = []

        AntennaHeight         = []
        LOG                   = {}
    end
end