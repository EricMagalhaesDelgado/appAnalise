function Table = reportTable_type2(reportTable, configTable)

    columnName  = configTable.Settings(1).ColumnName;
    columnClass = class(reportTable.(columnName));
    columnValues = reportTable.(columnName);

    if ismember(columnClass, {'string', 'categorical'})
        columnValues = cellstr(reportTable.(columnName));
    end

    Table = table('Size', [0, 6], ...
                  'VariableTypes', {'cell', 'cell', 'cell', 'double', 'double', 'double'}, ...
                  'VariableNames', {configTable.Settings.ColumnName});   

    [uniqueValues, ~, uniqueValuesIndex] = unique(columnValues, 'stable');
    for ii = 1:numel(uniqueValues)
        idx = find((ii == uniqueValuesIndex));

        pricePerProductStr = {};
        for jj = idx'
            pricePerProductStr{end+1} = sprintf('R$ %.2f (#%d)', reportTable.("Valor Unit. (R$)")(jj), jj);
        end
        pricePerProductStr  = strjoin(pricePerProductStr, '<br>');

        unitPricePerProduct = reportTable.("Valor Unit. (R$)")(idx);
        quantityPerProduct  = double(reportTable.("Qtd. lacradas")(idx)) + double(reportTable.("Qtd. apreendidas")(idx)) + double(reportTable.("Qtd. retidas (RFB)")(idx));
        totalPrice          = sum(unitPricePerProduct .* quantityPerProduct);

        Table(ii,:) = {uniqueValues{ii},                                                              ...
                       pricePerProductStr,                                                            ...
                       char(strjoin(string(quantityPerProduct) + " (#" + string(idx) + ")", '<br>')), ...
                       totalPrice/sum(quantityPerProduct),                                            ...
                       sum(quantityPerProduct),                                                       ...
                       totalPrice};
    end
end