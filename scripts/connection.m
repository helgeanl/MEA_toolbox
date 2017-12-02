%% Connectivity

% Name of connectivity matrices to look for
cmName = 'TCM_n=0.txt';

%% Select folder to import data
[pathname] = uigetdir('','Select directory containing ToolConnect results');

%% Select folder to save connectivity plots
[savepath] = uigetdir('','Select directory to save plots');

%% Get contents of results folder
dirs = dir(pathname);

%% Search through the folder for Connectivity matrices
for i =1:length(dirs)
    d = dirs(i);
    if ~isequal(d(end).name,'.') && ~isequal(d(end).name,'..') && ~contains(d(end).name,'.txt') 
        while  ~isempty(d) && ~contains(d(end).name,'.txt')
                path = fullfile(d(end).folder,d(end).name);
                d = dir(path);
        end
        cm = load(fullfile(d(end).folder, cmName));
        cfg =[];
        cfg.title = ['Transfer entropy - ' dirs(i).name];
        [degree(i), entropy(i)] = dirgraph(cm,0, cfg);
        name{i} = dirs(i).name;
        saveas(gcf,fullfile(savepath,[dirs(i).name '.png']),'png');
        saveas(gcf,fullfile(savepath,[dirs(i).name '.eps']),'epsc');
        close gcf
    end
end

%% Sort by date
for i=1:length(name)
    if isempty(name{i})
        name(i)=[];
        degree(i) =[];
        entropy(i) = [];
    end
end
%%
date = datenum(name,'dddd dd. mmmm yyyy');
[sortedDate,s] = sort(date);
name = name(s);
%%
entropy = entropy(s);
degree = degree(s);


 %%
 figure;
 plot(sortedDate,degree,'o-')
 datetick('x','mmm-yy')
 title('Number of connections')


 %%
 figure;
 plot(sortedDate,entropy,'o-')
 datetick('x','mmm-yy')
 title('Total entropy')
 
%%
for i=1:22
    [file, pathname] = uigetfile('*.h5','Select HDF5 file with recording');
    dataFile = McsHDF5.McsData([pathname file],cfg);
    recordingDate = dataFile.Data.Date;
    if contains(recordingDate,'?')
        recordingDate = replace(recordingDate,'?','_'); 
    end
    cfg = [];
    cfg.window = [0 300]; % time range in seconds
    analogData = dataFile.Recording{1}.AnalogStream{stream}.readPartialChannelData(cfg);
    data = analogData.ChannelData';
    energy(i) = sum(plotEnergy(data,10000));
    name{i}=recordingDate;
    saveas(gcf,fullfile(savepath,[recordingDate '_energy.png']),'png');
    saveas(gcf,fullfile(savepath,[recordingDate '_energy.eps']),'epsc');
    close gcf
end


%%
date = datenum(name,'dddd dd. mmmm yyyy');
[sortedDate,s] = sort(date);
name = name(s);
energy = energy(s);



 %%
 figure;
 plot(sortedDate,energy,'o-')
 datetick('x','mmm-yy')
 title('Total energy')
