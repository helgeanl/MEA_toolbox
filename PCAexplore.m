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
[label,labels] = getLabel(43);
%data = bandpassFilter(2,8, 13,data );
%data = highpassFilter(2,5000*0.95,data);

%% Cut down time series
newData = data;
data = newData(1000000:1100000,:);

%% Remove outliers
data(:,15)=[];
data(:,43)=[];
labels(15)=[];
labels(43)=[];

%% Standardize the data
nData = zscore(data);

%% Run PCA
[coeff,score,latent,tsquared,explawined,mu]=pcaTimeSeries(data,labels);


%% Run PLSR
timeshift = 0;
y = data(:,38); %63
y = y((timeshift+1):end);
X =data(:,19); % 13
%X(:,51)=[];
X = X(1:(end-timeshift),:);
[n,p] = size(X);

%%
[Xloadings,Yloadings,Xscores,Yscores,betaPLS10,PLSPctVar] = plsregress(...
	X,y,1);

%%
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
plot(y,yfitPLS,'bo',y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR with 2 Components' 'PCR with 2 Components'},  ...
	'location','NW');

%% Plot
figure
plot(data(:,51))
hold on
plot(data(:,37),'g')