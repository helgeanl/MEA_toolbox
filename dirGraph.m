function [ G] = dirGraph( cm,labels )
%dirGraph Plot directed graph from connectivity matrix
%   Input connectivity matrix cm, with sources in the rows  
%   and targets in the columns. 

    labels{15}='15'; % Switch out 'ref' with '15' to be able to sort
    labels = sort(labels);

    s = [];
    t = [];
    for i=1:60
        for j=1:60
            if cm(i,j)>0
                s = [s i];
                t = [t j];
            end
        end
    end
    unconnectedNodes = {};
    for label = 1:60
        if ~sum(ismember(s,label)) && ~sum(ismember(t,label))
            unconnectedNodes{end +1} = labels{label};
        end
    end
    G = digraph(s,t,[],labels);

    G = rmnode(G,unconnectedNodes);
    figure;
    plot(G,'Layout','force')
 
end

