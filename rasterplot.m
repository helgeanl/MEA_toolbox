function [  ] = rasterplot( timeStampData )
%rasterplot Generate a rasterplot of time segment
%   Plot spike time stamps as a rasterplot
% Takes in a time stamp data object (McsTimeStampStream) 
% and generates a heatmap with number of spikes per channel

    figure(36);clf(36);
    plot(timeStampData,[]); 
    title('Rasterplot');
    ylim([1 60]);
end

