%% PDS of .mat files
%clear;
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
signal31 = data(:,26); %63=38, 26=31


%%
load stamps2
figure;
subplot(2,1,1)
plot(time,signal31./1e6)
signal31_high = highpassFilter(4,200,fs,signal31);
ylabel('Voltage [\muV]');
title('Raw signal');
%ax1 = gca;
%5ax1.XAxis.Visible = 'off';
subplot(2,1,2)
plot(time,signal31_high./1e6)
box on;
hold on
plot(time,-ones(length(time),1).*66.8,'LineWidth',2)
%subplot(3,1,3)
hold on
for t=1:length(stamps2)
    plot([stamps2(t) stamps2(t)],[-200 -150],'Color','k','LineWidth',1)
end
ylabel('Voltage [\muV]');
xlabel('Time [s]');
title('High pass filtered signal');
legend('signal','treshold','spikes');
%axis(gca,'off');
%ax1 = gca;
%ax1.YAxis.Visible = 'off';
save('stamps2','stamps2');
%% Remove noise from stimuli by setting it equal to the mean during the stimuli period
%signal31(timeBefore*Fs:((timeBefore)*Fs+40))=mean(signal31((timeBefore*Fs-5):(timeBefore*Fs+5)));

%%
sig31 = signal31;

%%
sig31 = bandpassFilter(4,300,0.95*fs/2,fs,signal31);
%%
sig31 = highpassFilter(4,200,fs,signal31);
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
hold on
for t=1:length(stamps2)
    plot([stamps2(t) stamps2(t)],[-100 -50],'Color','k','LineWidth',1)
end
%periodogram(signal,[],[],10000,'power');
%[Pref,fref] = periodogram(ref,[],[],10000,'power');
[P31,f31] = periodogram(sig31,[],[],fs,'power');

%segmentLength = 100000;
segmentLength = round(numel(sig31)/128); % Equivalent to setting segmentLength = [] in the next line
subplot(3,1,2)
spectrogram(sig31,segmentLength,[],[],fs,'yacxis')
hold on
for t=1:length(stamps2)
    plot([stamps2(t) stamps2(t)],[-150 -100],'Color','k','LineWidth',1)
end
%ylim([0 50]);

subplot(3,1,3)
plot(f31,P31,'k')
%xlim([0 50])
grid
ylabel('Power')
xlabel('Frequency [Hz]')
title('Power Spectrum')

%% Hilbert
[imf31,f31]=plot_hht(sig31,1/fs);

%% Normalize imfs
for imf=1:length(imf31)
    E = envelope(imf31{imf});
    imf31{imf} =  imf31{imf}./E;
end

%% Calculate inst freq
% Set time-frequency plots.
for imf = 1:length(imf31)
   %b(k) = sum(imf{k}.*imf{k});
   th{imf}   = unwrap(angle(hilbert(imf31{imf})));
   %th_filtered{imf} = lowpassFilter(4,1,500,th{imf}');
    th_filtered{imf} = smooth(th{imf} ,7);
    % th_filtered{imf} = th{imf};
   f31{imf} = diff(th_filtered{imf})/(2*pi)*fs;
end

%%
z = 0;
for k = 1:length(imf31)
   z = z+hilbert(imf31{k});
   %b(k) = sum(imf31{k}.*imf31{k});
   a31(:,k)=abs(hilbert(imf31{1,k}))';
end
%%
z = 0;
for k = 1:size(IMF2,1)
   z = z+hilbert(IMF2(k,:));
   %b(k) = sum(imf31{k}.*imf31{k});
   a(k,:)=abs(hilbert(IMF2(k,:)))';
end


%% Normalize imfs
for imf=1:size(modes,1)
    E = envelope(modes(imf,:));
    normalizedImfs{imf} =  modes(imf,:)./E;
end

%% Plot inst freq from eemd
% Set time-frequency plots.
for k = 1:size(modes,1)
   %b(k) = sum(imf{k}.*imf{k});
   th   = unwrap(angle(hilbert(modes(k,:))));
   th = smooth(th,7);
   d{k} = diff(th)/(2*pi)*fs;
end

%% Plot inst freq
N = length(sig31);
c = linspace(0,(N-2)/fs,N-1);
figure;
hold on
for i=2:length(f31)-10
    plot(c,f31{i})
end
title('Instantaneous frequency')
 xlabel('Time [s]')
 ylabel('Frequency [Hz]')
 
 
%% Calculate Hilbert Spectrum

dt = 1/fs;
dw = 0.1;
wStart = 0;
wEnd = 60;
w = wStart:dw:wEnd;
H =zeros(length(w),length(a31));
%%
for j=1:length(imf31)
    disp('Round')
    disp(j)
    wj = f31{j};
    ampl = a31(:,j);
    Hj =zeros(length(w),length(a31));
    for wi=w
        index = round((wi-wStart)/dw+1); %round(wi*20+1);
        if ismember(wi,round(wj,2)) %ismember(wi,round(wj,2))
            Hj(index,:) = ampl;%./(dt*dw);
            %Hj = [Hj;ampl./(dt*dw)];
        else
            %Hj = [zeros(length(ampl),1)]; %(index,:) = zeros(length(ampl),1);
            Hj(index,:) = zeros(length(ampl),1);
        end
    end
    H=H+Hj;
end

%%
%% Calculate Hilbert Spectrum

dt = 0.1; %1/fs;
time = 0:dt:10;
dw = 0.1;
wStart = 0;
wEnd = 60;
w = wStart:dw:wEnd;
H =zeros(length(w),length(time));
for j=1:length(imf31)
    disp('Round')
    disp(j)
    wj = f31{j};
    
    Hj =zeros(length(w),length(time));
    for t =1:length(time)
        ampl = a31(t,j);
        for wi=w
            index = round((wi-wStart)/dw+1); %round(wi*20+1);
            if ismember(wi,round(wj,1)) %ismember(wi,round(wj,2))
                Hj(index,t) = ampl;%./(dt*dw);
                %Hj = [Hj;ampl./(dt*dw)];
            else
                %Hj = [zeros(length(ampl),1)]; %(index,:) = zeros(length(ampl),1);
                Hj(index,t) = 0;
            end
        end
    end
    H=H+Hj;
end





%% Plot Hilbert Spectrum and  Marginal Hilbert Spectrum
figure
subplot(2,1,1)
plot(time,sig31./1e6)
xlim([0 time(end)]);
y1=get(gca,'ylim');
%hold on
%plot([timeBefore timeBefore],y1,'r--')
ylabel('Voltage [\muV]')
xlabel('Time [s]')
%hold on
%for t=1:length(stamps2)
%    plot([stamps2(t) stamps2(t)],[-100 -50],'Color','k','LineWidth',1)
%end
subplot(2,1,2)

%%
figure
contour(time,w,H);
colorbar
colormap jet
xlabel('Time [s]')
ylabel('Frequency [Hz]')
title('Hilbert Amplitude Spectrum')

%% Marginal Hilbert Spectrum
mhs = sum(H,2).*dt;
%subplot(3,1,3)
figure
plot(w,mhs)
xlabel('Frequancy [Hz]')
ylabel('Power ')
title('Marginal Hilbert Spectrum')
%%
figure
%%
% |MONOSPACED TEXT|
for i=1:size(modes,1)
    subplot(size(modes,1),1,i)
    plot(time,modes(i,:))
end

%%
figure
subplot(length(imf31)+1,1,1)
plot(time,sig31./1e6)
ylabel('Signal')
title('EMD')
for i=1:length(imf31)
    subplot(length(imf31)+1,1,i+1)
    plot(time,imf31{i}./1e6)
    ylabel(['IMF ' num2str(i)])
end
xlabel('Time [s]')

%%
%figure
colordef(figure,'black');
hold on
N = length(sig31);
c = linspace(0,(N-1)/fs,N);
for k = 1:length(imf31)
   b(k) = sum(imf31{k}.*imf31{k});
end
b     = 1-b/max(b);
for k = 1:length(imf31)
   %plot(c(2:end),f31{k},'k.','Color',b([k k k]),'MarkerSize',3);
   %plot3(c(2:end),f31{k},a31(2:end,k));
   h(k) = patch(c(2:end),...
        f31{k},b(k)*[1 1],'edgecolor','flat','linewidth',3);
end
set(gca,'FontSize',8,'XLim',[0 c(end)],'YLim',[0 1/2*fs]); xlabel('Time'), ylabel('Frequency');