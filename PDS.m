%% PDS of .mat files

[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
%filename ='2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-500s).mat';
%pathname ='/Users/Helge-Andre/Dropbox/NTNU/Prosjektoppgave/matlab/Dataset/TTK19/';
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
   data = load([pathname filename]);
end

signal = data.data(15,:);

figure
subplot(2,1,1)
plot(signal)

%periodogram(signal,[],[],10000,'power');
[P1,f1] = periodogram(signal,[],[],10000,'power');
subplot(2,1,2)
plot(f1,P1,'k')
grid
ylabel('Power')
xlabel('Frequency')
title('Power Spectrum')
%xlim([0 40])

figure
segmentLength = round(numel(signal)/4); % Equivalent to setting segmentLength = [] in the next line
spectrogram(signal,segmentLength,[],[],10000,'yaxis')