function [ y ] = bandpassFilter( n,w1, w2,fs,x )
%bandpassFilter Filter signal with nth-order Butterworth bandpass filter
%   y  = bandpassFilter(n,w1, w2,fs,x) filters the data in column vector x with  
%   a bandpass butterworth filter of order n.
%
%   Y = bandpassFilter(n,w1, w2,fs,X) filters the data of each column in 
%   matrix X with a bandpass butterworth filter of order n. 
%
%   Both cases use respectively a lower and higher cutoff frequency 
%   w1 and w2, with a sampling rate of fs. The function filfilt is used to
%   get non-causal zero-phase filtering.

    [b,a]=butter(n,[w1 w2]/(fs/2),'bandpass');
    y = zeros(size(x));
    % Filter each channel individually
    for i=1:size(x,2)
        y(:,i) = filtfilt(b,a,x(:,i));
    end
end