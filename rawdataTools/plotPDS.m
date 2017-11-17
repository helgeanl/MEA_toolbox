function  plotPDS( signal)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    figure;
    [P,f] = periodogram(signal,[],[],10000,'power');
    plot(f,P,'k')
    %xlim([0 40])
    grid
    ylabel('Power')
    xlabel('Frequency [Hz]')
    title('Power Spectrum')

end

