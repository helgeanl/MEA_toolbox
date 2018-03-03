function  plotPDS(signal, fs, chan)
%plotPDS Plot the periodogram of one channel
%   plotPDS( SIGNAL,FS,CHAN) plots the periodogram with the power spectrum
%   of SIGNAL with sampling rate FS. CHAN is a string with the name of the
%   signal. Requires Signal Processing Toolbox

    % Hardcoded cutoff range
    limits = [0 3e9];

    figure;
    [P,f] = periodogram(signal,[],[],fs,'power');
    plot(f,P,'k');
    grid;
    ylabel('Power');
    xlabel('Frequency [Hz]');
    title(['Power Spectrum - Channel ' chan]);
    ylim(limits); 
end

