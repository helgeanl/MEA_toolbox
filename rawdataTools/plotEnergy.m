function energy = plot_energy(data,labels,fs)
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
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s] = sort(labels);
    
    data = data(:,s);
    for i=1:length(labels)
        energy(i) = sum(periodogram(data(:,i),[],[],fs,'power'));
    end
    cfg = [];
    cfg.title = 'Energy';
    plot_layout(energy,labels,cfg);
    
   
end


