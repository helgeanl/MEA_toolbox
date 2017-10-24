function [  ] = bargraph( timeStampData )
%bargraph Generate bar graph of spike count
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel
    bargraph = zeros(60,1);
    for index=1:60
       bargraph(index) = numel(timeStampData.TimeStamps{1,index}); 
    end
    figure;
    bar(bargraph);
    xlim([1 60])
    title('Number of spikes per electrode')
end

