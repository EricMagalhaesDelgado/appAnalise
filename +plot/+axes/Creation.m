function hAxes = Creation(hParent, axesType, colorMode, varargin)

    arguments
        hParent
        axesType  char {mustBeMember(axesType,  {'Cartesian', 'Geographic'})}
        colorMode char {mustBeMember(colorMode, {'dark-mode', 'light-mode'})} = 'dark-mode'
    end

    arguments (Repeating)
        varargin 
    end

    switch axesType
        case 'Cartesian'
            hAxes = uiaxes(hParent, Color=varargin{1}, ColorScale='log', FontName='Helvetica', FontSize=9,                   ...
                                    XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on', YScale='linear',               ...
                                    GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], ...
                                    TickDir='both', Interactions=[], Toolbar=[]);

            switch colorMode
                case 'dark-mode'
                    set(hAxes, 'XColor', 'white', 'YColor', 'white', 'ZColor', 'white')
                    hAxes.XLabel.Color = 'white';
                    hAxes.YLabel.Color = 'white';
                    hAxes.ZLabel.Color = 'white';

                case 'light-mode'
                    % Pendente
            end

        case 'Geographic'
            hAxes = geoaxes(hParent, FontSize=6, Units='pixels', Basemap='darkwater', Box='off');
            hAxes.LatitudeLabel.String  = '';
            hAxes.LongitudeLabel.String = '';

            try
                geobasemap(hAxes, varargin{1})
            catch
            end
    end

    hold(hAxes, 'on')
end