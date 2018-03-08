function barGraph(timeStamps,labels)
%barGraph Generate bar graph of spike count
%   barGraph(timeStamps) takes in a cell array with 60 elements 
%   containing the spike data for each channel, and generates a 
%   heatmap with the number of spikes per channel.

    nChannels = length(timeStamps);
    bargraph = zeros(nChannels,1);
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s ]= sort(labels);
    timeStamps = timeStamps(s);
    
    for index=1:nChannels
       bargraph(index) = numel(timeStamps{index}); 
    end
    
    figure;
    bar(bargraph);
    xlim([0 nChannels+1])
    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
    xtickangle(90);
    title('Number of spikes per electrode')
end

