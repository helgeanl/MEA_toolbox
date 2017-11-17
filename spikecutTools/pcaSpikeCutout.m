function [ coeff,score,latent,tsquared,explained,mu ]=pcaSpikeCutout( spikeCuts,labels )
%pcaSpikeCutout PCA on Spike Cutouts
%   Detailed explanation goes here

    numChannels = length(spikeCuts);
    spikemat = cell2mat(spikeCuts);
    [coeff,score,latent,tsquared,explained,mu] = pca(spikemat);
    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Spike Cutouts - Explained variance');
    figure;
        hold on;
        scatter3(score(:,1),score(:,2),score(:,3),'filled')
        grid on
        for i=1:size(spikemat,1)
            text(double(score(i,1)),double(score(i,2)),double(score(i,3)),...
                 [num2str(i/10) 'ms']);
        end
        title('Spike Cutouts - Scores')
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        zlabel(['PC-2 (' num2str(explained(3)) '%)']);
        view(3);
    figure;
        indexStart = 1;
        indexEnd = 1;
        s = [];
        for i=1:numChannels
            numSpikes = size(spikeCuts{i},2);
            indexEnd = indexEnd + numSpikes ;
            num = numel(indexStart:indexEnd)-1;
            s = [s ones(1,num)*i];
            indexStart = indexStart + numSpikes;
        end

        scatter3(coeff(:,1),coeff(:,2),coeff(:,3),[],s,'filled')
        grid on;
        colorbar('XTickLabel',labels, ...
               'XTick', 1:length(labels))
        colormap(jet(numChannels))

        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        zlabel(['PC-3 (' num2str(explained(3)) '%)']);
        title('Spike Cutouts - Loadings');
        box on;
        view(3);

end

function cluster(coeff)
    
end
