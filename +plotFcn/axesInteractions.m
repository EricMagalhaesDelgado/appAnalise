function axesInteractions(Axes, Interactions)

    if ~isempty(Axes.Interactions)
        set(Axes.Toolbar.Children, Value = 1)
    end

    axtoolbar(Axes, Interactions);
    set(Axes.Toolbar.Children, Visible = 1)
end