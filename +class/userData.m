classdef userData < dynamicprops

    properties
        %-----------------------------------------------------------------%
        Emissions            = table('Size', [0, 5],                                                      ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'},  ...
                                     'VariableNames', {'idx', 'FreqCenter', 'BW', 'isTruncated', 'Parameters'})

        Channels             = table('Size', [0, 6],                                                                ...
                                     'VariableTypes', {'uint16', 'uint16', 'double', 'double', 'string', 'double'}, ...
                                     'VariableNames', {'idx1', 'idx2', 'FreqCenter', 'BW', 'Description', 'OCC'})
        
        OCC                  = struct('Info', {}, 'THR', {}, 'Data', {})    % Buffer

        reportFlag           = false
        reportOCC            = struct('Related', [], 'idx', [], 'Method', '', 'Parameters', '')
        reportDetection      = struct('Band', [], 'ManualMode', 0, 'Algorithm', '', 'Parameters', '')
        reportClassification = struct('Algorithm', '', 'Parameters', '')
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))

        playbackSettings     = struct('Type', 'auto', 'Parameters', [])
    end
end