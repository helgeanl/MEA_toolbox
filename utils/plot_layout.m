function plot_layout(channels,labels,cfg)
%plot_layout Plot 60MEA layout with the values in channels 
%   plot_layout(channels,labels,cfg) 
%   channels is a vector with 60 elements containing a value for each
%   channel. These values are then represented by a color map in teh
%   plotted graph. Labels is a 60 element cell array containg strings with 
%   the names of each channel. cfg is a struct containing optional
%   configurations.
%
%   Example:
%       cfg=[];
%       cfg.title = 'Some title';
%       cfg.cbLabel = 'Label of the right colorbar'; 

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


