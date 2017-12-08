function rasterplot( timeStampData )
%rasterplot Generate a rasterplot of time segments
%   Plot spike time stamps as a rasterplot
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel

    figure;
    plot(timeStampData,[]); 
    title('Rasterplot');
    ylim([0 length(timeStampData.TimeStamps)+1]);
end

