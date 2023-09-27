function htmlContent = ReportGenerator_HTML(Template, opt)
%  REPORTGENERATOR_HTML Gerador de elementos p/ relatório HTML
    arguments
        Template struct
        opt      cell = {[], '', '', []}
    end
    global ID_img
    global ID_tab
    Type = Template.Type;
    Data = Template.Data;
    htmlContent = '';
    switch Type
        case {'Item', 'Subitem', 'Paragraph'}
            switch Type
                case 'Item';      Class = 'Item_Nivel1';
                case 'Subitem';   Class = 'Item_Nivel2';
                case 'Paragraph'; Class = 'Texto_Justificado';
            end
            htmlContent = sprintf('<p class="%s" contenteditable="%s">%s</p>\n\n', Class, Data.Editable, Data.String);
        case 'Footnote'
            Class = 'Tabela_Texto_8';
            htmlContent = sprintf('<p class="%s" contenteditable="%s" style="color: #808080;">%s</p>\n\n', Class, Data.Editable, Data.String); 
        case 'List'
            Class = 'Texto_Justificado';
            htmlContent = sprintf('<ul style="margin-left: 80px;">');
            for ii = 1:numel(Data)
                htmlContent = sprintf(['%s\n'                                            ...
                                       '\t<li>\n'                                        ...
                                       '\t\t<p class="%s" contenteditable="%s">%s</p>\n' ...
                                       '\t</li>'], htmlContent, Class, Data(ii).Editable, Data(ii).String);
            end
            htmlContent = sprintf('%s\n</ul>\n\n', htmlContent);
        case 'Image'
            fontStyle = 'Tabela_Texto_8';
            
            imgFullPath = opt{1};
            Intro       = opt{2};
            Error       = opt{3};
            LineBreak   = opt{4};
            if ~isempty(imgFullPath)
                if ~isempty(Intro)
                    Intro       = jsondecode(Intro);
                    htmlContent = ReportGenerator_HTML(struct('Type', Intro.Type, 'Data', struct('Editable', 'false', 'String', Intro.String)));
                end
                
                ID_img = ID_img+1;
                [imgExt, imgString] = ReportGenerator_img2base64(imgFullPath);
    
                htmlContent = sprintf(['%s<figure id="image_%.0f">\n'                                                                             ...
                                       '\t<p class="Texto_Centralizado"><img src="data:image/%s;base64,%s" style="width:%s; height:%s;" /></p>\n' ...
                                       '\t<figcaption>\n'                                                                                         ...
                                       '\t\t<p class="%s"><strong>Imagem %.0f. %s</strong></p>\n'                                                 ...
                                       '\t</figcaption>\n'                                                                                        ...
                                       '</figure>\n\n'], htmlContent, ID_img, imgExt, imgString, Data.Settings.Width, Data.Settings.Height, fontStyle, ID_img, Data.Caption);
                if LineBreak
                    htmlContent = sprintf('%s%s', htmlContent, ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;'))));
                end
            else
                if ~isempty(Error)
                    Error       = jsondecode(Error);
                    htmlContent = sprintf('%s%s', htmlContent, ReportGenerator_HTML(struct('Type', Error.Type, 'Data', struct('Editable', 'false', 'String', Error.String))));
                end
            end
        case 'Table'
            tableStyle = 'tabela_corpo';
            fontStyle  = 'Tabela_Texto_8';
            Table     = opt{1};
            Intro     = opt{2};
            Error     = opt{3};
            LineBreak = opt{4};
            if ~isempty(Table)
                if ~isempty(Intro)
                    Intro       = jsondecode(Intro);
                    htmlContent = ReportGenerator_HTML(struct('Type', Intro.Type, 'Data', struct('Editable', 'false', 'String', Intro.String)));
                end
                
                ID_tab  = ID_tab+1;                            
    
                ROWS    = height(Table);
                COLUMNS = width(Table);
            
                % HEADER
                htmlContent = sprintf(['%s<table class="%s" id="table_%.0f">\n'                 ...
                                     '\t<caption>\n'                                            ...
                                     '\t\t<p class="%s"><strong>Tabela %.0f. %s</strong></p>\n' ...
                                     '\t</caption>\n'                                           ...
                                     '\t<thead>\n'                                              ...
                                     '\t\t<tr>'], htmlContent, tableStyle, ID_tab, fontStyle, ID_tab, Data.Caption);
            
                for jj = 1:COLUMNS
                    value = '';
                    if Data.Settings(jj).Width ~= "auto"
                        value = sprintf(' style="width: %s;"', Data.Settings(jj).Width);
                    end
            
                    htmlContent = sprintf(['%s\n'                                              ...
                                         '\t\t\t<th scope="col"%s>\n'                          ...
                                         '\t\t\t\t<p class="%s" contenteditable="%s">%s</p>\n' ...
                                         '\t\t\t</th>'], htmlContent, value, fontStyle, Data.Settings(jj).Editable, Table.Properties.VariableNames{jj});
            
                    rowTemplate{jj} = sprintf(['\t\t\t<td>\n'                                        ...
                                               '\t\t\t\t<p class="%s" contenteditable="%s">%s</p>\n' ...
                                               '\t\t\t</td>'], fontStyle, Data.Settings(jj).Editable, Data.Settings(jj).Precision);
                end
            
                htmlContent = sprintf(['%s\n'       ...
                                     '\t\t</tr>\n'  ...
                                     '\t</thead>\n' ...
                                     '\t<tbody>'], htmlContent);
            
                % BODY
                for ii = 1:ROWS
                    htmlContent = sprintf(['%s\n' ...
                                         '\t\t<tr>'], htmlContent);
            
                    for jj = 1:COLUMNS
                        if isnumeric(Table{ii, jj})
                            value = Table{ii, jj} * Data.Settings(jj).Multiplier;
    
                        elseif ischar(Table{ii, jj}) || isstring(Table{ii, jj})
                            value = char(Table{ii, jj});
    
                        elseif iscell(Table{ii, jj})
                            if ischar(Table{ii, jj}{1}) || isstring(Table{ii, jj}{1})
                                value = char(Table{ii, jj}{1});
    
                            else
                                for kk = 1:numel(Table{ii, jj}{1})
                                    if kk == 1
                                        Table{ii, jj}{1}{kk} = sprintf('%s</p>', Table{ii, jj}{1}{1});
                                    elseif kk == numel(Table{ii, jj}{1})
                                        Table{ii, jj}{1}{kk} = sprintf('<p class="%s" contenteditable="%s">%s',     fontStyle, Data.Settings(jj).Editable, Table{ii, jj}{1}{kk});
                                    else
                                        Table{ii, jj}{1}{kk} = sprintf('<p class="%s" contenteditable="%s">%s</p>', fontStyle, Data.Settings(jj).Editable, Table{ii, jj}{1}{kk});
                                    end
                                end
                                value = strjoin(Table{ii, jj}{1});
    
                            end
                            
                        elseif isdatetime(Table{ii, jj})
                            value = datestr(Table{ii, jj}, 'dd/mm/yyyy HH:MM:SS');
                        end
            
                        htmlContent = sprintf('%s\n%s', htmlContent, sprintf(rowTemplate{jj}, value));
                    end
            
                    htmlContent = sprintf(['%s\n' ...
                                         '\t\t</tr>'], htmlContent);
                end
            
                htmlContent = sprintf(['%s\n'       ...
                                     '\t</tbody>\n' ...
                                     '</table>\n\n'], htmlContent);
                if LineBreak            
                    htmlContent = sprintf('%s%s', htmlContent, ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;'))));
                end
            else
                if ~isempty(Error)
                    Error       = jsondecode(Error);
                    htmlContent = sprintf('%s%s', htmlContent, ReportGenerator_HTML(struct('Type', Error.Type, 'Data', struct('Editable', 'false', 'String', Error.String))));
                end
            end
    end
end