function Layout(app)

    switch app.plotLayout
            case 1
                set(app.axes1,          Visible=1)
                set(app.axes1.Children, Visible=1)
                set(app.axes1.Toolbar,  Visible=1)
                app.axes1.Layout.Tile     = 1;
                app.axes1.Layout.TileSpan = [1 1];
                app.axes1.XTickLabel      = {};
                xlabel(app.axes1, '')

                set(app.axes2,          Visible=1)
                set(app.axes2.Children, Visible=1)
                set(app.axes2.Toolbar,  Visible=1)
                app.axes2.Layout.Tile     = 2;
                app.axes2.Layout.TileSpan = [2 1];

            case 2
                set(app.axes1,          Visible=1)
                set(app.axes1.Children, Visible=1)
                set(app.axes1.Toolbar,  Visible=1)
                app.axes1.Layout.Tile     = 1;
                app.axes1.Layout.TileSpan = [3 1];
                app.axes1.XTickLabelMode  = 'auto';
                xlabel(app.axes1, 'Frequência (MHz)')
                
                set(app.axes2,          Visible=0)
                set(app.axes2.Children, Visible=0)
                set(app.axes2.Toolbar,  Visible=0)
                app.axes2.Layout.Tile     = 4;
                app.axes2.Layout.TileSpan = [1 1];

            case 3
                set(app.axes1,          Visible=0)
                set(app.axes1.Children, Visible=0)
                set(app.axes1.Toolbar,  Visible=0)
                app.axes1.Layout.Tile     = 4;
                app.axes1.Layout.TileSpan = [1 1];
                app.axes1.XTickLabel      = {};
                xlabel(app.axes1, '')

                set(app.axes2,          Visible=1)
                set(app.axes2.Children, Visible=1)
                set(app.axes2.Toolbar,  Visible=1)
                app.axes2.Layout.Tile     = 1;
                app.axes2.Layout.TileSpan = [3 1];
    end    
end