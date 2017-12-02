function [degree, entropy] = dirgraph(cm,labels,n,cfg)
%dirgraph Plot directed graph from connectivity matrix
%   [degree, entropy] = dirgraph(cm,labels,n,cfg) input connectivity matrix cm, 
%   with sources in the rows and targets in the columns.
%   The threshold is defined as the mean of the connectivity matrix pluss
%   n times the standard deviation. The size of each node is determined
%   as the sum of the number of outputs and inputs to the node, relative 
%   to the node with maximum inputs and outputs.
%
%   Use 'highlight' to select which colormap to use:
%       highlight = 1 -> Colormap on node inputs (default)
%       highlight = 2 -> Colormap on node outputs
    
    m = mean2(cm); 
    sd = std2(cm); 
    if nnz(cm > (m+n*sd))==0
        disp('No connections was found, try a lower threshold.')
        msgbox({'No connections was found,','try a lower threshold.'},'Error','Warn');
        return; 
    end
    
    if isempty(n)
        n =0;
    end
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    labels = sort(labels);

    % Find sources and targets in connectivity matrix   
    s = [];
    t = [];
    weights =[];
    for i=1:60
        for j=1:60
            if cm(i,j)>(m+n*sd) && cm(i,j)>0
                s = [s i];
                t = [t j];
                weights = [weights ; cm(i,j)];
            end
        end
    end
    
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
    
    G = digraph(s,t,[],labels);
    inDeg = indegree(G);
    outDeg= outdegree(G);
    degree = length(weights);
    entropy = sum(weights);
    
    % Create new figure with specified size 
    figure('position', [100, 100, 900, 800]) ;
    hAxesEdge = axes;
    hAxesEdge.XAxis.Visible = 'off';
    hAxesEdge.YAxis.Visible = 'off';
    cmap = colormap('copper');
    cmap = flipud(cmap);
    colormap(hAxesEdge,cmap);
    
    % Plot graph edges
    h(1) = plot(hAxesEdge,G,'XData',x,'YData',y,'EdgeAlpha',0.6,'ArrowSize',15);
    if isfield(cfg, 'title')
        title(cfg.title)
    end
    set(gca,'Ydir','reverse')
    h(1).LineWidth = 2*weights/max(weights);
    h(1).EdgeCData = weights;
    
    % Plot grah nodes in a new axis on top of the first 
    hAxesNode = axes;
    colormap(hAxesNode,'summer');
    h(2) = plot(G,'XData',x,'YData',y,'EdgeAlpha',0);
    set(gca,'Ydir','reverse')
    h(2).MarkerSize=20*(outDeg+inDeg+1)/(max(outDeg+inDeg+1));
    
    if isfield(cfg, 'highlight') 
        if cfg.highlight == 2
            h(2).NodeCData = outDeg;
        else
            h(2).NodeCData = inDeg;
        end
    else
            h(2).NodeCData = inDeg;
    end
    set(gca, 'Color', 'none')
   
    cb1 = colorbar(hAxesEdge,'Location','eastoutside');
    xlabel(cb1,'Edge weights');
    cb2 = colorbar(hAxesNode,'Location','southoutside');
    xlabel(cb2,'Number of inputs');
    set([hAxesEdge,hAxesNode],'Position',[.08 .16 .78 .78]);
    
    hAxesNode.XAxis.Visible = 'off';
    hAxesNode.YAxis.Visible = 'off';
    set(hAxesEdge,'xtick',[])
    set(hAxesEdge,'ytick',[])
end


