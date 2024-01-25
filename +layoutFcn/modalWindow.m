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
            msg = sprintf('<font style="font-size:12;">%s</font>', msg);            
            switch type
                case 'error';   uialert(fHandle, msg, '', 'Interpreter', 'html', varargin{:})
                case 'warning'; uialert(fHandle, msg, '', 'Interpreter', 'html', 'Icon', 'warning', varargin{:});
                case 'info';    uialert(fHandle, msg, '', 'Interpreter', 'html', 'Icon', 'LT_info.png', varargin{:})
            end
            beep
            
        case 'progressdlg'
            msg = sprintf('<font style="font-size:12;">%s</font>', msg);
            d = uiprogressdlg(fHandle, 'Indeterminate', 'on', 'Interpreter', 'html', 'Message', msg, varargin{:});
    end
end