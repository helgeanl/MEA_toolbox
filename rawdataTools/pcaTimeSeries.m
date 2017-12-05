function [ coeff,score,latent,tsquared,explained,mu ] = pcaTimeSeries( analogData ,labels,outliers,numComponents)
%pcaTimeSeries PCA on timeseries
%   [ coeff,score,latent,tsquared,explained,mu ] = 
%               pcaTimeSeries( analogData ,labels,outliers,numComponents)
    outlierIndexes = getLabelIndex(outliers,labels);
    analogData(:,outlierIndexes)=[];
    labels(outlierIndexes)=[];
    [coeff,score,latent,tsquared,explained,mu] = pca(analogData,'Centered',true,'NumComponents',numComponents);
    
    if size(score,2) >=3
        figure;
            scatter3(score(:,1),score(:,2),score(:,3),'filled');
            title('Raw data - Scores')
            xlabel(['PC-1 (' num2str(explained(1)) '%)']);
            ylabel(['PC-2 (' num2str(explained(2)) '%)']);
            zlabel(['PC-3 (' num2str(explained(3)) '%)']);
            view(3);
    end
    M = size(score,2);
    N = size(score,1);
    time = linspace(0,(N-1)./1e4,N);
    for i = 0:5:M-1
       figure
       for j = 1:min(5,M-i) 
           subplot(5,1,j) 
           plot(time,score(:,i+j).*1e-6); 
           set(gca,'FontSize',8,'XLim',[0 time(end)]);
           title(['Score nr. ' num2str(i+j) ' (' num2str(explained(i+j)) '%)'])
       end
       xlabel('Time [s]');
    end

    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        set(gca, 'XTick', 1:10)
        title('Raw data - Explained variance');
        
    if size(coeff,2) >=3   
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
    end
    if size(coeff,2) >= 6
        figure;
        hold on;
        scatter3(coeff(:,4),coeff(:,5),coeff(:,6),'filled')
        grid on;
        x = double(coeff(:,4));
        y = double(coeff(:,5));
        z = double(coeff(:,6));
        text(x,y,z, labels, 'horizontal','left', 'vertical','bottom');
        xlabel(['PC-4 (' num2str(explained(4)) '%)']);
        ylabel(['PC-5 (' num2str(explained(5)) '%)']);
        zlabel(['PC-6 (' num2str(explained(6)) '%)']);
        title('Raw data - Loadings');
        box on;
        view(3);
    end
    figure
        stem(1:length(labels),mu./1e6)
        set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
        xtickangle(90);
        title('Estimated mean of each channel');
    figure;
        plot((0:(length(tsquared)-1))./10000,tsquared)
        xlabel('Time [s]')
        title('Hotelling''s T-squared statistic');
        
end

