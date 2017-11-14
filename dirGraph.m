function[ G,p] = dirGraph( cm,n )
%dirGraph Plot directed graph from connectivity matrix
%   dirGraph(cm,n) input connectivity matrix cm, 
%   with sources in the rows and targets in the columns.
%   The threshold is defined as the mean of the conneticity matrix pluss
%   n times the standard deviation.
    
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
    sw = zeros(60,1);
    for i=1:60
        for j=1:60
            if cm(i,j)>(m+n*sd)
                s = [s i];
                t = [t j];
                weights = [weights ; cm(i,j)];
                sw(i)= sw(i)+cm(i,j);
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
    %G = digraph(s,t,[]);
    %G = rmnode(G,unconnectedNodes);
    
    G.Edges.EdgeColor = weights;
    G.Nodes.NodeColor =indegree(G);
    G.Nodes.NodeSizes = 20*(outdegree(G)+indegree(G)+1)/(max(outdegree(G)+indegree(G)+1));
   
    G.Edges.Weight = weights;
    %width = (G.Edges.Weight - min(G.Edges.Weight)) * (1 -0) / (max(G.Edges.Weight) - min(G.Edges.Weight)) + 0;
    G.Edges.LWidths = 2*G.Edges.Weight/max(G.Edges.Weight);
    %G.Edges.LWidths = width;
    
    opengl hardware
    figure('position', [100, 100, 900, 800])  % create new figure with specified size 
    %ax0 = axes;
    p = plot(G,'XData',x,'YData',y,'EdgeAlpha',0.8,'ArrowSize',15);
    % p = plot(G,'XData',x,'YData',y,'ArrowSize',10);
    %p = plot(G)
    %p.EdgeColor = G.Edges.EdgeColors;
    
    set(gca,'Ydir','reverse')
    %ax1 = axes;
    %
    %ax1 = gca;
    
    %colorbar;
    cmap = colormap('gray');
    p.NodeColor = [0.5725 0.5725 0.5725];
    %cmap = flipud(cmap);
    %colormap(cmap);
    colorbar('Direction','reverse')
    %oldcmap = colormap(ax1,'hot');
    %colormap( flipud(oldcmap) );
    
    
    %ax2 = axes;
    
    %colormap(gca,'hsv');
   % cb1 = colorbar('EastOutside');
    %xlabel(cb1,'Test');
    
    
    %ax1 = gca;
    
    %ax1p =get(ax1,'pos');
    
    %ax2 = axes;
    %set(ax2,'pos',ax1p);
    %%axis off;
    %linkaxes([ax1,ax2],'xy');
    %cb2 = colorbar('WestOutside','Color','blue');
   % set(ax1,'pos',get(ax2,'pos'));
    %axes(ax2)
   % hold on
   
    
    
    %colorbar;
    %colormap('hsv')
    
    p.EdgeCData = G.Edges.EdgeColor;
    p.LineWidth = G.Edges.LWidths;
    p.MarkerSize=G.Nodes.NodeSizes;
    
    %colorbar;
    %p.NodeCData=G.Nodes.NodeColor;
    
    % Link them together
    %linkaxes([ax1,ax2[])
    % Hide the top axes
    %ax2.Visible = 'off';
    %%ax2.XTick = [];
    %ax2.YTick = [];
    %colormap(ax1,'hot')
    %colormap(ax2,'hsv')
    % Then add colorbars and get everything lined up
    %set([ax1,ax2],'Position',[.17 .11 .685 .815]);
    %%cb1 = colorbar(ax1,'Position',[.05 .11 .0675 .815]);
    %cb2 = colorbar(ax2,'Position',[.88 .11 .0675 .815]);
    

    %inDegree = indegree(G);
    %outDegree = outdegree(G);
    %size(s)
    %size(t)
    %G.Nodes.NodeLabel = (1:60)';
    %G = digraph(s,t,weights);
    %H = plot(G,'EdgeLabel',G.Edges.weights);
    [~,maxOut] = max(outdegree(G)); 
    [~,maxIn] = max(indegree(G));
    %[mf,GF,cs,ct] = maxflow(G,maxOut,maxIn,'augmentpath')
    %highlight(p,GF,'EdgeColor',[0.9 0.3 0.1],'NodeColor',[0.9 0.3 0.1])
    %highlight(p,[1 60],'NodeColor','g')
    %highlight(p,cs,'NodeColor','red')
    %highlight(p,ct,'NodeColor','blue')
    %highlight(p,GF,'EdgeColor','r','LineWidth',2);
    %st = GF.Edges.EndNodes;
    %labeledge(p,st(:,1),st(:,2),GF.Edges.Weight);
end


