function plot_layout(channels,labels,cfg)
%dirGraph Plot directed graph from connectivity matrix
%   dirGraph(cm,n, highlight) input connectivity matrix cm, 
%   with sources in the rows and targets in the columns.
%   The threshold is defined as the mean of the connectivity matrix pluss
%   n times the standard deviation. The size of each node is determined
%   as the sum of the number of outputs and inputs to the node, relative 
%   to the node with maximum inputs and outputs.
%
%   Use 'highlight' to select which colormap to use:
%       highlight = 1 -> Colormap on node inputs (default)
%       highlight = 2 -> Colormap on node outputs
    

    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; % Switch out 'Ref' with '15' to be able to sort
    end
    labels = sort(labels);
    
    % Find position of each node
    label = 11;
    x = [];
    y = [];
    for i = 1:8
        for j = 1:8
            if ~((i==1 || i==8)&& (j==1 || j==8))
                x = [x i];
                y = [y j];
            end
            if mod(label,10) < 8
                label = label +1;
            else
                label = label +3;
            end
        end
    end
    
    G = graph([],[],[],labels);
    
    % Create new figure with specified size 
    figure('position', [100, 100, 900, 800]) ;
    hAxesNode = axes;
    colormap(hAxesNode,'summer');
    h = plot(G,'XData',x,'YData',y);
    set(gca,'Ydir','reverse')
    h.MarkerSize = 20;
    h.NodeCData = channels;

    cb2 = colorbar(hAxesNode,'Location','eastoutside');
    if isfield(cfg, 'cbLabel')
        xlabel(cb2,cfg.cbLabel);
    end
    set(hAxesNode,'xtick',[]);
    set(hAxesNode,'ytick',[]);
    if isfield(cfg, 'title')
        title(cfg.title)
    end
end


