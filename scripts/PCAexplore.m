%% PCA explore

[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
   return
else
   data = load([pathname filename]);
   data = data.data';
end

%%
labels = getLabels();
%data = bandpassFilter(2,8, 13,data );
%data = highpassFilter(2,5000*0.95,data);

%% Cut down time series
newData = data;
data = newData(1000000:(2000000-1),:);


%% plot signal
time = (0:(size(data,1)-1))./10000;
figure
subplot(3,1,1)
plot(time,data(:,38)./1e6)
title('Electrode 63')
ylabel('Voltage [\muV]')
subplot(3,1,2)
plot(time,data(:,43)./1e6)
title('Electrode 64 (defect)')
ylabel('Voltage [\muV]')
subplot(3,1,3)
plot(time,data(:,44)./1e6)
title('Electrode 74 (Stimuli)')
xlabel('Time [s]');
ylabel('Voltage [\muV]')

%% Plot power spectrum
figure;
subplot(3,1,1)
    [P,f] = periodogram(data(:,38),[],[],10000,'power');
    plot(f,P,'k')
    xlim([0 40])
    grid
    ylabel('Power')
    %xlabel('Frequency [Hz]')
    title('Power Spectrum electrode 63')
subplot(3,1,2)
    [P,f] = periodogram(data(:,53),[],[],10000,'power');
    plot(f,P,'k')
    xlim([0 40])
    grid
    ylabel('Power')
    %xlabel('Frequency [Hz]')
    title('Power Spectrum electrode 66')
subplot(3,1,3)
    [P,f] = periodogram(data(:,60),[],[],10000,'power');
    plot(f,P,'k')
    xlim([0 40])
    grid
    ylabel('Power')
    xlabel('Frequency [Hz]')
    title('Power Spectrum electrode 51')


%% Remove outliers
%data(:,15)=[];
%data(:,43)=[];
%labels(15)=[];
%labels(43)=[];

%% Standardize the data
nData = zscore(data);

%% Run PCA
[coeff,score,latent,tsquared,explained,mu]=pcaTimeSeries(data,labels,[15 74 64],3);


%% Run PLSR
%51, 32
outlierIndexes = getLabelIndex([15 74 64 66],labels);
newData = data(1:1000000,38);
%newData(:,outlierIndexes)=[];
newLabels = labels;
newLabels(outlierIndexes)=[];
timeshift = 0;
y = data(1:1000000,53); 
y = y((timeshift+1):end);
X =newData; % 13
%X(:,51)=[];
X = X(1:(end-timeshift),:);
[n,p] = size(X);

%%
[Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(...
	X,y,10);

%%
figure;
plot(1:10,cumsum(100*PLSPctVar(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in Y');

%% Run again with 3 components
[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X,y,1);
yfitPLS = [ones(n,1) X]*betaPLS;

%% PCA Regress
[PCALoadings,PCAScores,PCAVar] = pca(X,'Economy',false);
betaPCR = regress(y-mean(y), PCAScores(:,1:1));
betaPCR = PCALoadings(:,1:1)*betaPCR;
betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
yfitPCR = [ones(n,1) X]*betaPCR;

%% Plot fitted vs. observed response for the PLSR 
plot(y,yfitPLS,'bo');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 2 Components' },  ...
	'location','NW');

%% Plot fitted vs. observed response for the PCR fits.
plot(y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PCR with 2 Components'},  ...
	'location','NW');

%% Plot fitted vs. observed response for the PLSR and PCR fits.
figure;
plot(y,yfitPLS,'bo',y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 3 Components' 'PCR with 3 Components'},  ...
	'location','NW');

%% Plot
figure
plot(data(:,51))
hold on
plot(data(:,37),'g')



%% Cross validation
[Xl,Yl,Xs,Ys,beta,pctVar,PLSmsep] = plsregress(X,y,10,'CV',10);
PCRmsep = sum(crossval(@pcrsse,X,y,'KFold',10),1) / size(X,1);
figure;
plot(0:10,PLSmsep(2,:),'b-o',0:10,PCRmsep,'r-^');
xlabel('Number of components');
ylabel('Estimated Mean Squared Prediction Error');
legend({'PLSR' 'PCR'},'location','NE');

%%
figure;
subplot(4,1,1)

plot(time,score(:,1).*1e-6)
title('Score 1')
xlim([0 600])

subplot(4,1,2)
plot(time,score(:,2).*1e-6)
xlim([0 600])
title('Score 2')

subplot(4,1,3)
plot(time,score(:,3).*1e-6)
title('Score 3')
xlim([0 600])
%%
subplot(4,1,4)
plot(time,score(:,4).*1e-6)
xlabel('Time [s]')
xlim([0 600])
title('Score 4')

%%
figure(14)
%subplot(4,1,4)
stim = 30:30:time(end);
for t=1:length(stim)
    plot([stim(t) stim(t)],[-20 20],'Color','k','LineWidth',1)
end