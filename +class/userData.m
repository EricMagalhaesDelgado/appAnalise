classdef userData < dynamicprops

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])
        OCC                  = struct('Info', {}, 'THR', {}, 'Data', {})    % Buffer

        channelLibIndex      = []
        channelManual        = table('Size', [0, 9],                                                                                      ...
                                     'VariableTypes', {'cell', 'cell', 'double', 'double', 'double', 'double', 'cell', 'cell', 'double'}, ...
                                     'VariableNames', {'Name', 'Band', 'FirstChannel', 'LastChannel', 'StepWidth', 'ChannelBW', 'FreqList', 'Reference', 'FindPeaksIndex'})

        Emissions            = table('Size', [0, 5],                                                      ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'},  ...
                                     'VariableNames', {'idx', 'FreqCenter', 'BW', 'isTruncated', 'Parameters'})

        reportFlag           = false
        reportOCC            = struct('Related', [], 'idx', [], 'Method', '', 'Parameters', '')
        reportDetection      = struct('Band', [], 'ManualMode', 0, 'Algorithm', '', 'Parameters', '')
        reportClassification = struct('Algorithm', '', 'Parameters', '')
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))
    end
end