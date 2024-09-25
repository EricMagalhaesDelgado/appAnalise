function RFLink(hAxes, txSite, rxSite, wayPoints3D, plotMode)
    arguments
        hAxes
        txSite
        rxSite
        wayPoints3D
        plotMode   char {mustBeMember(plotMode,  {'dark', 'light'})}  = 'light'
    end

    % ## prePlot
    % (a) Altura das estações TX-RX.
    txAntenna = wayPoints3D(1,3);
    if txSite.AntennaHeight > 0
        txAntenna = txAntenna + txSite.AntennaHeight;
    end

    rxAntenna = wayPoints3D(end,3);
    if rxSite.AntennaHeight > 0
        rxAntenna = rxAntenna + rxSite.AntennaHeight;
    end

    % (b) 1ª Zona de Fresnel, atenuação no espaço livre e análise de visada 
    %     entre TX e RX.
    [Rn, Dm, d1] = RF.Propagation.FresnelZone(txSite, rxSite, height(wayPoints3D));
    vq  = interp1([0, Dm], [txAntenna, rxAntenna], d1, 'linear');    
    PL  = fspl(d1, physconst('LightSpeed')/txSite.TransmitterFrequency);
    [~, xFirstObstruction] = RF.Propagation.LOS(wayPoints3D(:,3), vq, Rn);

    % (c) Cores
    [faceColorTerrain, ...
     edgeColorTerrain] = Color(plotMode, 'Terrain');
    colorObstruction   = Color(plotMode, 'FirstObstruction');
    colorStation       = Color(plotMode, 'Station');
    colorLink          = Color(plotMode, 'Link');
    colorFresnel       = Color(plotMode, 'Fresnel');

    % ## Plot
    cla(hAxes)
    hAxes.XLimMode = 'auto';
    hAxes.YLimMode = 'auto';

    % (a) Perfil de terreno e primeira obstrução (caso aplicável).
    hTerrain = area(hAxes, d1/1000, wayPoints3D(:,3), BaseValue=0, FaceColor=faceColorTerrain, EdgeColor=edgeColorTerrain, Tag='Terrain');
    hTerrainTable = table(wayPoints3D(:,1), wayPoints3D(:,2), wayPoints3D(:,3), 'VariableNames', {'Latitude', 'Longitude', 'Elevation'});
    plot.datatip.Template(hTerrain, 'RFLink.Terrain', hTerrainTable)

    if ~isempty(xFirstObstruction)
        stem(hAxes, d1(xFirstObstruction)/1000, wayPoints3D(xFirstObstruction,3), 'filled', 'Marker', 'square', 'MarkerSize', 8, 'MarkerFaceColor', colorObstruction, 'LineStyle', '-.', 'Color', colorObstruction, 'PickableParts', 'none', 'Tag', 'FirstObstruction');
    end
    
    % (b) Estações TX e RX.
    stem(hAxes, 0,       txAntenna, 'filled', 'MarkerFaceColor', colorStation, 'Color', colorStation,                'PickableParts', 'none', 'Tag', 'Station');
    stem(hAxes, Dm/1000, rxAntenna, 'filled', 'MarkerFaceColor', colorStation, 'Color', colorStation, 'Marker', '^', 'PickableParts', 'none', 'Tag', 'Station');
    
    % (c) Linha de visada entre TX e RX.
    hLOS = plot(hAxes, d1/1000, vq, 'Color', colorLink, 'LineStyle', '-.', 'LineWidth', .5,  'Tag', 'Link');
    hLOSTable = table(d1/1000, vq, PL, 'VariableNames', {'Distance', 'Height', 'PathLoss'});
    plot.datatip.Template(hLOS, 'RFLink.LOS', hLOSTable)

    % (d) 1ª Zona de Fresnel.
    images.roi.Polygon(hAxes, Position=[d1/1000, vq+Rn; flip(d1/1000), flip(vq-Rn)], ...
                              Color=colorFresnel, ...
                              Deletable=0, ...
                              EdgeAlpha=.25, ...
                              FaceAlpha=.05, ...
                              FaceSelectable=0, ...
                              InteractionsAllowed='none', ...
                              LineWidth=.5, ...
                              Tag='Fresnel');

    hAxes.YLim(1) = max(hAxes.YLim(1), min(wayPoints3D(:,3))-1);
    hTerrain.BaseValue = hAxes.YLim(1);

    % ## post-Plot
    hAxes.UserData = struct('TX', txSite, 'RX', rxSite);
    plot.axes.StackingOrder.execute(hAxes, 'RFLink')
end

%-------------------------------------------------------------------------%
function varargout = Color(plotMode, plotTag)
    switch plotMode
        case 'light'
            switch plotTag
                case 'Terrain'
                    FaceColor = [0.94,.94,.94];
                    EdgeColor = [0.80,0.80,0.80];
                    varargout = {FaceColor, EdgeColor};
                case 'FirstObstruction'
                    Color     = [0,0,0];
                    varargout = {Color};
                case {'Station', 'Link'}
                    Color     = '#c94756';
                    varargout = {Color};
                case 'Fresnel'
                    Color     = 'red';
                    varargout = {Color};
            end

        case 'dark'
            switch plotTag
                case 'Terrain'
                    FaceColor = '#333333';
                    EdgeColor = '#777777';
                    varargout = {FaceColor, EdgeColor};
                case 'FirstObstruction'
                    Color     = [.94,.94,.94];
                    varargout = {Color};
                case 'Station'
                    Color     = 'cyan';
                    varargout = {Color};
                case {'Link', 'Fresnel'}
                    Color     = 'cyan';
                    varargout = {Color};
            end
    end
end