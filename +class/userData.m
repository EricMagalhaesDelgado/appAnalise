classdef userData

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])

        occCache             = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod            = struct('RelatedIndex', [], 'SelectedIndex', [], 'CacheIndex', [])

        channelLibIndex      = []
        channelManual        = table('Size', [0, 9],                                                                                      ...
                                     'VariableTypes', {'cell', 'cell', 'double', 'double', 'double', 'double', 'cell', 'cell', 'cell'}, ...
                                     'VariableNames', {'Name', 'Band', 'FirstChannel', 'LastChannel', 'StepWidth', 'ChannelBW', 'FreqList', 'Reference', 'FindPeaksName'})

        bandLimitsStatus     = false
        bandLimitsTable      = table('Size', [0, 2],                        ...
                                     'VariableTypes', {'double', 'double'}, ...
                                     'VariableNames', {'FreqStart', 'FreqStop'})

        Emissions            = table('Size', [0, 5],                                                     ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'}, ...
                                     'VariableNames', {'Index', 'Frequency', 'BW', 'isTruncated', 'Detection'})

        reportFlag           = false
        
        reportOCC            = []
        reportDetection      = [] % struct('ManualMode', 0, 'Algorithm', {}, 'Parameters', {})
        reportClassification = [] % struct('Algorithm', {}, 'Parameters', {})

        reportPeaksTable     = []
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))
    end
end