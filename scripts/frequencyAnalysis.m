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
eventTime = 20; % 20, 80
timeBefore = 0;
timeAfter = 10;
Fs = 10000;

startTime = (eventTime-timeBefore) *Fs;
endTime = startTime + (timeAfter+timeBefore)*Fs;
data = dataFile(startTime:endTime,:);
time = (0:(size(data,1)-1))./Fs;

%ref = data.data(15,:);
%%
%data = lowpassData(:,44)';
%lowpassData = lowpassFilter(4, 100,data );


%% 
signal31 = data(:,26); %63=38

%% Remove noise from stimuli by setting it equal to the mean during the stimuli period
%signal31(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal31((timeBefore*Fs-5):(timeBefore*Fs+5)));

%% 
sig31 = lowpassFilter(4, 200,fs,signal31 );

%% Downsample
sig31 = sig31(1:20:end);
Fs = 500;
fs = Fs;
time = (0:(size(sig31)-1))./500;
%sig31 = signal31;

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
[P31,f31] = periodogram(sig31,[],[],fs,'power');

subplot(3,1,2)
plot(f31,P31,'k')
%xlim([0 40])
grid
ylabel('Power')
xlabel('Frequency [Hz]')
title('Power Spectrum')


segmentLength = round(numel(sig31)/128); % Equivalent to setting segmentLength = [] in the next line
subplot(3,1,3)
spectrogram(sig31,segmentLength,[],[],fs,'yaxis')
%ylim([0 1]);


%% Hilbert
[imf31,f31]=plot_hht(sig31,1/fs);



%%
z = 0;
for k = 1:length(imf31)
   z = z+hilbert(imf31{k});
   a31(:,k)=abs(hilbert(imf31{1,k}))';
end

%% Plot inst freq
% Set time-frequency plots.
for k = 1:size(modes,1)
   %b(k) = sum(imf{k}.*imf{k});
   th   = unwrap(angle(hilbert(modes(k,:))));
   d{k} = diff(th)/(2*pi)*fs;
end

%%
N = length(sig31);
c = linspace(0,(N-2)/fs,N-1);
figure;
hold on
for i=1:length(f31)
    plot(c,f31{i})
end

%% Calculate Hilbert Spectrum
H =zeros(10001,length(a31));
for j=1:length(imf31)
    wj = f31{j};
    ampl = a31(:,j);
    Hj =zeros(10001,length(a31));
    for w=0:0.01:100
        index = round(w*100+1);
        if ismember(w,round(wj,2))
            Hj(index,:) = ampl;
        else
            Hj(index,:) = zeros(length(ampl),1);
        end
    end
    H=H+Hj;
end


%% Plot Hilbert Spectrum
figure;contour(time,0:0.01:100,H);
colorbar
%colormap summer
xlabel('Time [s]')
ylabel('Frequency [Hz]')


%% Marginal Hilbert Spectrum
mhs = sum(H,2);
figure;plot(0:0.01:100,mhs,'r-')

%%
figure
for i=1:size(modes,1)
    subplot(size(modes,1),1,i)
    plot(time,modes(i,:))
end

%%
figure
for i=1:length(imf31)
    subplot(length(imf31),1,i)
    plot(time,imf31{i})
end


