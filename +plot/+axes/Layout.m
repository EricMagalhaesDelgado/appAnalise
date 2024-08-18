classdef (Abstract) Layout

    methods (Static = true)
        %-----------------------------------------------------------------%
        function XYLabel(hAxes, occVisibility, waterfallVisibility, Context)
            arguments
                hAxes               (1,3) matlab.ui.control.UIAxes
                occVisibility       (1,1) logical
                waterfallVisibility (1,1) logical
                Context             (1,:) char {mustBeMember(Context, {'appAnalise:PLAYBACK'})} = 'appAnalise:PLAYBACK'
            end

            UIAxes1 = hAxes(1);
            UIAxes2 = hAxes(2);
          % UIAxes3 = hAxes(3);

            if occVisibility && waterfallVisibility
                xlabel(UIAxes1, '')
                xlabel(UIAxes2, '')                
                UIAxes1.XTickLabel = {};
                UIAxes2.XTickLabel = {};

            elseif occVisibility
                xlabel(UIAxes1, '')
                xlabel(UIAxes2, 'Frequência (MHz)')
                UIAxes1.XTickLabel = {};
                UIAxes2.XTickLabelMode = 'auto';

            elseif waterfallVisibility
                xlabel(UIAxes1, '')
                UIAxes1.XTickLabel = {};
                
            else
                xlabel(UIAxes1, 'Frequência (MHz)')
                UIAxes1.XTickLabelMode = 'auto';
            end
        end
        
        %-----------------------------------------------------------------%
        function RatioAspect(hAxes, occVisibility, waterfallVisibility, ratioAspectComponent, Context)
            arguments
                hAxes                (1,3) matlab.ui.control.UIAxes
                occVisibility        (1,1) logical
                waterfallVisibility  (1,1) logical
                ratioAspectComponent (1,1) matlab.ui.control.DropDown
                Context              (1,:) char {mustBeMember(Context, {'appAnalise:PLAYBACK'})} = 'appAnalise:PLAYBACK'
            end

            if occVisibility && waterfallVisibility
                ratioAspectOptions = {'2:1:1', '1:2:1', '1:1:2'};
            elseif occVisibility
                ratioAspectOptions = {'3:1:0', '1:1:0', '1:3:0'};
            elseif waterfallVisibility        
                ratioAspectOptions = {'3:0:1', '1:0:1', '1:0:3'};                
            else
                ratioAspectOptions = {'1:0:0'};
            end

            ratioAspect = ratioAspectComponent.Value;
            if ~ismember(ratioAspect, ratioAspectOptions)
                ratioAspect = ratioAspectOptions{1};
            end            
            set(ratioAspectComponent, 'Items', ratioAspectOptions, 'Value', ratioAspect)
            
            plot.axes.Layout.Visibility(hAxes, ratioAspect, Context)
        end

        %-----------------------------------------------------------------%
        function Visibility(hAxes, ratioAspect, Context)
            arguments
                hAxes       (1,3) matlab.ui.control.UIAxes
                ratioAspect (1,:) char {mustBeMember(ratioAspect, {'1:0:0', '1:1:0', '1:0:1', '1:3:0', '1:0:3', '1:2:1', '1:1:2', '2:1:1', '3:1:0', '3:0:1'})}
                Context     (1,:) char {mustBeMember(Context, {'appAnalise:PLAYBACK'})} = 'appAnalise:PLAYBACK'
            end

            tiledSpan = str2double(strsplit(ratioAspect, ':'));
            tiledSpan = (4/sum(tiledSpan)) * tiledSpan;

            tiledPos = 1;
            ii = 0;
            for UIAxes = hAxes
                ii = ii+1;
                if tiledSpan(ii) == 0
                    UIAxes.Visible = 0;
                    set(UIAxes.Children, Visible=0)

                else
                    UIAxes.Visible = 1;
                    set(findobj(UIAxes.Children, '-not', {'Tag', 'ClearWrite', '-or', 'Tag', 'mkrLabels'}), Visible=1)

                    UIAxes.Layout.Tile = tiledPos;
                    UIAxes.Layout.TileSpan = [tiledSpan(ii) 1];
                end

                tiledPos = tiledPos+tiledSpan(ii);
            end
        end
    end
end