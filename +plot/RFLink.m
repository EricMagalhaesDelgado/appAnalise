% elevationCache = struct('txSiteID', {}, 'rxSiteID', {}, 'PointsPerLink', {}, 'Server', {}, 'wayPoints3D', {}, 'zMatrix', {}, 'zMatrixReference', {})


function RFLink(app, hAxes, txObj, rxObj, txIndex, rxIndex, nPoints)    

    % Identifica se está em CACHE ou requisita à API...
    newLink     = struct('txSiteID',      txIndex,                                ...
                         'rxSiteID',      jsonencode(app.pointsTable(rxIndex,:)), ...
                         'PointsPerLink', nPoints,                                ...
                         'Server',        app.misc_ElevationAPISource.Value);

    wayPoints2D = gcwaypts(txObj.Latitude, txObj.Longitude, rxObj.Latitude, rxObj.Longitude, nPoints-1);
    cacheIndex  = misc_simulationCacheCheck(app, newLink, wayPoints2D);

    if isempty(cacheIndex)                
        try
            [newLink.wayPoints3D, ...
             newLink.zMatrix,     ...
             newLink.zMatrixReference] = fcn.ElevationQuery(app.misc_ElevationAPISource.Value, wayPoints2D);
            app.elevationCache(end+1)  = newLink;

        catch ME
            appUtil.modalWindow(app.UIFigure, 'warning', ME.message);
            return
        end

    else
        newLink = app.elevationCache(cacheIndex);

        if strcmp(app.elevationCache(cacheIndex).Server, 'MathWorks WMS Server')
            wayPoints3D = [wayPoints2D, geointerp(app.elevationCache(cacheIndex).zMatrix, app.elevationCache(cacheIndex).zMatrixReference, wayPoints2D(:,1), wayPoints2D(:,2), "nearest")];
            
            % Interpola/extrapola as elevações que estejam fora do
            % polígono armazenado no cache...
            nanIndex = isnan(wayPoints3D(:,3));
            if any(nanIndex)
                xArray = (1:nPoints)';
                yArray = wayPoints3D(:,3);

                wayPoints3D(nanIndex,3) = interp1(xArray(~nanIndex), yArray(~nanIndex), find(nanIndex), 'nearest', 'extrap');
            end
            newLink.wayPoints3D = wayPoints3D;
        end
    end

    % Ajusta antena da antena (agora considerando a elevação do
    % local):
    txID = sprintf(' \\bfTX\n ID: %s\n Frequência: %.3f MHz\n Latitude: %.6fº\n Longitude: %.6fº\n Descrição: %s\n Serviço: %d\n Estação: %d', txObj.ID, txObj.Frequency/1e+6, txObj.Latitude, txObj.Longitude, txObj.Description, txObj.Service, txObj.Station);
    rxID = sprintf('\\bfRX \nLatitude: %.6fº \nLongitude: %.6fº ', rxObj.Latitude, rxObj.Longitude);

    txAntenna = newLink.wayPoints3D(1,3);
    if txObj.AntennaHeight > 0
        txID = sprintf('%s\n Altura da antena: %.1fm', txID, txObj.AntennaHeight);
        txAntenna = txAntenna + txObj.AntennaHeight;
    end

    rxAntenna = newLink.wayPoints3D(end,3);
    if rxObj.AntennaHeight > 0
        rxID = sprintf('%s\nAltura da antena: %.1fm ', rxID, rxObj.AntennaHeight);
        rxAntenna = rxAntenna + rxObj.AntennaHeight;
    end

    % Calcula a elipse da 1ª Zona de Fresnel:
    [Rn, D, d1] = fcn.FresnelZone(txObj, rxObj, nPoints);
    vq = interp1([0, D], [txAntenna, rxAntenna], d1, 'linear');

    % Plot: Mapa
    delete(findobj(app.UIAxes1, 'Tag', 'SimulationLink', '-or', 'Tag', 'SimulationCacheLink'))
    
    misc_ElevationCachePlotValueChanged(app)
    
    hold(app.UIAxes1, "on")
    geoplot(app.UIAxes1, newLink.wayPoints3D(:,1), newLink.wayPoints3D(:,2), Color='#c94756', LineStyle='-.', PickableParts='none', Tag='SimulationLink');
    hold(app.UIAxes1, "off")            

    % Plot: Eixo cartográfico
    cla(hAxes)

    hold(hAxes, "on")
    hAxes.YLimMode = 'auto';

    p1 = area(hAxes, d1/1000, newLink.wayPoints3D(:,3), BaseValue=0, FaceColor=[0.94,.94,.94], EdgeColor=[0.80,0.80,0.80]);
    stem(hAxes, 0, txAntenna, "filled", "MarkerFaceColor", '#c94756', 'Color', '#c94756', PickableParts='none');
    stem(hAxes, D/1000, rxAntenna, "filled", "MarkerFaceColor", '#c94756', 'Color', '#c94756', 'Marker', '^', PickableParts='none');
    plot(hAxes, [0, D/1000], [txAntenna, rxAntenna], Color='#c94756', LineStyle='-.', LineWidth=.5, PickableParts='none');            
    images.roi.Polygon(hAxes, Position=[d1/1000, vq+Rn; flip(d1/1000), flip(vq-Rn)], ...
                                    Color='red', ...
                                    Deletable=0, ...
                                    EdgeAlpha=.25, ...
                                    FaceAlpha=.05, ...
                                    FaceSelectable=0, ...
                                    InteractionsAllowed='none', ...
                                    LineWidth=.5);
    text(hAxes, 0, 1, txID, Units='normalized', FontSize=10, Interpreter='tex', VerticalAlignment='top', PickableParts='none');
    text(hAxes, 1, 1, rxID, Units='normalized', FontSize=10, Interpreter='tex', VerticalAlignment='top', PickableParts='none', HorizontalAlignment='right');

    hAxes.YLim(1) = 0;
    hAxes.YLim(2) = max([hAxes.YLim(2), txAntenna, rxAntenna]);
    hAxes.XLim = [0, D/1000];

    % Esse trecho é importante pra garantir que o XTick seja
    % crescente, evitando erros decorrentes da aproximação...            
    for kk = 5:-1:1
        XTick      = round(linspace(0, D/1000, kk), 1);
        XTick(end) = hAxes.XLim(2);
        if issorted(XTick, "strictascend")
            break
        end
    end

    XTickLabel = string(XTick);
    XTickLabel(end) = sprintf("%.1f", XTick(end));
    set(hAxes, XTick=XTick, XTickLabel=XTickLabel)
    
    hAxes.XAxis.Exponent = 0;
    plot.datatip.Template(p1, 'winRFDataHub.SimulationLink')
    hAxes.UserData = struct('ID', app.UITable.Data{idx,1});
    hold(hAxes, "off")

    app.restoreView = {hAxes.XLim, hAxes.YLim};
    filter_TableStyle(app, 'TerrainProfilePlot')
end