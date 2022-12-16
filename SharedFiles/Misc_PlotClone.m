function Misc_PlotClone(oldFigure, RootFolder)

    newFigure = figure('Name', sprintf('appAnalise: Plot referência (%s)', datestr(now, 'dd/mm/yyyy HH:MM:SS')), 'NumberTitle', 'off', ...
                       'Color', [.98,.98,.98], 'GraphicsSmoothing', 'on', ...
                       'Position', oldFigure.Position, 'WindowState', oldFigure.WindowState, 'Visible', 0);
    delete(findall(newFigure, '-not', 'Type', 'Figure'));

    jFrame = get(newFigure, 'javaframe');
    jFrame.setFigureIcon(javax.swing.ImageIcon(fullfile(RootFolder, 'Icons', 'LR_icon.png')));
    jFrame.showTopSeparator(false);


    % COPY
    copyobj(oldFigure.Children, newFigure);
    

    % TOOLBAR
    h1 = findobj(newFigure.Children, 'Type', 'uitoolbar');    
    if ~isempty(h1)
        set(h1.Children, 'Visible', 0, 'Separator', 0)

        h2 = findobj(h1.Children, 'Tag', 'plotclone');
        if ~isempty(h2)
            set(h2, 'Visible', 1, 'Separator', 0)
        end
    end


    % DATATIP & ROI INTERACTION
    h3 = findobj(newFigure.Children, 'Type', 'axes');

    Unit = '';
    for ii = numel(h3):-1:1
        strUnit = regexp(h3(ii).YLabel.String, 'Nível \((?<value>.*)\)', 'names');
        if ~isempty(strUnit)
            Unit = strUnit.value;
        end

        if isempty(h3(ii).Children)
            delete(h3(ii))
            h3(ii) = [];
        end
    end
    linkaxes(h3, 'x')

    for ii = 1:numel(h3)
        set(h3(ii).Children, 'Tag', '')

        switch h3(ii).YLabel.String
            case 'Ocupação (%)'; UnitLevel = '%%';
            otherwise;           UnitLevel = Unit;
        end

        for jj = 1:numel(h3(ii).Children)
            switch lower(h3(ii).Children(jj).Type)
                case {'line', 'surface'}
                    try
                        Misc_DataTipSettings(h3(ii).Children(jj), UnitLevel)
                    catch
                    end

                case {'images.roi.line', 'images.roi.rectangle'}
                    h3(ii).Children(jj).InteractionsAllowed = 'none';

                case 'image'
                    hImg = h3(ii).Children(jj);

                    dt = datatip(hImg);
                    hImg.DataTipTemplate.DataTipRows(1).Label  = '';
                    hImg.DataTipTemplate.DataTipRows(2).Label  = '';
                    hImg.DataTipTemplate.DataTipRows(2).Format = '%.3f%%';
                    hImg.DataTipTemplate.DataTipRows(3) = [];
                    delete(dt)

                    set(hImg.DataTipTemplate, FontName='Calibri', FontSize=10)
            end
        end
    end

    newFigure.Visible = 1;

end