classdef (Abstract) Layout

    methods (Static = true)
        %-----------------------------------------------------------------%
        function ratioAspectOptions = Label(hAxes, occVisibility, waterfallVisibility, Context)
            arguments
                hAxes               (1,3) matlab.ui.control.UIAxes
                occVisibility       (1,1) logical
                waterfallVisibility (1,1) logical
                Context             (1,:) char {mustBeMember(Context, {'appAnalise:PLAYBACK'})}
            end

            UIAxes1 = hAxes(1);
            UIAxes2 = hAxes(2);
          % UIAxes3 = hAxes(3);

            if occVisibility && waterfallVisibility
                xlabel(UIAxes1, '')
                xlabel(UIAxes2, '')                
                UIAxes1.XTickLabel = {};
                UIAxes2.XTickLabel = {};
                ratioAspectOptions = {'2:1:1', '1:2:1', '1:1:2'};

            elseif occVisibility
                xlabel(UIAxes1, '')
                xlabel(UIAxes2, 'Frequência (MHz)')
                UIAxes1.XTickLabel = {};
                UIAxes2.XTickLabelMode = 'auto';
                ratioAspectOptions = {'3:1:0', '1:1:0', '1:3:0'};

            elseif waterfallVisibility
                xlabel(UIAxes1, '')
                UIAxes1.XTickLabel = {};                
                ratioAspectOptions = {'3:0:1', '1:0:1', '1:0:3'};
                
            else
                xlabel(UIAxes1, 'Frequência (MHz)')
                UIAxes1.XTickLabelMode = 'auto';
                ratioAspectOptions = {'1:0:0'};
            end

            plot.axes.Layout.Visibility(hAxes, ratioAspectOptions{1}, Context)
        end

        %-----------------------------------------------------------------%
        function Visibility(hAxes, ratioAspect, Context)
            arguments
                hAxes       (1,3) matlab.ui.control.UIAxes
                ratioAspect (1,:) char {mustBeMember(ratioAspect, {'1:0:0', '1:1:0', '1:0:1', '1:3:0', '1:0:3', '1:2:1', '1:1:2', '2:1:1', '3:1:0', '3:0:1'})}
                Context     (1,:) char {mustBeMember(Context, {'appAnalise:PLAYBACK'})}
            end

            UIAxes1 = hAxes(1);
            UIAxes2 = hAxes(2);
            UIAxes3 = hAxes(3);

            tiledSpan = str2double(strsplit(ratioAspect, ':'));
            tiledSpan = (4/sum(tiledSpan)) * tiledSpan;

            tiledPos = 1;
            for ii = 1:3
                if tiledSpan(ii) == 0
                    eval(sprintf('set(UIAxes%d,          Visible=0)', ii))
                    eval(sprintf('set(UIAxes%d.Children, Visible=0)', ii))
                    eval(sprintf('set(UIAxes%d.Toolbar,  Visible=0)', ii))

                else
                    eval(sprintf('set(UIAxes%d,          Visible=1)', ii))
                    eval(sprintf('set(findobj(UIAxes%d.Children, "-not", {"Tag", "ClearWrite", "-or", "Tag", "mkrLabels"}), Visible=1)', ii))
                    eval(sprintf('set(UIAxes%d.Toolbar,  Visible=1)', ii))

                    eval(sprintf('UIAxes%d.Layout.Tile = tiledPos;', ii))
                    eval(sprintf('UIAxes%d.Layout.TileSpan = [tiledSpan(ii) 1];', ii))
                end

                tiledPos = tiledPos+tiledSpan(ii);
            end
        end
    end
end