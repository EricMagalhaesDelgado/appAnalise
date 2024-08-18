classdef (Abstract) StackingOrder

    properties (Constant)
        %-----------------------------------------------------------------%
        winAppAnalise   = {'mkrLabels', 'occTHR', 'mkrROI', 'ROI', 'Average', 'ClearWrite', 'MaxHold', 'mkrLine', 'BandLimits', 'Persistance', 'MinHold', 'WaterfallTime', 'Waterfall'}
        winRFDataHub    = {}
        winDriveTest    = {'ROI', 'Car', 'Points', 'Distortion', 'Density', 'InRoute', 'OutRoute'}
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(hAxes, clientID)
            switch clientID
                case 'appAnalise:PLAYBACK'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;

                case 'appAnalise:REPORT'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;

                case 'appAnalise:RFDataHub'
                    refStackingOrder = plot.axes.StackingOrder.winRFDataHub;

                case 'appAnalise:DriveTest'
                    refStackingOrder = plot.axes.StackingOrder.winDriveTest;

                case 'appAnalise:SignalAnalysis'

                case 'appColeta:TASK'

                case 'webapp RFDataHub'

                case 'webapp SCH'

                otherwise
                    error('Unexpected option.')
            end
            
            stackingOrderTag = arrayfun(@(x) x.Tag, hAxes.Children, 'UniformOutput', false)';
            newOrderIndex    = [];
        
            for ii = 1:numel(refStackingOrder)
                idx = find(strcmp(stackingOrderTag, refStackingOrder{ii}));
                newOrderIndex = [newOrderIndex, idx];
            end
        
            hAxes.Children = hAxes.Children(newOrderIndex);
        end
    end
end