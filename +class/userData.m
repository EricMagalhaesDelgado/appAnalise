classdef userData < dynamicprops

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])

        occCache             = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod            = struct('RelatedThreadIndex', [], 'SelectedThreadIndex', [], 'CacheIndex', [])

        channelLibIndex      = []
        channelManual        = table('Size', [0, 9],                                                                                      ...
                                     'VariableTypes', {'cell', 'cell', 'double', 'double', 'double', 'double', 'cell', 'cell', 'double'}, ...
                                     'VariableNames', {'Name', 'Band', 'FirstChannel', 'LastChannel', 'StepWidth', 'ChannelBW', 'FreqList', 'Reference', 'FindPeaksIndex'})

        bandLimitsStatus     = false
        bandLimitsTable      = table('Size', [0, 2],                        ...
                                     'VariableTypes', {'double', 'double'}, ...
                                     'VariableNames', {'FreqStart', 'FreqStop'})


        Emissions            = table('Size', [0, 5],                                                      ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'},  ...
                                     'VariableNames', {'idx', 'FreqCenter', 'BW', 'isTruncated', 'Parameters'})

        reportFlag           = false        
        reportDetection      = struct('Band', [], 'ManualMode', 0, 'Algorithm', '', 'Parameters', '')
        reportClassification = struct('Algorithm', '', 'Parameters', '')
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))
    end
end