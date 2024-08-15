classdef (Abstract) axesInteraction

    methods (Static = true)
        %-----------------------------------------------------------------%
        function CartesianToolbar(Axes, Interactions)
            for ii = 1:numel(Axes)
                axtoolbar(Axes(ii), Interactions);
                set(Axes(ii).Toolbar.Children, Visible=1)
            end
        end


        %-----------------------------------------------------------------%
        function GeographicToolbar(Axes, Interactions, Interaction2Remove)
            for ii = 1:numel(Axes)
                t = axtoolbar(Axes(ii), Interactions);
                addToolbarMapButton(t, "basemap")

                if ~isempty(Interaction2Remove)
                    delete(findobj(t, Tag=Interaction2Remove))
                end                

                set(Axes(ii).Toolbar.Children, Visible=1)
            end
        end


        %-----------------------------------------------------------------%
        function CartesianDefaultInteractions(Axes, Interactions)
            if ~isempty(Interactions)
                for ii = 1:numel(Axes)
                    Axes(ii).Interactions = Interactions;
                    enableDefaultInteractivity(Axes(ii))
                end

            else
                arrayfun(@(x) disableDefaultInteractivity(x), Axes)
            end
        end


        %-----------------------------------------------------------------%
        function EnableDefaultInteractions(Axes)
            arrayfun(@(x) enableDefaultInteractivity(x), Axes)
        end


        %-----------------------------------------------------------------%
        function DisableDefaultInteractions(Axes)
            arrayfun(@(x) disableDefaultInteractivity(x), Axes)
        end


        %-----------------------------------------------------------------%
        function InteractionsCallbacks(Interactions, Axes, app)
            for ii = 1:numel(Interactions)
                h = arrayfun(@(x) findobj(x.Toolbar, 'Tooltip', Interactions{ii}), Axes, "UniformOutput", false);
                h(cellfun(@(x) isempty(x), h)) = [];
            
                for jj = 1:numel(h)
                    switch Interactions{ii}
                        case 'Pan'
                            if isprop(h{jj}, 'ValueChangedFcn')
                                h{jj}.ValueChangedFcn = @(~,evt)plotFcn.axesInteraction.panInteractionFcn(evt, Axes);
                            end

                        case 'Data tips'
                            if isprop(h{jj}, 'ValueChangedFcn')
                                h{jj}.ValueChangedFcn = @(src,evt)plotFcn.axesInteraction.datatipInteractionFcn(src, evt, Axes);
                            end
        
                        case 'Restore view'
                            switch class(app)
                                case 'winAppAnalise'
                                    if isprop(h{jj}, 'ButtonPushedFcn')
                                        h{jj}.ButtonPushedFcn = @(~,~)plotFcn.axesInteraction.winAppAnalise_restoreViewFcn(app);
                                    end

                                case 'auxApp.winRFDataHub'
                                   if isprop(h{jj}, 'ButtonPushedFcn')
                                        h{jj}.ButtonPushedFcn = @(~,~)plotFcn.axesInteraction.winRFDataHub_restoreViewFcn(app);
                                   end

                                case 'auxApp.winDriveTest'
                                   if isprop(h{jj}, 'ButtonPushedFcn')
                                        h{jj}.ButtonPushedFcn = @(~,~)plotFcn.axesInteraction.winDriveTest_restoreViewFcn(app);
                                   end

                                case 'auxApp.winSignalAnalysis'
                                   if isprop(h{jj}, 'ButtonPushedFcn')
                                        h{jj}.ButtonPushedFcn = @(~,~)plotFcn.axesInteraction.winSignalAnalysis_restoreViewFcn(app);
                                   end

                                case 'auxApp.winGraphicAnalysis'
                                   if isprop(h{jj}, 'ButtonPushedFcn')
                                        h{jj}.ButtonPushedFcn = @(~,~)plotFcn.axesInteraction.winGraphicAnalysis_restoreViewFcn(app);
                                   end
                            end
                    end
                end
            end
        end
        
        
        %-----------------------------------------------------------------%
        function panInteractionFcn(evt, Axes)
            for ii = 1:numel(Axes)
                if evt.Value
                    Axes(ii).Interactions(2) = panInteraction;
                else
                    Axes(ii).Interactions(2) = regionZoomInteraction;
                end
            end
            arrayfun(@(x) enableDefaultInteractivity(x), Axes)
        end


        %-----------------------------------------------------------------%
        function datatipInteractionFcn(src, evt, Axes)
            matlab.graphics.controls.internal.interactionsModeCallback('datacursor', src, evt);
            if ~evt.Value
                arrayfun(@(x) enableDefaultInteractivity(x), Axes)
            end
        end
        
        
        %-----------------------------------------------------------------%
        % Função aplicável apenas ao app principal - o "winAppAnalise".
        %-----------------------------------------------------------------%
        function winAppAnalise_restoreViewFcn(app)
            xLimits = app.restoreView{1};
            yLimits = app.restoreView{2};
        
            set(app.axes1, XLim=xLimits, YLim=yLimits)
            
            if ~isempty(app.axes2.Children)
                app.axes2.YLim = [0,100];
            end
        
            if ~isempty(app.axes3.Children)
                app.axes3.YLim = app.restoreView{3};
            end
        end


        %-----------------------------------------------------------------%
        % Função aplicável apenas ao app auxiliar "auxApp.winRFDataHub".
        %-----------------------------------------------------------------%
        function winRFDataHub_restoreViewFcn(app)
            xLimits = app.restoreView{1};
            yLimits = app.restoreView{2};
        
            set(app.UIAxes4, XLim=xLimits, YLim=yLimits)
        end


        %-----------------------------------------------------------------%
        % Função aplicável apenas ao app auxiliar "auxApp.winDriveTest".
        %-----------------------------------------------------------------%
        function winDriveTest_restoreViewFcn(app)
            xLimits = app.restoreView{1};
            yLimits = app.restoreView{2};
        
            set(app.UIAxes2, XLim=xLimits, YLim=yLimits)
        end


        %-----------------------------------------------------------------%
        % Função aplicável apenas ao app auxiliar "auxApp.winSignalAnalysis".
        %-----------------------------------------------------------------%
        function winSignalAnalysis_restoreViewFcn(app)
            xLimits = app.restoreView{1};
            yLimits = app.restoreView{2};
        
            set(app.UIAxes1, XLim=xLimits, YLim=yLimits)
        end


        %-----------------------------------------------------------------%
        % Função aplicável apenas ao app auxiliar "auxApp.winGraphicAnalysis".
        %-----------------------------------------------------------------%
        function winGraphicAnalysis_restoreViewFcn(app)
            xLimits = app.restoreView{1};
            yLimits = app.restoreView{2};
            zLimits = app.restoreView{3};
        
            set(app.UIAxes2, XLim=xLimits, YLim=yLimits, ZLim=zLimits)
        end
    end
end