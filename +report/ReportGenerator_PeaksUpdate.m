function ReportGenerator_PeaksUpdate(app, CheckedRows, Peaks)
    
    if isequal(CheckedRows, find([app.specData.reportFlag]))
        if ~isempty(Peaks); app.peaksTable      = Peaks;
        else;               app.peaksTable(:,:) = [];
        end
        
    else
        for ii = CheckedRows
            Tag = sprintf('%s\nThreadID %d: %.3f - %.3f MHz', app.specData(ii).Node,                       ...
                                                              app.specData(ii).ThreadID,                   ...
                                                              app.specData(ii).MetaData.FreqStart ./ 1e+6, ...
                                                              app.specData(ii).MetaData.FreqStop  ./ 1e+6);
            if ~isempty(Peaks)
                newTags = unique(Peaks.Tag);

                ind = find(strcmp(newTags, Tag));
                if ~isempty(ind)
                    oldInd = find(strcmp(app.peaksTable.Tag, newTags(ind)));
                    newInd = find(strcmp(Peaks.Tag,          newTags(ind)));
                    
                    app.peaksTable(oldInd, :)                  = [];
                    app.peaksTable(end+1:end+numel(newInd), :) = Peaks(newInd,:);
                    
                    app.peaksTable = sortrows(app.peaksTable, 'Tag');
                else
                    oldInd = find(strcmp(app.peaksTable.Tag, Tag));
                    app.peaksTable(oldInd, :) = [];
                end
            else
                oldInd = find(strcmp(app.peaksTable.Tag, Tag));
                app.peaksTable(oldInd, :) = [];
            end
        end
    end            
end