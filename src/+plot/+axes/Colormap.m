function Colormap(hAxes, colormapName)

    if isempty(hAxes.UserData) || ~isfield(hAxes.UserData, 'Colormap') || (isfield(hAxes.UserData, 'Colormap') && ~strcmp(hAxes.UserData.Colormap, colormapName))
        colormap(hAxes, colormapName);
        if ~strcmp(hAxes.Color, 'none')
            hAxes.Colormap(1,:) = hAxes.Color;
        end
    
        % O MATLAB não tem uma função que retorna o nome do colormap ("summer" ou 
        % "hot", por exemplo). Para contornar esse problema, o nome do colormap é 
        % armazenada na propriedade "UserData" do eixo.
        hAxes.UserData.Colormap = colormapName;
    end
    
end