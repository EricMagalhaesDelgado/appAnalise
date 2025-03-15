function roiSpecification = roiSpecificationFromHandle(hROI)
    % Características mínimas de cada tipo de ROI para que seja
    % possível a sua reconstrução programáticamente...
    
    switch class(hROI)
        case 'images.roi.Line'
            roiSpecification = struct('Position', hROI.Position);

        case 'images.roi.Circle'
            roiSpecification = struct('Center', hROI.Center, 'Radius', hROI.Radius);

        case 'images.roi.Rectangle'
            roiSpecification = struct('Position', hROI.Position, 'RotationAngle', hROI.RotationAngle);

        case 'images.roi.Polygon'
            roiSpecification = struct('Position', hROI.Position);

        case 'map.graphics.chart.primitive.Polygon'
            roiSpecification = struct('Latitude',  struct(hROI.ShapeData).InternalData.VertexCoordinate1, ...
                                      'Longitude', struct(hROI.ShapeData).InternalData.VertexCoordinate2);
    end
end