function traceIntegration = TraceIntegration(app, idx)

    nSweeps = numel(app.specData(idx).Data{1});

    switch app.play_TraceIntegration.Value
        case 'Inf'
            traceIntegration = nSweeps;
        otherwise
            traceIntegration = min(str2double(app.play_TraceIntegration.Value), nSweeps);
    end
end