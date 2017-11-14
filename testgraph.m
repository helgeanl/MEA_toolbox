s = [1 1 1 1 1];
t = [2 3 4 5 6];
weights = [5 5 5 6 9];
G = digraph(s,t,weights,10);

figure
p = plot(G,'EdgeAlpha',0.8,'ArrowSize',15);

    % p = plot(G,'XData',x,'YData',y,'ArrowSize',10);
    %p = plot(G)
    %p.EdgeColor = G.Edges.EdgeColors;
    
    set(gca,'Ydir','reverse')
    %ax1 = gca;
    c = colorbar('Direction','reverse');
    c.Label.String = 'Elevation (ft in 1000s)';
    colormap('gray');
    %cmap = flipud(cmap);

    p.EdgeCData = weights
    %p.LineWidth = G.Edges.LWidths;

   
    p.MarkerSize=20*(outdegree(G)+indegree(G)+1)/(max(outdegree(G)+indegree(G)+1));

    p.NodeColor = [0.5725 0.5725 0.5725];


    %colormap([gray;cool])
    %colorbar
