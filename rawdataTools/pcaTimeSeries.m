function [ coeff,score,latent,tsquared,explained,mu ] = pcaTimeSeries( analogData ,labels,outliers)
%pcaTimeSeries PCA on timeseries
    outlierIndexes = getLabelIndex(outliers,labels);
    analogData(:,outlierIndexes)=[];
    labels(outlierIndexes)=[];
    %labels = sort(labels);
    [coeff,score,latent,tsquared,explained,mu] = pca(analogData,'Centered',true);
    
    figure;
        scatter(score(:,1),score(:,2),'filled');
        title('Raw data - Scores')
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);

    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Raw data - Explained variance');
    figure;
        hold on;
        scatter3(coeff(:,1),coeff(:,2),coeff(:,3),'filled')
        grid on;
        x = double(coeff(:,1));
        y = double(coeff(:,2));
        z = double(coeff(:,3));
        text(x,y,z, labels, 'horizontal','left', 'vertical','bottom');
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        zlabel(['PC-3 (' num2str(explained(3)) '%)']);
        title('Raw data - Loadings');
        box on;
        view(3);
        
    figure
        stem(1:length(labels),mu./1e6)
        ylabel('Voltage [\muV]')
        set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
        xtickangle(90);
        title('Estimated mean of each channel');
    figure;
        plot(tsquared)
        title('Hotelling''s T-squared statistic');
        
    figure;
        [idx,C,sumd,D] = kmeans(analogData',4);
        imagesc(D)
        colorbar
        set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
        %set(gca, 'XTick', 1:size(D,2))
        %grid on;
        title('k-means distance to every centroid')
        
    figure;
        bar(1:length(labels),idx)
        set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
        xtickangle(90);
        title('k-means clustering')
end

