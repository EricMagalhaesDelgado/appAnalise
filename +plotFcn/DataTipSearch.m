function [ParentTag, DataIndex, XData, YData] = DataTipSearch(app, FindType)

    switch FindType
        case 'all'; hDataTip  = findobj('Type', 'datatip');
        otherwise;  hDataTip  = findobj(eval(FindType), 'Type', 'datatip');
    end

    ParentTag = arrayfun(@(x) x.Parent.Tag, hDataTip, "UniformOutput", false);
    DataIndex = arrayfun(@(x) x.DataIndex,  hDataTip, "UniformOutput", false);
    XData     = arrayfun(@(x) x.X,          hDataTip, "UniformOutput", false);
    YData     = arrayfun(@(x) x.Y,          hDataTip, "UniformOutput", false);
end