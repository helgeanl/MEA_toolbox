%% PDS of .mat files
clear;
[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
%filename ='2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-500s).mat';
%pathname ='/Users/Helge-Andre/Dropbox/NTNU/Prosjektoppgave/matlab/Dataset/TTK19/';
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
   dataFile = load([pathname filename]);
   dataFile =dataFile.data';
   
end
fs = 10000;

%%
stimuliTime = 20; % 20, 80
timeBefore = 0.1;
timeAfter = 0.5;
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
signal63 = data(:,38); %63=38
signal66 = data(:,53); % 66=53
signal74 = data(:,44); % 74=44

signal63(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal63((timeBefore*Fs-5):(timeBefore*Fs+5)));
signal66(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal66((timeBefore*Fs-5):(timeBefore*Fs+5)));
signal74(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal74((timeBefore*Fs-5):(timeBefore*Fs+5)));
%% 
sig63 = lowpassFilter(4, 200,fs,signal63 );
sig66 = lowpassFilter(4, 200,fs,signal66 );
sig74 = lowpassFilter(4, 200,fs,signal74 );

%sig63 = highpassFilter(4, 200,fs,signal63;
%sig66 = highpassFilter(4, 200,fs,signal66 );
%sig74 = highpassFilter(4, 200,fs,signal74 );
%sig63 = lowpassData(:,38)'; %63
%sig66 = lowpassData(:,53)';
%sig74 = lowpassData(:,44)';

%%
%signal = signal -ref;
figure
subplot(3,3,1)
plot(time,sig74./1000000)
xlim([0 time(end)]);
y1=get(gca,'ylim');
hold on
plot([timeBefore timeBefore],y1,'r--')
ylabel('Voltage [\muV]')
xlabel('Time [s]')

title('74')
subplot(3,3,2)
plot(time,sig63./1000000)
xlim([0 time(end)]);
y1=get(gca,'ylim');
hold on
plot([timeBefore timeBefore],y1,'r--')
xlabel('Time [s]')
title('63')

subplot(3,3,3)
plot(time,sig66./1000000)
xlim([0 time(end)]);
y1=get(gca,'ylim');
hold on
plot([timeBefore timeBefore],y1,'r--')
xlabel('Time [s]')
title('66')

%periodogram(signal,[],[],10000,'power');
%[Pref,fref] = periodogram(ref,[],[],10000,'power');
[P63,f63] = periodogram(sig63,[],[],10000,'power');
[P66,f66] = periodogram(sig66,[],[],10000,'power');
[P74,f74] = periodogram(sig74,[],[],10000,'power');
subplot(3,3,4)
plot(f74,P74,'k')
xlim([0 40])
grid
ylabel('Power')
xlabel('Frequency [Hz]')
title('Power Spectrum')

subplot(3,3,5)
plot(f63,P63,'k')
xlim([0 40])
xlabel('Frequency [Hz]')

subplot(3,3,6)
plot(f66,P66,'k')
xlabel('Frequency [Hz]')
xlim([0 40])

segmentLength = round(numel(sig74)/128); % Equivalent to setting segmentLength = [] in the next line
subplot(3,3,7)
spectrogram(sig74,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);
subplot(3,3,8)
spectrogram(sig63,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);
subplot(3,3,9)
spectrogram(sig66,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);

%% Hilbert
[imf74,d74]=plot_hht(sig74,1/10000,1);
[imf63,d63]=plot_hht(sig63,1/10000,1);
[imf66,d66]=plot_hht(sig66,1/10000,1);
%%
z = 0;
for k = 1:length(imf74)
   z = z+hilbert(imf74{k});
   a74(:,k)=abs(hilbert(imf74{1,k}))';
end

z = 0;
for k = 1:length(imf63)
   z = z+hilbert(imf63{k});
   a63(:,k)=abs(hilbert(imf63{1,k}))';
end
z = 0;
for k = 1:length(imf66)
   z = z+hilbert(imf66{k});
   a66(:,k)=abs(hilbert(imf66{1,k}))';
end
%%
H74 = sum(a74,2);
H63 = sum(a63,2);
H66 = sum(a66,2);
figure;plot(H74)
figure;plot(H63)
figure;plot(H66)

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
H =zeros(1001,length(a63));
for j=1:length(imf63)
    wj = d63{j};
    ampl = a63(:,j);
    Hj =zeros(1001,length(a63));
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
