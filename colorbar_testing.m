%% Nipun Gunawardena
% colorbar_testing.m
% Shows how to use two different colorbars for two separate sets of data
% See
% http://www.mathworks.com/support/solutions/en/data/1-GNRWEH/index.html#Example_1
% and
% http://stackoverflow.com/a/8075772

%% Clear
%clc, close all, clear all


%% Initialize Data
colormap([cool(64);hot(64)])    % Initialize 128 bin colormap. First half cool, second half hot

% Generate Coordinates
x = [1;2;3];
y = [1;2;3];

% Generate Data
temp = [-5;15;45];
sun = [32;450;900];

% Produce the two scatter plots.
hold on
h(1) = scatter(x,y,300,temp,'filled');
h(2) = scatter(x,y,75,sun,'filled');
xlim([0 4])
ylim([0 4])
hold off


%% Scale Colors
% Scale the CData (Color Data) of each plot so that the 
% plots have contiguous, nonoverlapping values. The range 
% of each CData should be equal. Here the CDatas are mapped 
% to integer values so that they are easier to manage; 
% however, this is not necessary.

m = 64; % 64-elements is each colormap

% CData for temperature
cmin = min(temp);       % Minimum temperature
cmax = max(temp);       % Maximum temperature
C1 = min(m,round((m-1)*(temp-cmin)/(cmax-cmin))+1);    % Scale colors between 0 and 64 depending on temperature

% CData for sunlight
cmin = min(sun);
cmax = max(sun);
C2 = 64+min(m,round((m-1)*(sun-cmin)/(cmax-cmin))+1);   % Scale colors between 64 and 128 depending on sunlight


%% Update Plot
set(h(1),'CData',C1);
set(h(2),'CData',C2);

% Change the CLim property of axes so that it spans the 
% CDatas of both objects.
caxis([min(C1(:)) max(C2(:))])

% Generate Colorbar and fake ticks
h(3) = colorbar;
ticks = [1 16:16:64 64:16:128];
ticks(5:6) = [62 66];
set(h(3), 'YTick', ticks);
labels = num2str([linspace(min(temp),max(temp),5) linspace(min(sun),max(sun),5)]');
set(h(3), 'YTickLabel', labels);