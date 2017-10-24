function [  ] = heatmapSpikes( timeStampData )
%heatmapSpikes Generate heatmap of spike count
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel

    label = 11;
    heat = zeros(8,8);
    for j = 1:8
        for i = 1:8
            if ~((i==1 || i==8)&& (j==1 || j==8))
                if label == 15 % Channel 15 is called 'Ref' in the data
                    index =find(contains(timeStampData.Info.Label,'Ref','IgnoreCase',true));
                else
                    index =find(contains(timeStampData.Info.Label,num2str(label),'IgnoreCase',true));
                end
                heat(i,j) = numel(timeStampData.TimeStamps{1,index});
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
    title('Number of spikes per electrode')

end

