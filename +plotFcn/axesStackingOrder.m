classdef (Abstract) axesStackingOrder

    properties (Constant)
        %-----------------------------------------------------------------%
        winAppAnalise   = {'mkrLabels', 'occTHR', 'mkrROI', 'Average', 'ClearWrite', 'MaxHold', 'MinHold', 'mkrLine', 'BandLimits', 'Persistance'}
        winRFDataHub    = {}
        winDriveTest    = {'ROI', 'Car', 'Points', 'Distortion', 'Density', 'InRoute', 'OutRoute'}
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(src, Axes)
            switch src
                case 'winAppAnalise'
                    refStackingOrder = plotFcn.axesStackingOrder.winAppAnalise;

                case 'winRFDataHub'
                    refStackingOrder = plotFcn.axesStackingOrder.winRFDataHub;

                case 'winDriveTest'
                    refStackingOrder = plotFcn.axesStackingOrder.winDriveTest;

                otherwise
                    error('Unexpected option.')
            end
            
            stackingOrderTag = arrayfun(@(x) x.Tag, Axes.Children, 'UniformOutput', false)';
            newOrderIndex    = [];
        
            for ii = 1:numel(refStackingOrder)
                idx = find(strcmp(stackingOrderTag, refStackingOrder{ii}));
                newOrderIndex = [newOrderIndex, idx];
            end
        
            Axes.Children = Axes.Children(newOrderIndex);
        end
    end
end