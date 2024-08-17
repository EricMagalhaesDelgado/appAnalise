function ReportGenerator_PeaksUpdate(app, idx, Peaks)
    
    if isequal(idx, find(arrayfun(@(x) x.UserData.reportFlag, app.specData)))
        if ~isempty(Peaks); app.projectData.peaksTable      = Peaks;
        else;               app.projectData.peaksTable(:,:) = [];
        end
        
    else
        for ii = idx
            Tag = sprintf('%s\nID %d: %.3f - %.3f MHz', app.specData(ii).Receiver,                  ...
                                                        app.specData(ii).RelatedFiles.ID(1),        ...
                                                        app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                                        app.specData(ii).MetaData.FreqStop  / 1e+6);
            if ~isempty(Peaks)
                newTags = unique(Peaks.Tag);

                ind = find(strcmp(newTags, Tag));
                if ~isempty(ind)
                    oldInd = find(strcmp(app.projectData.peaksTable.Tag, newTags(ind)));
                    newInd = find(strcmp(Peaks.Tag,          newTags(ind)));
                    
                    app.projectData.peaksTable(oldInd, :)                  = [];
                    app.projectData.peaksTable(end+1:end+numel(newInd), :) = Peaks(newInd,:);
                    
                    app.projectData.peaksTable = sortrows(app.projectData.peaksTable, 'Tag');
                    
                else
                    oldInd = find(strcmp(app.projectData.peaksTable.Tag, Tag));
                    app.projectData.peaksTable(oldInd, :) = [];
                end

            else
                oldInd = find(strcmp(app.projectData.peaksTable.Tag, Tag));
                app.projectData.peaksTable(oldInd, :) = [];
            end
        end
    end
end