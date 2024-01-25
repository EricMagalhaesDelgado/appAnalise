function [wayPoints3D, zMatrix, zMatrixReference] = ElevationQuery(Server, wayPoints2D)

    switch Server
        case 'Open-Elevation'
            % https://api.open-elevation.com/api/v1/lookup?locations=41.161758,-8.583933|-12.5,-38.5
            APIRequest         = "https://api.open-elevation.com/api/v1/lookup?locations=" + strjoin(string(wayPoints2D(:,1)) + "," + string(wayPoints2D(:,2)), '|');
            APIAnswer          = webread(APIRequest, weboptions(Timeout=10));

            wayPoints3D        = cell2mat(cellfun(@(x) [x.latitude, x.longitude x.elevation], APIAnswer.results, 'UniformOutput', false));
            zMatrix            = [];
            zMatrixReference   = [];            

        %-----------------------------------------------------------------%
        case 'MathWorks WMS Server'
            WMSLayerObject     = wmsfind("mathworks", SearchField="serverurl");
            WMSLayerObject     = refine(WMSLayerObject, "elevation");

            [latLim1, latLim2] = bounds(wayPoints2D(:,1));
            [lonLim1, lonLim2] = bounds(wayPoints2D(:,2));

            [zMatrix, ...
             zMatrixReference] = wmsread(WMSLayerObject, Latlim=[latLim1, latLim2], Lonlim=[lonLim1, lonLim2], ImageFormat="image/bil");
            zMatrix            = double(zMatrix);
            wayPoints3D        = [wayPoints2D, geointerp(zMatrix, zMatrixReference, wayPoints2D(:,1), wayPoints2D(:,2), "nearest")];
    end
end