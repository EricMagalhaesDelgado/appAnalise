function fLogical = TableFiltering(hTable, filterTable)
        
    if any(filterTable.Enable)
        idx1 = find(strcmp(filterTable.Order, 'Node'))';

        fLogical   = ones(height(hTable), 1, 'logical');
        fTolerance = class.Constants.floatDiffTolerance;

        for ii = idx1
            tempLogical = zeros(height(hTable), 1, 'logical');
    
            idx2 = [ii, find(filterTable.RelatedID == ii)'];
            if any(filterTable.Enable(idx2))
                for jj = idx2
                    if (jj ~= ii) && ~filterTable.Enable(jj)
                        continue
                    end
    
                    switch filterTable.Type{jj}
                        case 'ROI'
                            tempLogical = or(tempLogical, inROI(filterTable.Value{jj}{1}, hTable.Latitude, hTable.Longitude));
                            
                        otherwise
                            Fcn = filterFcn(filterTable.Operation{jj}, filterTable.Value{jj}, fTolerance);
                            tempLogical = or(tempLogical, Fcn(hTable{:, filterTable.Column(jj)}));
                    end
                end
        
                fLogical = and(fLogical, tempLogical);
            end
        end

    else
        fLogical = zeros(height(hTable), 1, 'logical');
    end
end


%-------------------------------------------------------------------------%
function Fcn = filterFcn(filterOperation, filterValue, fTolerance)
    if isnumeric(filterValue)
        switch filterOperation
            case '=';  Fcn = @(x) abs(x - filterValue) < fTolerance;
            case '≠';  Fcn = @(x) abs(x - filterValue) > fTolerance;
            case '<';  Fcn = @(x) x <  filterValue;
            case '≤';  Fcn = @(x) x <= filterValue;
            case '>';  Fcn = @(x) x >  filterValue;
            case '≥';  Fcn = @(x) x >= filterValue;
            case '><'; Fcn = @(x) (x > filterValue(1)) & (x < filterValue(2));
            case '<>'; Fcn = @(x) (x < filterValue(1)) | (x > filterValue(2));
        end

    elseif ischar(filterValue)
        switch filterOperation
            case '=';  Fcn = @(x)  strcmpi(string(x),  filterValue);
            case '≠';  Fcn = @(x) ~strcmpi(string(x),  filterValue);
            case '⊃';  Fcn = @(x)  contains(string(x), filterValue, 'IgnoreCase', true);
            case '⊅';  Fcn = @(x) ~contains(string(x), filterValue, 'IgnoreCase', true);
        end

    else
        error('Unexpected filter value')
    end
end