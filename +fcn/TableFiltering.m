function fLogical = TableFiltering(hTable, filterTable)

    % Essa função foi a base da filtragem implantada no webapp SCH, que
    % acabou sendo modularizada na classe de "SupportPackages" chamada
    % "tableFiltering".

    % Aqui tem a peculiaridade do ROI, mas que pode constar como possível
    % filtro que não tem serventia no webapp SCH, mas teria no appAnalise.

    % Eis um trabalho a fazer no futuro! :(
        
    if any(filterTable.Enable)
        % Identifica "filtros nós".
        idx1 = find(strcmp(filterTable.Order, 'Node'))';

        % Descarta filtros nós cujos membros foram desativados na GUI.
        for ii = idx1
            idx2 = [ii, find(filterTable.RelatedID == ii)'];
            if all(~filterTable.Enable(idx2))
                idx1(idx1 == ii) = [];
            end
        end

        % Cria vetor lógico.
        fLogical   = ones(height(hTable), 1, 'logical');
        fTolerance = class.Constants.floatDiffTolerance;

        for ii = idx1
            tempLogical = zeros(height(hTable), 1, 'logical');
    
            idx2 = [ii, find(filterTable.RelatedID == ii)'];
            for jj = idx2
                if ~filterTable.Enable(jj)
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
        filterValue = strtrim(filterValue);
        
        switch filterOperation
            case '=';  Fcn = @(x)  strcmpi(string(x),  filterValue);
            case '≠';  Fcn = @(x) ~strcmpi(string(x),  filterValue);
            case '⊃';  Fcn = @(x)  contains(string(x), filterValue, 'IgnoreCase', true);
            case '⊅';  Fcn = @(x) ~contains(string(x), filterValue, 'IgnoreCase', true);
        end

    else
        error('fcn:TableFiltering:UnexpectedFilterValue', 'Unexpected filter value')
    end
end