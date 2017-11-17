function barGraph(timeStamps)
%barGraph Generate bar graph of spike count
%   barGraph(timeStamps) takes in a cell array with 60 elements 
%   containing the spike data for each channel, and generates a 
%   heatmap with the number of spikes per channel.

    nChannels = length(timeStamps);
    bargraph = zeros(nChannels,1);
    for index=1:nChannels
       bargraph(index) = numel(timeStamps{index}); 
    end
    figure;
    bar(bargraph);
    xlim([1 nChannels])
    title('Number of spikes per electrode')
end

