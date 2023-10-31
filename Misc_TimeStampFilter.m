function Data = Misc_TimeStampFilter(Data, TimeStampFilter, statsFlag)

    filterFlag = 0;
    for ii = 1:numel(Data)
        auxIndex1 = Data(ii).Data{1} < TimeStampFilter(1);
        if any(auxIndex1)
            filterFlag = 1;
            
            Data(ii).Data{1}(auxIndex1)   = [];
            Data(ii).Data{2}(:,auxIndex1) = [];
        end
        
        auxIndex2 = Data(ii).Data{1} > TimeStampFilter(2);
        if any(auxIndex2)
            filterFlag = 1;
            
            Data(ii).Data{1}(auxIndex2)   = [];
            Data(ii).Data{2}(:,auxIndex2) = [];
        end
        
        if filterFlag
            Data(ii).Samples = length(Data(ii).Data{1});
            if Data(ii).Samples <= 1
                error('Após aplicação do filtro de TimeStamp deve restar ao menos duas amostras.')
            end
            
            Data(ii).ObservationTime = sprintf('%s - %s', datestr(Data(1).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), ...
                                                          datestr(Data(1).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'));
            
            if statsFlag
                if ismember(Data(ii).MetaData.DataType, class.Constants.specDataTypes)
                    Data(ii).statsData = [min(Data(ii).Data{2}, [], 2), ...
                                          median(Data(ii).Data{2},  2), ...
                                          mean(Data(ii).Data{2},    2), ...
                                          max(Data(ii).Data{2}, [], 2)];
                    
                elseif ismember(Data(ii).MetaData.DataType, class.Constants.occDataTypes)
                    Data(ii).statsData = [min(Data(ii).Data{2}, [], 2), ...
                                          mean(Data(ii).Data{2},    2), ...
                                          max(Data(ii).Data{2}, [], 2)];
                    
                else
                    error('Tipo de dado %d não conhecido.', Data(ii).MetaData.DataType)
                end
            end
        end
        filterFlag = 0;        
    end

end