function Misc_DataTipSettings(newObj, newObjUnit)
    
    if strcmpi(newObj.Type, 'line') || strcmpi(newObj.Type, 'area')
        set(newObj.DataTipTemplate, FontName='Calibri', FontSize=10)
        
        newObj.DataTipTemplate.DataTipRows(1).Label = '';
        newObj.DataTipTemplate.DataTipRows(2).Label = '';
        
        newObj.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
        newObj.DataTipTemplate.DataTipRows(2).Format = ['%.0f ' newObjUnit];
    
    elseif strcmpi(newObj.Type, 'surface')
        set(newObj.DataTipTemplate, FontName='Calibri', FontSize=10)
        
        newObj.DataTipTemplate.DataTipRows(1).Label = '';
        newObj.DataTipTemplate.DataTipRows(2).Label = '';
        newObj.DataTipTemplate.DataTipRows(3).Label = '';
                        
        newObj.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
        newObj.DataTipTemplate.DataTipRows(2).Format =  'dd/MM/yyyy HH:mm:ss';
        newObj.DataTipTemplate.DataTipRows(3).Format =  ['%.0f ' newObjUnit];
    
    else
        error('Objeto do tipo %s não esperado.', newObj.Type)
    end
    
end