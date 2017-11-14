function crossCor( data )
%crossCor Cross correlation map from analog data
%   crossCor(data) takes in a NxM matrix with a timeseries of size N 
%   and M channels. This is used to calculate and plot the crosscorrelation
%   between each channel.
%   
    cc = zeros(60,60);
    xcor = dsp.Crosscorrelator;
    nChannels = size(data(:,2));
    for chan1Index = 1:nChannels
        for chan2Index = 1:nChannels
            if chan1Index ~= chan2Index
                cc(chan1Index,chan2Index) = mean(xcor(data(:,chan1Index),data(:,chan2Index)));
            end
        end
    end
    figure;
    heatmap(cc);
    title('Cross correlation')
    ylabel('Electrodes')
    %set(gca,'YTickLabel',strtrim(analogData.Info.Label));
    xlabel('Electrodes')
    %set(gca,'XTickLabel',strtrim(analogData.Info.Label));
end

