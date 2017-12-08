function spikecountConnectivity( timeStamps,labels, delta,duration,threshold)
%spikecountConnectivity Heatmap and connectivity map from spike count
%   spikecountConnectivity( timeStamps,labels, delta,duration,threshold)


    if isempty(delta)
        delta = 0;
    end
    tic
    spikecount = zeros(length(labels),length(labels));
    for chan1Index = 1:numel(timeStamps)
        for spikeTime = timeStamps{chan1Index}
            for chan2Index = 1:numel(timeStamps)
                if chan1Index ~= chan2Index
                    if delta == 0
                        if sum(timeStamps{chan2Index} == spikeTime )
                            spikecount(chan1Index,chan2Index) = spikecount(chan1Index,chan2Index) +1;
                        end
                    else
                         if sum(timeStamps{chan2Index} > spikeTime & ...
                                 timeStamps{chan2Index} <= (spikeTime +delta ))
                            spikecount(chan1Index,chan2Index) = spikecount(chan1Index,chan2Index) +1;
                        end
                    end
                end
            end
        end
    end
    spikecount = spikecount./duration;
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s ]= sort(labels);
    spikecount = spikecount(s,s);
    cfg = [];
    cfg.title = ['Spikes firing within a delta = ' num2str(delta) ' ' char(956) 's'];
    dirgraph(spikecount,labels,threshold,cfg);
    
    figure;
    imagesc(spikecount);
    colorbar;
    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
    set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
    grid on;
    xtickangle(90);
    title(['Spikes firing within a delta = ' num2str(delta) ' ' char(956) 's'])
    xlabel('Electrodes')
    ylabel('Electrodes')
    toc
end

