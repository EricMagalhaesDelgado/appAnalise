function htmlContent = htmlCode_ReleaseNotes(rootFolder)
    releaseNotes = readtable(fullfile(rootFolder, 'ReleaseNotes.txt'), 'Delimiter', '\t');
    releaseNotes = sortrows(releaseNotes, 'Version', 'descend');    
    [Release, ~, idxRelease] = unique(releaseNotes.Release, 'stable');

    htmlContent  = {'<div style="color: gray; font-family: Helvetica, Arial, sans-serif; font-size: 11px; text-align: justify; margin: 5px;">'};
    for ii = 1:numel(Release)
        idxReleaseTable = find(idxRelease==ii);
        [Version, ~, idxVersion] = unique(releaseNotes.Version(idxReleaseTable), 'stable');
        htmlContent{end+1} = sprintf('<p style="color: white; background-color: red; display: inline-block; vertical-align: middle; padding: 5px; border-radius: 5px; font-size: 10px; margin: 0px;">%s</p>', Release{ii});

        for jj = 1:numel(Version)
            idxVersionTable = find(idxVersion==jj);
            htmlContent{end+1} = sprintf('<span style="color: black; font-size: 10px;display: inline-block; vertical-align: sub;">v. %.2f (%s)</span>', Version(jj), releaseNotes.Date(idxReleaseTable(jj)));

            for kk = idxVersionTable'
                htmlContent{end+1} = sprintf('<p>•&thinsp;%s</p>', releaseNotes.Description{idxReleaseTable(kk)});
            end
        end
        htmlContent{end+1} = '';
    end
    htmlContent{end+1} = '</div>';

    htmlContent = strjoin(htmlContent, '\n');
end