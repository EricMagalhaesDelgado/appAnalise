classdef (Abstract) StackingOrder

    properties (Constant)
        %-----------------------------------------------------------------%
        winAppAnalise   = {'mkrLabels', 'occTHR', 'mkrROI', 'Average', 'ClearWrite', 'MaxHold', 'MinHold', 'mkrLine', 'BandLimits', 'Persistance'}
        winRFDataHub    = {}
        winDriveTest    = {'ROI', 'Car', 'Points', 'Distortion', 'Density', 'InRoute', 'OutRoute'}
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(hAxes, clientID)
            switch clientID
                case 'winAppAnalise:PLAYBACK'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;

                case 'winAppAnalise:REPORT'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;

                case 'winRFDataHub'
                    refStackingOrder = plot.axes.StackingOrder.winRFDataHub;

                case 'winDriveTest'
                    refStackingOrder = plot.axes.StackingOrder.winDriveTest;

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