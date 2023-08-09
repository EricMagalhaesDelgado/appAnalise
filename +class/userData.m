classdef userData < dynamicprops

    properties
        %-----------------------------------------------------------------%
        Emissions            = table('Size', [0, 5],                                                     ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'}, ...
                                     'VariableNames', {'idx', 'FreqCenter', 'BW', 'isTruncated', 'Parameters'})
        reportFlag           = false
        reportOCC            = struct('Related', [], 'idx', [], 'Method', '', 'Parameters', '')
        reportDetection      = struct('Band', [], 'ManualMode', 0, 'Algorithm', '', 'Parameters', '')
        reportClassification = struct('Algorithm', '', 'Parameters', '')
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))
    end
end