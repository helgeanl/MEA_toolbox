function varargout = pcaTimeSeries( data,labels,outliers,numComp,fs)
%pcaTimeSeries PCA on timeseries
%   pcaTimeSeries(DATA,LABELS,OUTLIERS,NUMCOMP,FS)
%   Plot loadings with the principal components on the x,y, and z axis. 
%   E.g. PC 1,2, and 3 in one figure, and PC 4,5, and 6 in another figure. 

%   [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pcaTimeSeries(DATA,LABELS,OUTLIERS,NUMCOMP,FS)
%   returns the principal component coefficients(loadings), scores, latent
%   variables (PC variance/ eigenvalues of the covariance matrix), Hotelling's T-squared
%   statistic for each sample with in the full space (not only for the PCs 
%   that is specified by numComp), explained variance as a vector with the
%   percentages of total explained variance, and estimated mean from centering
%   the signal.
%   
    
    % Calculate PCA
    outlierIndexes = getLabelIndex(outliers,labels);
    data(:,outlierIndexes)=[];
    labels(outlierIndexes)=[];
    numComp = min(numComp,size(data,2));
    [coeff,score,latent,tsquared,explained,mu] = pca(data,'Centered',true,'NumComponents',numComp);
    
    % Plot 3 and 3 scores against each other
    for i=1:3:numComp
        if i+2 <= numComp
            figure;
            scatter3(score(:,i),score(:,i+1),score(:,i+2),'filled');
            title('Raw data - Scores')
            xlabel(['PC-' num2str(i) ' (' num2str(explained(i)) '%)']);
            ylabel(['PC-' num2str(i+1) ' (' num2str(explained(i+1)) '%)']);
            zlabel(['PC-' num2str(i+2) ' (' num2str(explained(i+2)) '%)']);
            view(3);
        end
    end
    
    % Plot scores individually as line plots
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
    
    % Calculate and plot the periodogram of the scores
    for i = 0:5:M-1
       figure
       for j = 1:min(5,M-i) 
           subplot(5,1,j) 
           [P,f] = periodogram(score(:,i+j),[],[],fs,'power');
           plot(f,P,'k') 
           grid
           title(['Power Spectrum - score ' num2str(i+j)])
           set(gca,'FontSize',8,'XLim',[0 3000]);
       end
       xlabel('Frequency [Hz]')
    end
    
    % Plot the explained variance of each PC
    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 max(10,numComp)]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        set(gca, 'XTick', 1:max(10,numComp))
        title('Raw data - Explained variance');
    
    % Plot 3 and 3 loadings against each other
    for i=1:3:numComp
        if i+2 <= numComp
            figure;
            hold on;
            scatter3(coeff(:,i),coeff(:,i+1),coeff(:,i+2),'filled')
            grid on;
            x = double(coeff(:,i));
            y = double(coeff(:,i+1));
            z = double(coeff(:,i+2));
            text(x,y,z, labels, 'horizontal','left', 'vertical','bottom');
            xlabel(['PC-' num2str(i) ' (' num2str(explained(i)) '%)']);
            ylabel(['PC-' num2str(i+1) ' (' num2str(explained(i+1)) '%)']);
            zlabel(['PC-' num2str(i+2) ' (' num2str(explained(i+2)) '%)']);
            title('Raw data - Loadings');
            box on;
            view(3);
        end
    end
    
    % Plot estimated mean of each channel
    figure
        stem(1:length(labels),mu./1e6)
        set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
        xtickangle(90);
        title('Estimated mean of each channel');
    
    % Plot the Hotellings influence plot   
    figure;
        plot((0:(length(tsquared)-1))./10000,tsquared)
        xlabel('Time [s]')
        title('Hotelling''s T-squared statistic');
    
    % Specify the output variables
    nout = max(nargout,1);
    tempOut{1} = coeff;
    tempOut{2} = score;
    tempOut{3} = latent;
    tempOut{4} = tsquared;
    tempOut{5} = explained;
    tempOut{6} = mu;
    
    for k = 1:nout
        varargout{k} = tempOut{k};
    end
end

