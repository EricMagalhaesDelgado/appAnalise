classdef (Abstract) axesDataTipTemplate

    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(pType, pHandle, hTable, hUnit)
            if isempty(pHandle)
                return
            elseif ~isprop(pHandle, 'DataTipTemplate')
                dt = datatip(pHandle, Visible = 'off');
            end

            set(pHandle.DataTipTemplate, FontName='Calibri', FontSize=10)

            switch pType
                case 'Frequency+Level'
                    pHandle.DataTipTemplate.DataTipRows(1).Label  = '';
                    pHandle.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';                    
                    pHandle.DataTipTemplate.DataTipRows(2).Label  = '';
                    pHandle.DataTipTemplate.DataTipRows(2).Format = ['%.0f ' hUnit];

                case 'Frequency+Occupancy'
                    pHandle.DataTipTemplate.DataTipRows(1).Label  = '';
                    pHandle.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';                    
                    pHandle.DataTipTemplate.DataTipRows(2).Label  = '';
                    pHandle.DataTipTemplate.DataTipRows(2).Format = ['%.0f' hUnit];

                case 'Frequency+Timestamp+Level'
                    switch class(pHandle)
                        case 'matlab.graphics.chart.primitive.Surface'
                            pHandle.DataTipTemplate.DataTipRows(1).Label  = '';
                            pHandle.DataTipTemplate.DataTipRows(2).Label  = '';
                            pHandle.DataTipTemplate.DataTipRows(3).Label  = '';
                                            
                            pHandle.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
                            pHandle.DataTipTemplate.DataTipRows(2).Format =  'dd/MM/yyyy HH:mm:ss';
                            pHandle.DataTipTemplate.DataTipRows(3).Format =  ['%.0f ' hUnit];

                        case 'matlab.graphics.primitive.Image'
                            pHandle.DataTipTemplate.DataTipRows(1).Label  = '';
                            pHandle.DataTipTemplate.DataTipRows(2).Label  = '';

                            pHandle.DataTipTemplate.DataTipRows(2).Format = ['%.0f ' hUnit];                            
                            pHandle.DataTipTemplate.DataTipRows(3)        = [];
                    end

                % case 'Coordinates'
                %     pHandle.DataTipTemplate.DataTipRows(1).Label = 'Latitude:';
                %     pHandle.DataTipTemplate.DataTipRows(2).Label = 'Longitude:';
                %     if numel(pHandle.DataTipTemplate.DataTipRows) > 2
                %         pHandle.DataTipTemplate.DataTipRows(3:end) = [];
                %     end
                % 
                % case 'Coordinates+Frequency'
                %     pHandle.DataTipTemplate.DataTipRows(1).Label = 'Latitude:';
                %     pHandle.DataTipTemplate.DataTipRows(2).Label = 'Longitude:';
                %     pHandle.DataTipTemplate.DataTipRows(3)       = dataTipTextRow('Frequência:', hTable.Frequency, '%.3f MHz');
                %     pHandle.DataTipTemplate.DataTipRows(4)       = dataTipTextRow('Entidade:',   hTable.Name);
                % 
                %     pHandle.DataTipTemplate.DataTipRows          = pHandle.DataTipTemplate.DataTipRows([3:4,1:2]);
                % 
                % case 'SweepID+ChannelPower+Coordinates'
                %     hTable = table((1:numel(pHandle.LatitudeData))', 'VariableNames', {'ID'});
                % 
                %     pHandle.DataTipTemplate.DataTipRows(1).Label = 'Latitude:';
                %     pHandle.DataTipTemplate.DataTipRows(2).Label = 'Longitude:';
                %     pHandle.DataTipTemplate.DataTipRows(3)       = dataTipTextRow('ID:', hTable.ID);
                %     pHandle.DataTipTemplate.DataTipRows(4)       = dataTipTextRow('Potência:', 'CData', '%.1f dBm');
                % 
                %     if numel(pHandle.DataTipTemplate.DataTipRows) > 4
                %         pHandle.DataTipTemplate.DataTipRows(5:end) = [];
                %     end
                % 
                %     pHandle.DataTipTemplate.DataTipRows          = pHandle.DataTipTemplate.DataTipRows([3:4,1:2]);
                % 
                % case 'SweepID+ChannelPower'
                %     pHandle.DataTipTemplate.DataTipRows(1).Label = 'ID:';
                %     pHandle.DataTipTemplate.DataTipRows(2)       = dataTipTextRow('Potência:', 'YData', '%.1f dBm');
            end

            if exist('dt', 'var')
                delete(dt)
            end
        end
    end
end