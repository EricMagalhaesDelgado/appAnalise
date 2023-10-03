function DataTipModel(newObj, newObjUnit)

    if ~isprop(newObj, 'DataTipTemplate')
        dt = datatip(newObj, Visible = 'off');
    end
    set(newObj.DataTipTemplate, FontName='Calibri', FontSize=10)
            
    switch class(newObj)
        case {'matlab.graphics.chart.primitive.Line', 'matlab.graphics.chart.primitive.Area'}
            newObj.DataTipTemplate.DataTipRows(1).Label  = '';
            newObj.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
            
            newObj.DataTipTemplate.DataTipRows(2).Label  = '';
            newObj.DataTipTemplate.DataTipRows(2).Format = ['%.0f ' newObjUnit];

        case 'matlab.graphics.primitive.Image'            
            newObj.DataTipTemplate.DataTipRows(1).Label  = '';
%           newObj.DataTipTemplate.DataTipRows(1).Value  = 'XData';
%           newObj.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
            
            newObj.DataTipTemplate.DataTipRows(2).Label  = '';
            newObj.DataTipTemplate.DataTipRows(2).Format =  ['%.0f ' newObjUnit];
            
            newObj.DataTipTemplate.DataTipRows(3)        = [];

        case 'matlab.graphics.chart.primitive.Surface'
            newObj.DataTipTemplate.DataTipRows(1).Label = '';
            newObj.DataTipTemplate.DataTipRows(2).Label = '';
            newObj.DataTipTemplate.DataTipRows(3).Label = '';
                            
            newObj.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
            newObj.DataTipTemplate.DataTipRows(2).Format =  'dd/MM/yyyy HH:mm:ss';
            newObj.DataTipTemplate.DataTipRows(3).Format =  ['%.0f ' newObjUnit];
    end

    if exist('dt', 'var')
        delete(dt)
    end
    
end