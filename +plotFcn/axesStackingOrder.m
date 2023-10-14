function axesStackingOrder(app)

    refStackingOrder = {'occTHR', 'MaxHold', 'Average', 'MinHold', 'ClrWrite', 'Persistance'};
    
    StackingOrderTag = arrayfun(@(x) x.Tag, app.axes1.Children, 'UniformOutput', false)';
    newOrderIndex    = [];

    for ii = 1:numel(refStackingOrder)
        idx = find(strcmp(StackingOrderTag, refStackingOrder{ii}));
        newOrderIndex = [newOrderIndex, idx];
    end

    app.axes1.Children = app.axes1.Children(newOrderIndex);
end