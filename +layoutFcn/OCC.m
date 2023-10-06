function OCC(app, LevelUnit)

    hComponents = findobj(app.play_OCCGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});

    if app.play_Occupancy.Value
        set(hComponents, Enable=1)

        switch app.play_OCC_Method.Value
            case 'Linear fixo'
                app.play_OCC_Offset.Enable             = 0;
                app.play_OCC_Factor.Enable             = 0;
                app.play_OCC_noiseFcn.Enable           = 0;
                app.play_OCC_noiseTrashSamples.Enable  = 0;
                app.play_OCC_noiseUsefulSamples.Enable = 0;
    
            case 'Linear adaptativo'
                app.play_OCC_THR.Enable                = 0;
                app.play_OCC_Factor.Enable             = 0;
                
            case 'Piso de ruído (Offset)'
                app.play_OCC_THR.Enable                = 0;
        end

        switch LevelUnit
            case 'dBm'
                if app.play_OCC_THR.Value > 0
                    app.play_OCC_THRLabel.Text = 'Valor (dBm):';
                    app.play_OCC_THR.Value     = -80;
                end

            case 'dBµV'
                if app.play_OCC_THR.Value < 0
                    app.play_OCC_THRLabel.Text = 'Valor (dBµV):';
                    app.play_OCC_THR.Value     = 27;
                end

            case 'dBµV/m'
                if app.play_OCC_THR.Value < 0
                    app.play_OCC_THRLabel.Text = 'Valor (dBµV/m):';
                    app.play_OCC_THR.Value     = 40;
                end
        end

    else
        set(hComponents, Enable=0)
    end
end