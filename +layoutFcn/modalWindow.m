function d = modalWindow(fHandle, type, msg, varargin)
    arguments
        fHandle matlab.ui.Figure
        type    {mustBeMember(type, {'ccTools.MessageBox', 'ccTools.ProgressDialog', 'error', 'warning', 'info', 'progressdlg'})}
        msg     {ccTools.validators.mustBeScalarText} = ''
    end

    arguments (Repeating)
        varargin
    end
    
    d = [];
    switch type
        case 'ccTools.MessageBox'
            ccTools.MessageBox(fHandle, msg, varargin{:});
            beep

        case 'ccTools.ProgressDialog'
            d = ccTools.ProgressDialog(fHandle, varargin{:});

        case {'error', 'warning', 'info'}
            msg = sprintf('<p style="font-size:12px;">%s</p>', msg);            
            switch type
                case 'error';   uialert(fHandle, msg, '', 'Interpreter', 'html', 'Icon', 'error',       varargin{:})
                case 'warning'; uialert(fHandle, msg, '', 'Interpreter', 'html', 'Icon', 'warning',     varargin{:})
                case 'info';    uialert(fHandle, msg, '', 'Interpreter', 'html', 'Icon', 'LT_info.png', varargin{:})
            end
            beep
            
        case 'progressdlg'
            msg = sprintf('<p style="font-size:12px;">%s</p>', msg);
            d = uiprogressdlg(fHandle, 'Indeterminate', 'on', 'Interpreter', 'html', 'Message', msg, varargin{:});
    end
end