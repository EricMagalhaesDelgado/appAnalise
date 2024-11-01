function Colorbar(hAxes, Location, plotConfig)
    arguments
        hAxes
        Location   char {mustBeMember(Location, {'off', 'west', 'east', 'eastoutside'})} = 'eastoutside'
        plotConfig cell = {}
    end

    switch Location
        case 'off'
            colorbar(hAxes,'off')
        otherwise
            cb = findobj(hAxes.Parent.Children, 'Type', 'colorbar');
            if ~isempty(cb)
                cb.Location = Location;
            else
                cb = colorbar(hAxes, 'Location', Location, 'Color', 'white', 'HitTest', 'off');
                if ~isempty(plotConfig)
                    set(cb, plotConfig{:})
                end
            end
    end
end