function hAxes = Creation(hParent, axesType, varargin)

    arguments
        hParent
        axesType  char {mustBeMember(axesType,  {'Cartesian', 'Geographic'})} = 'Cartesian'
    end

    arguments (Repeating)
        varargin 
    end

    switch axesType
        case 'Cartesian'
            hAxes = uiaxes(hParent, Color=[.07,0,0], ColorScale='log', FontName='Helvetica', FontSize=10,                    ...
                                    XColor=[.8,.8,.8], YColor=[.8,.8,.8],                                                    ...
                                    XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on', TickDir='in',                  ...
                                    GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], ...
                                    Interactions=[], Toolbar=[]);
            if nargin == 3
                othersParameters = varargin{1};
                set(hAxes, othersParameters{:})
            end            

        case 'Geographic'
            hAxes = geoaxes(hParent, ColorScale='log', FontSize=6, Units='pixels', ...
                                     Basemap='none', Box='off',                    ...
                                     Interactions=[], Toolbar=[]);
            hAxes.LatitudeLabel.String  = '';
            hAxes.LongitudeLabel.String = '';

            if nargin == 3
                othersParameters = varargin{1};
                set(hAxes, othersParameters{:})
            end
    end

    hold(hAxes, 'on')
end