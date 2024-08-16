classdef (Abstract) Interactivity

    % As interações com os eixos são de duas naturezas - TOOLBAR e DEFAULT.
    % A TOOLBAR demanda interação com o toolbar do eixo, que fica visível toda
    % vez que o mouse está sobre o eixo, englobando todas as interações com o
    % eixo, incluindo salvar a imagem em arquivo, por exemplo; a DEFAULT, por 
    % outro lado, contempla apenas interações que podem ser aplicadas pelo mouse 
    % diretamente no eixo, não demandando "habilitar" no toolbar a interação.

    % (1) DEFAULT
    %     • hAxes.Interactions = [dataTipInteraction, regionZoomInteraction];
    %     • Interações:
    %       - dataTipInteraction
    %       - panInteraction
    %       - rulerPanInteraction
    %       - zoomInteraction
    %       - regionZoomInteraction
    %       - rotateInteraction
    %     • Métodos:
    %       - enableDefaultInteractivity(hAxes)
    %       - disableDefaultInteractivity(hAxes)
    
    % (2) TOOLBAR
    %     • hAxes.Toolbar = axtoolbar(hAxes, {'pan', 'restoreview'});
    %     • Interações ("Type", "Tag" e "Tooltip"):
    %       - Tipo 'toolbarpushbutton'
    %         'saveas'      'Save as'
    %         'copyimage'   'Copy as image'
    %         'copyvector'  'Copy as vector graphic'
    %         'restoreview' 'Restore view'
    %       - Tipo 'toolbarstatebutton'
    %         'brush'       'Brush data'
    %         'datacursor'  'Data tips'
    %         'rotate'      'Rotate 3D'
    %         'pan'         'Pan'
    %         'zoomin'      'Zoom in'
    %         'zoomout'     'Zoom out'
    %     • Callbacks customizados:
    %       - ButtonPushedFcn
    %       - ValueChangedFcn

    % Interação implementada nos eixos do appAnalise:
    % (1) Eixo cartesiano
    %     • hAxes.Interactions = [dataTipInteraction, regionZoomInteraction];
    %     • hAxes.Toolbar = axtoolbar(hAxes, {'pan', 'restoreview'});
    %     • Callback para forçar panInteraction, quando botão 'pan' está habilitado,
    %       e forçar regionZoomInteractiondesabilitar, quando o botão "pan" está
    %       desabilitado. Implentado porque foi observado comportamentos
    %       inesperados no callback padrão do MATLAB.
    %     • Callback para forçar RestoreView para limites dos eixos xyz orientado
    %       à preferência do usuário (customPlayback) e do próprio appAnalise
    %       (limitando eixo x à faixa de frequência, por exemplo).
    %
    % (2) Eixo geográfico
    %     • hAxes.Interactions = ...
    %     • hAxes.Toolbar = ...

    methods (Static = true)
        %-----------------------------------------------------------------%
        % DEFAULT
        %-----------------------------------------------------------------%
        function DefaultCreation(hAxes, interactionList)
            arguments
                hAxes           matlab.ui.control.UIAxes
                interactionList matlab.graphics.interaction.interface.BaseInteraction = [dataTipInteraction, regionZoomInteraction]
            end

            if ~isempty(interactionList)
                for ii = 1:numel(hAxes)
                    hAxes(ii).Interactions = interactionList;
                    enableDefaultInteractivity(hAxes(ii))
                end

            else
                arrayfun(@(x) disableDefaultInteractivity(x), hAxes)
            end
        end

        %-----------------------------------------------------------------%
        function DefaultEnable(hAxes)
            arrayfun(@(x) enableDefaultInteractivity(x), hAxes)
        end

        %-----------------------------------------------------------------%
        function DefaultDisable(hAxes)
            arrayfun(@(x) disableDefaultInteractivity(x), hAxes)
        end


        %-----------------------------------------------------------------%
        % TOOLBAR
        %-----------------------------------------------------------------%
        function ToolbarCreation(hAxes, interaction2Add, interaction2Remove)
            arguments
                hAxes
                interaction2Add         = {'pan', 'restoreview'}
                interaction2Remove cell = {}
            end

            for ii = 1:numel(hAxes)
                hToolbar = axtoolbar(hAxes(ii), interaction2Add);

                if isa(hAxes, 'matlab.graphics.axis.GeographicAxes')
                    addToolbarMapButton(hToolbar, "basemap")
                end

                if ~isempty(interaction2Remove)
                    idx = cell2mat(cellfun(@(x) find(strcmpi(x, {hToolbar.Children.Tag})), interaction2Remove, 'UniformOutput', false));
                    delete(hToolbar.Children(idx))
                end                

                set(hToolbar.Children, 'Visible', 1)
            end
        end

        %-----------------------------------------------------------------%
        function CustomCallbacks(hAxes, relatedAxes, interaction2Customize, varargin)
            arguments
                hAxes                 (1,1) matlab.ui.control.UIAxes
                relatedAxes                                          = []
                interaction2Customize (1,:) cell                     = {'pan', 'restoreview'}
            end

            arguments (Repeating)
                varargin
            end

            for jj = 1:numel(interaction2Customize)
                [~, hInteraction] = plot.axes.Interactivity.FindInteractionObject(hAxes, 'Toolbar', interaction2Customize{jj});

                if ~isempty(hInteraction)
                    switch interaction2Customize{jj}
                        case 'pan'
                            if isprop(hInteraction, 'ValueChangedFcn')
                                hInteraction.ValueChangedFcn = @(~, evt)plot.axes.Interactivity.CustomPanFcn(evt, hAxes, relatedAxes);
                            end
        
                        case 'restoreview'
                            if isprop(hInteraction, 'ButtonPushedFcn')
                                callingApp = varargin{1};
                                hInteraction.ButtonPushedFcn = @(~, ~)plot.axes.Interactivity.CustomRestoreViewFcn(hAxes, relatedAxes, callingApp);
                            end
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function [idx, hInteraction] = FindInteractionObject(hAxes, axesProperty, varargin)
            idx = [];
            hInteraction = [];

            switch axesProperty
                case 'Toolbar'
                    if ~isempty(hAxes.Toolbar.Children)
                        tag = varargin{1};
                        idx = find(strcmpi({hAxes.Toolbar.Children.Tag}, tag), 1);
                        hInteraction = hAxes.Toolbar.Children(idx);                
                    end

                case 'Interaction'
                    if ~isempty(hAxes.Interactions)
                        objClass = varargin{1};
                        idx = find(strcmp(objClass, arrayfun(@(x) class(x), hAxes.Interactions, "UniformOutput", false)), 1);
                        hInteraction = hAxes.Interactions(idx);
                    end
            end
        end
        
        %-----------------------------------------------------------------%
        function CustomPanFcn(evt, hAxes, relatedAxes)
            hAllAxes = [hAxes, relatedAxes];

            for ii = 1:numel(hAllAxes)
                if evt.Value
                    idx = plot.axes.Interactivity.FindInteractionObject(hAllAxes(ii), 'Interaction', 'matlab.graphics.interaction.interactions.RegionZoomInteraction');
                    hAllAxes(ii).Interactions(idx) = panInteraction;

                else
                    idx = plot.axes.Interactivity.FindInteractionObject(hAllAxes(ii), 'Interaction', 'matlab.graphics.interaction.interactions.PanInteraction');
                    hAllAxes(ii).Interactions(idx) = regionZoomInteraction;
                end
            end

            plot.axes.Interactivity.DefaultEnable(hAllAxes)
        end  
        
        %-----------------------------------------------------------------%
        function CustomRestoreViewFcn(hAxes, relatedAxes, callingApp)
            hAllAxes = [hAxes, relatedAxes];
            
            for ii = 1:numel(hAllAxes)
                set(hAllAxes(ii), 'XLim', callingApp.restoreView(ii).xLim, 'YLim', callingApp.restoreView(ii).yLim)
            end
        end

        %-----------------------------------------------------------------%
        function DeleteListeners(hObject)
            % Foi evidenciado que após a exclusão de ROIs o eixo poderia perder a sua
            % interatividade. Identificado que os listeners automáticos do ROI estavam
            % causando o problema. Foi criado um listener "ObjectBeingDestroyed",
            % apontando esta função, para resolver o problema, forçando a exclusão
            % dos objetos.
        
            % addlistener(hROI, 'MovingROI', @ROICallback);
            % addlistener(hROI, 'ROIMoved',  @ROICallback);
            % addlistener(hROI, 'ObjectBeingDestroyed', @(src, ~)plot.axes.Interactivity.DeleteListeners(src));        
            try
                listenersList = struct(hObject).AutoListeners__;
                cellfun(@(x) delete(x), listenersList)
            catch
            end
        end
    end
end