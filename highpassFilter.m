function [ y ] = highpassFilter( n,wc,x )
%highpassFilter Filter signal with nth-order Butterworth highpass filter
%   Input order n, cutoff frequency wc and signal x : [num electrodes x timeseries]
    fs = 10000; % Sampling rate
    [b,a]=butter(n,wc/(fs/2),'high');
    y = zeros(size(x));
    for i=1:60
        y(i,:) = filter(b,a,x(i,:));
    end
end