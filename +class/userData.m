classdef userData < dynamicprops

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])
        OCC                  = struct('Info', {}, 'THR', {}, 'Data', {})    % Buffer

        channelLibIndex      = []
        channelTable         = table('Size', [0, 5],                                                      ...
                                     'VariableTypes', {'uint16', 'uint16', 'double', 'double', 'string'}, ...
                                     'VariableNames', {'idx1', 'idx2', 'CF', 'BW', 'Description'})

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