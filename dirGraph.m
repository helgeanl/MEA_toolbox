function [ G, nodeID,outDegree,inDegree] = dirGraph( cm,labels,treshold )
%dirGraph Plot directed graph from connectivity matrix
%   Input connectivity matrix cm, with sources in the rows  
%   and targets in the columns. 
    if isempty(treshold)
        treshold =0;
    end
    labels{15}='15'; % Switch out 'ref' with '15' to be able to sort
    labels = sort(labels);

    % Find sources and targets in connectivity matrix
    s = [];
    t = [];
    weights =[];
    for i=1:60
        for j=1:60
            if cm(i,j)>treshold
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
    
%     unconnectedNodes = {};
%     for label = 1:60
%         if ~sum(ismember(s,label)) && ~sum(ismember(t,label))
%             unconnectedNodes{end +1} = labels{label};
%             %x(index) = []
%             %y(index)=[]
%         end
%     end
%     

    G = digraph(s,t,[],labels);

    %G = rmnode(G,unconnectedNodes);
    G.Nodes.NodeColors = indegree(G);
    G.Nodes.NodeSizes = 20*(outdegree(G)+indegree(G)+1)/(max(outdegree(G)+indegree(G)+1));
    G.Edges.Weight = weights;
    G.Edges.LWidths = 1*G.Edges.Weight/max(G.Edges.Weight);
    
    
    figure;
    p = plot(G,'XData',x,'YData',y,'EdgeAlpha',0.5,'ArrowSize',10);
    p.LineWidth = G.Edges.LWidths;
    p.NodeCData = G.Nodes.NodeColors;
    p.MarkerSize = G.Nodes.NodeSizes;
    colorbar
    set(gca,'Ydir','reverse')
    
    inDegree = indegree(G);
    outDegree = outdegree(G);

end


