%% PDS of .mat files
clear;
[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
%filename ='2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-500s).mat';
%pathname ='/Users/Helge-Andre/Dropbox/NTNU/Prosjektoppgave/matlab/Dataset/TTK19/';
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
   dataFile = load([pathname filename]);
   dataFile =dataFile.data;
   
end
fs = 10000;

%%
stimuliTime = 20; % 20, 80
timeBefore = 0.1;
timeAfter = 0.9;
Fs = 10000;

startTime = (stimuliTime-timeBefore) *Fs;
endTime = startTime + (timeAfter+timeBefore)*Fs;
data = dataFile(startTime:endTime,:);
time = (0:(size(data,1)-1))./Fs;

%ref = data.data(15,:);
%%
%data = lowpassData(:,44)';
%lowpassData = lowpassFilter(4, 100,data );


%% 
signal31 = data(:,26); %63=38

signal31(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal31((timeBefore*Fs-5):(timeBefore*Fs+5)));

%% 
%sig31 = lowpassFilter(4, 200,fs,signal31 );
sig31 = signal31;

%%
%signal = signal -ref;
figure
subplot(3,1,1)
plot(time,sig31./1000000)
xlim([0 time(end)]);
y1=get(gca,'ylim');
%hold on
%plot([timeBefore timeBefore],y1,'r--')
ylabel('Voltage [\muV]')
xlabel('Time [s]')

%periodogram(signal,[],[],10000,'power');
%[Pref,fref] = periodogram(ref,[],[],10000,'power');
[P31,f31] = periodogram(sig31,[],[],10000,'power');

subplot(3,1,2)
plot(f31,P31,'k')
%xlim([0 40])
grid
ylabel('Power')
xlabel('Frequency [Hz]')
title('Power Spectrum')


segmentLength = round(numel(sig31)/128); % Equivalent to setting segmentLength = [] in the next line
subplot(3,1,3)
spectrogram(sig31,segmentLength,[],[],10000,'yaxis')
%ylim([0 1]);


%% Hilbert
[imf31,d31]=plot_hht(sig31,1/10000,1);

%%
z = 0;
for k = 1:length(imf31)
   z = z+hilbert(imf31{k});
   a31(:,k)=abs(hilbert(imf31{1,k}))';
end

%%
H74 = sum(a31,2);
figure;plot(H31)


%%
% figure
% [P74,f74] = periodogram(sig74,[],[],10000,'power');
% [Px,fx] = periodogram(x,[],[],10000,'power');
% plot(f74,P74)
% hold on
% plot(fx,Px,'r--')
% 
% %%
% figure
% spectrogram(sig74,segmentLength,[],[],10000,'yaxis')
% figure
% spectrogram(x,segmentLength,[],[],10000,'yaxis')
% 
% %%
% freq = cell2mat(d63')';
% HS = a63;
% %indx = find(freq==freq(1));
% [A, F] = mhs(HS,freq,0,[],[]);

%% Calculate Hilbert Spectrum
H =zeros(1001,length(a31));
for j=1:length(imf31)
    wj = d31{j};
    ampl = a31(:,j);
    Hj =zeros(1001,length(a31));
    for w=0:0.1:100
        index = round(w*10+1);
        if ismember(w,round(wj,1))
            Hj(index,:) = ampl;
        else
            Hj(index,:) = zeros(length(ampl),1);
        end
    end
    H=H+Hj;
end

%% Plot Hilbert Spectrum
figure;contour(time,0:0.1:100,H);
colorbar
%colormap summer
xlabel('Time [s]')
ylabel('Frequency [Hz]')
