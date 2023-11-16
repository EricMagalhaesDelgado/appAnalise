function datetimeComponents(app, BeginTime, EndTime)

    % BeginTime
    app.report_Spinner1.Value = BeginTime.Hour;
    app.report_Spinner2.Value = BeginTime.Minute;

    % EndTime
    % Arredondamento inicial, buscando evitar filtragem automática dos fluxos 
    % espectrais por conta da falta de apresentação do SEGUNDO nos final da 
    % observação nos componentes da GUI.
    if EndTime.Second > 0
        EndTime.Minute = EndTime.Minute+1;
    end
    app.report_Spinner3.Value = EndTime.Hour;
    app.report_Spinner4.Value = EndTime.Minute;

    % Arredondamentos final, buscanod evitar embutir nos componentes DatePicker 
    % os valores de HORA, MINUTO e SEGUNDO.
    BeginTime.Hour   = 0;
    BeginTime.Minute = 0;
    BeginTime.Second = 0;

    EndTime.Hour     = 0;
    EndTime.Minute   = 0;
    EndTime.Second   = 0;
    
    app.report_DatePicker1.Limits = [BeginTime, EndTime];
    app.report_DatePicker2.Limits = app.report_DatePicker1.Limits;
    
    app.report_DatePicker1.Value  = app.report_DatePicker1.Limits(1);
    app.report_DatePicker2.Value  = app.report_DatePicker2.Limits(2);
end