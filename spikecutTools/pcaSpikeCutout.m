function [ coeff,score,latent,tsquared,explained,mu ]=pcaSpikeCutout( spikecuts,labels,outliers,numComponents )
%pcaSpikeCutout PCA on Spike Cutouts
%   Detailed explanation goes here
    
    % Remove outliers
    outlierIndexes = getLabelIndex(outliers,labels);
    spikecuts(outlierIndexes)=[];
    labels(outlierIndexes)=[];
    
    numChannels = length(spikecuts);
    spikemat = cell2mat(spikecuts);
    [coeff,score,latent,tsquared,explained,mu] = pca(spikemat,'Centered',true,'NumComponents',numComponents);
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
        % Use interpolation if curvefitting toolbox is installed
        % if not use plot3 as default
        if ~isempty(which('cscvn'))
            fnplt(cscvn(score(:,1:3)'),'r',2)
        else
            plot3(score(:,1),score(:,2),score(:,3))
        end
        grid on
        for i=1:size(spikemat,1)
            text(double(score(i,1)),double(score(i,2)),double(score(i,3)),...
                 [num2str(i/10) 'ms']);
        end
        title('Spike Cutouts - Scores')
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        zlabel(['PC-3 (' num2str(explained(3)) '%)']);
        view(3);
        
    M = size(score,2);
    N = size(score,1);
    time = linspace(0,(N-1)./1e4,N);
    for i = 0:3:M-1
       figure
       for j = 1:min(3,M-i) 
           subplot(3,1,j) 
           plot(time,score(:,i+j).*1e-6); 
           set(gca,'FontSize',8,'XLim',[0 time(end)]);
           title(['Score nr. ' num2str(i+j) ' (' num2str(explained(i+j)) '%)'])
       end
       xlabel('Time [s]');
    end
    
    figure;
        indexStart = 1;
        indexEnd = 1;
        s = [];
        for i=1:numChannels
            numSpikes = size(spikecuts{i},2);
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
    figure
        scatter(mu./1e6,s,'filled')
        set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
        title('Estimated mean of each spike cutout');
end

