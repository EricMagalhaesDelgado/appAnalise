function hROI = ROI(Type, hAxes, customProp)
    arguments
        Type       char {mustBeMember(Type, {'Line', 'Threshold', 'Circle', 'Rectangle', 'Polygon'})}
        hAxes
        customProp cell = {}
    end

    defaultProp = DefaultProp(Type);

    switch Type
        case {'Line', 'Threshold'}
            hROI = images.roi.Line(hAxes,      defaultProp{:});
        case 'Circle'
            hROI = images.roi.Circle(hAxes,    defaultProp{:});
        case 'Rectangle'
            hROI = images.roi.Rectangle(hAxes, defaultProp{:});
        case 'Polygon'
            hROI = images.roi.Rectangle(hAxes, defaultProp{:});
    end

    if ~isempty(customProp)
        set(hROI, customProp{:})
    end
end

%-------------------------------------------------------------------------%
function defaultProp = DefaultProp(Type)
    switch Type
        case {'Line', 'Threshold'}
            defaultProp = {'Color', 'red',  ...
                           'MarkerSize', 4, ...
                           'LineWidth', 1,  ...
                           'Deletable', 0,  ...
                           'InteractionsAllowed', 'translate'};

        case {'Circle', 'Rectangle', 'Polygon'}
            defaultProp = {'LineWidth', 1,  ...
                           'Deletable', 0,  ...
                           'FaceSelectable', 0};
    end

    if Type == "Rectangle"
        defaultProp = [defaultProp, {'Rotatable', true}];
    end
end