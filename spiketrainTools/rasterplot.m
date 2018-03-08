function rasterplot( timeStampData )
%rasterplot Generate a rasterplot of time segments
%   Plot spike time stamps as a rasterplot
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel
%
%   The code to map the timestamps to rasterplot is copied from 
%   the McsTimeStampStream plot function in the McsMatlabDataTools package.
%   (It is possible to use plot(timeStampData, []) to get the same result,
%    but due to trouble with inconsistent channel order we use this hack.)

    timeStamps = timeStampData.TimeStamps;
    labels = timeStampData.Info.Label;
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [timeStampData.Info.Label, s] = sort(labels);
    timeStamps = timeStamps(s);
 
    figure;
    % --- Code from McsTimeStampStream plot start ---
    lineLength = 0.3;
    M = cell(length(timeStamps),2);
    emptyTimeStamps = false(1,length(timeStamps));
    for timei = 1:length(timeStamps)
        if isempty(timeStamps{timei})
            emptyTimeStamps(timei) = true;
            continue
        end
        M{timei,1} = McsHDF5.TickToSec([timeStamps{timei} ; timeStamps{timei}]);
        M{timei,2} = repmat([timei-lineLength ; timei+lineLength],1,size(M{timei,1},2));
    end
    if all(emptyTimeStamps)
        return
    end
    for timei = 1:length(timeStamps)
        if emptyTimeStamps(timei)
            continue
        end
        line(M{timei,1},M{timei,2},'Color','k')
    end
    set(gca,'YTick',1:length(timeStamps));
    set(gca,'YTickLabel',strtrim(labels));
    ylabel('Source Channel')
    % --- Code from McsTimeStampStream plot end ---
    
    xlabel('Time [s]')
    title('Rasterplot');
    ylim([0 length(labels)+1]);
end

