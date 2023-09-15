function peakExcursion(app, ii, jj, newArray)

    switch app.specObj(ii).Status
        case 'Em andamento'
            [~, peakIdx] = max(newArray);
            
        otherwise
            idx = find(all(app.specObj(ii).Band(jj).Waterfall.Matrix == -1000, 2), 1);
            if isempty(idx)
                idx = app.specObj(ii).Band(jj).Waterfall.Depth+1;
            end

            [~, peakIdx] = max(mean(app.specObj(ii).Band(jj).Waterfall.Matrix(1:idx-1,:), 1));
    end

    if isempty(app.peakExcursion) || ~isvalid(app.peakExcursion)
        app.peakExcursion = datatip(app.line_ClrWrite, DataIndex=peakIdx);
    else
        app.peakExcursion.DataIndex = peakIdx;
    end
end