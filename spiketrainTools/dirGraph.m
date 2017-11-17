function dirGraph(cm,n, highlight)
%dirGraph Plot directed graph from connectivity matrix
%   dirGraph(cm,n, highlight) input connectivity matrix cm, 
%   with sources in the rows and targets in the columns.
%   The threshold is defined as the mean of the connectivity matrix pluss
%   n times the standard deviation. The size of each node is determined
%   as the sum of the number of outputs and inputs to the node, relative 
%   to the node with maximum inputs and outputs.
%
%   Use 'highlight' to select which colormap to use:
%       highlight = 0 -> Colormap on edge weights (default)
%       highlight = 1 -> Colormap on node inputs
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
    labels = getLabels();
    labels{15}='15'; % Switch out 'Ref' with '15' to be able to sort
    labels = sort(labels);

    % Find sources and targets in connectivity matrix   
    s = [];
    t = [];
    weights =[];
    for i=1:60
        for j=1:60
            if cm(i,j)>(m+n*sd)
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
    
    % Create new figure with specified size 
    figure('position', [100, 100, 900, 800]) 
    p = plot(G,'XData',x,'YData',y,'EdgeAlpha',0.6,'ArrowSize',15);
    set(gca,'Ydir','reverse')

    p.LineWidth = 2*weights/max(weights);
    p.MarkerSize=20*(outDeg+inDeg+1)/(max(outDeg+inDeg+1));
    
    defaultColor = [0.5725 0.5725 0.5725];
    if  highlight == 1
        colormap('summer');
        cb = colorbar;
        xlabel(cb,'Number of inputs');
        p.EdgeColor = defaultColor;
        p.NodeCData = inDeg;
    elseif highlight == 2
        colormap('summer');
        cb = colorbar;
        xlabel(cb,'Number of outputs');
        p.EdgeColor = defaultColor;
        p.NodeCData = outDeg;
    else
        cmap = colormap('gray');
        cmap = flipud(cmap);
        colormap(cmap);
        cb = colorbar;
        xlabel(cb,'Edge weight');
        p.NodeColor = defaultColor;
        p.EdgeCData = weights;
    end
end


