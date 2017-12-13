function plotMFR( timeStamps,labels,duration )
%plotMFR  Plot of the mean firing rate per channel
%   plotMFR( timeStamps,labels,duration ) takes in a cell array with 60 elements 
%   containing the spike data for each channel, the duration [seconds] of 
%   the selected recordring, and generates a heatmap of the mean firing rate
%   for each channel.
    
    label = 11;
    heat = zeros(8,8);
    for j = 1:8
        for i = 1:8
            if ~((i==1 || i==8)&& (j==1 || j==8))
                if label == 15 % Channel 15 is called 'Ref' in the data
                    index =find(contains(labels,'Ref','IgnoreCase',true));
                else
                    index =find(contains(labels,num2str(label),'IgnoreCase',true));
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


    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s] = sort(labels);
    timeStamps = timeStamps(s);
    
    for i=1:length(labels)
        mfr(i) = numel(timeStamps{i})/duration;
    end

    cfg = [];
    cfg.title = 'Mean firing rate';
    cfg.cbLabel = '[spike/s]';
    plot_layout(mfr,labels,cfg);
end

