function heatmapSpikes( timeStamps,duration )
%heatmapSpikes  Heatmap of mean firing rate per channel
%   heatmapSpikes(timeStamps,duration) takes in a cell array with 60 elements 
%   containing the spike data for each channel, the duration [seconds] of 
%   the selected recordring, and generates a heatmap of the mean firing rate
%   for each channel.

    label = 11;
    heat = zeros(8,8);
    for j = 1:8
        for i = 1:8
            if ~((i==1 || i==8)&& (j==1 || j==8))
                if label == 15 % Channel 15 is called 'Ref' in the data
                    index =find(contains(getLabels(),'Ref','IgnoreCase',true));
                else
                    index =find(contains(getLabels(),num2str(label),'IgnoreCase',true));
                end
                heat(i,j) = numel(timeStamps{index})/duration;
            end
            if mod(label,10) < 8
                label = label +1;
            else
            label = label +3;
            end
        end
    end
    figure;
    heatmap(heat);
    title('Mean firing rate [spike/s]')

end

