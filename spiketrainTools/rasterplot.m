function rasterplot( timeStampData )
%rasterplot Generate a rasterplot of time segments
%   Plot spike time stamps as a rasterplot
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel

    timeStamps = timeStampData.TimeStamps;
    labels = timeStampData.Info.Label;
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [timeStampData.Info.Label, s] = sort(labels);
    timeStampData.TimeStamps = timeStamps(s);
 
    figure;
    plot(timeStampData,[]); 
    title('Rasterplot');
    ylim([0 length(timeStampData.TimeStamps)+1]);
end

