function Datatip(app, idx)

    for ii = 1:numel(app.specData(idx).UserData.customPlayback.Parameters.Datatip)
        h = findobj(Tag=app.specData(idx).UserData.customPlayback.Parameters.Datatip(ii).ParentTag);
        
        if ~isempty(h)
            datatip(h(1), 'DataIndex', app.specData(idx).UserData.customPlayback.Parameters.Datatip(ii).DataIndex);
        end
    end
end