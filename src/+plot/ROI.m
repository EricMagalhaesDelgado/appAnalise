classdef (Abstract) ROI

    methods (Static = true)
        %-----------------------------------------------------------------%
        function hROI = draw(Type, hAxes, customProp)
            
            % ToDo
            % Em 16/03/25: pendente concetrar nessa classe a criação desse 
            % tipo de plot. Ainda há criação de ROIs nos módulos winDriveTest 
            % e winRFDataHub.

            arguments
                Type char {mustBeMember(Type, {'images.roi.Line',      ...
                                               'images.roi.Circle',    ...
                                               'images.roi.Rectangle', ...
                                               'images.roi.Polygon'})}
                hAxes
                customProp cell = {}
            end
        
            defaultProp = plot.ROI.defaultProperties(Type);
        
            switch Type
                case 'images.roi.Line'
                    hROI = images.roi.Line(hAxes, defaultProp{:});

                case 'images.roi.Circle'
                    hROI = images.roi.Circle(hAxes, defaultProp{:});

                case 'images.roi.Rectangle'
                    hROI = images.roi.Rectangle(hAxes, defaultProp{:});

                case 'images.roi.Polygon'
                    hROI = images.roi.Polygon(hAxes, defaultProp{:});
            end
        
            if ~isempty(customProp)
                set(hROI, customProp{:})
            end
        end
        
        %-----------------------------------------------------------------%
        function defaultProp = defaultProperties(Type)
            arguments
                Type char {mustBeMember(Type, {'images.roi.Line',      ...
                                               'images.roi.Circle',    ...
                                               'images.roi.Rectangle', ...
                                               'images.roi.Polygon'})}
            end

            switch Type
                case 'images.roi.Line'
                    defaultProp = {'Color', 'red',  ...
                                   'MarkerSize', 4, ...
                                   'LineWidth', 1,  ...
                                   'Deletable', 0,  ...
                                   'InteractionsAllowed', 'translate'};
        
                otherwise
                    defaultProp = {'LineWidth', 1,  ...
                                   'Deletable', 0,  ...
                                   'FaceSelectable', 0};
            end
        
            if Type == "Rectangle"
                defaultProp = [defaultProp, {'Rotatable', true}];
            end
        end

        %-----------------------------------------------------------------%
        function spec = specification(hROI)
            % Características mínimas de cada tipo de ROI para que seja
            % possível a sua reconstrução programaticamente...
            
            switch class(hROI)
                case 'images.roi.Line'
                    spec = struct('Position', hROI.Position);
        
                case 'images.roi.Circle'
                    spec = struct('Center', hROI.Center, 'Radius', hROI.Radius);
        
                case 'images.roi.Rectangle'
                    spec = struct('Position', hROI.Position, 'RotationAngle', hROI.RotationAngle);
        
                case 'images.roi.Polygon'
                    spec = struct('Position', hROI.Position);
        
                case 'map.graphics.chart.primitive.Polygon'
                    spec = struct('Latitude',  struct(hROI.ShapeData).InternalData.VertexCoordinate1, ...
                                  'Longitude', struct(hROI.ShapeData).InternalData.VertexCoordinate2);
            end
        end
    end
end