function [ pattern ] = heatmapPattern( timeStamps,labels, delta )
%heatmapPattern Geneate heatmap of neurons firing within a delta
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel
    if isempty(delta)
        delta = 0;
    end
    %timeStamps = timeStampData.TimeStamps;
    pattern = zeros(length(labels),length(labels));
    for chan1Index = 1:numel(timeStamps)
        for spikeTime = timeStamps{chan1Index}
            for chan2Index = 1:numel(timeStamps)
                if chan1Index ~= chan2Index
                    if delta == 0
                        if sum(timeStamps{chan2Index} == spikeTime )
                            pattern(chan1Index,chan2Index) = pattern(chan1Index,chan2Index) +1;
                        end
                    else
                         if sum(timeStamps{chan2Index} > spikeTime & ...
                                 timeStamps{chan2Index} <= (spikeTime +delta ))
                            pattern(chan1Index,chan2Index) = pattern(chan1Index,chan2Index) +1;
                        end
                    end
                end
            end
        end
    end
    figure;
    imagesc(pattern);
    colorbar;
    %labels = timeStampData.Info.Label;

    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
    set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
    grid on;
    xtickangle(90);
    title(['Spikes firing within a delta = ' num2str(delta) ' ' char(956) 's']);

end

