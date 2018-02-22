# MEA Analysis Toolbox
This matlab toolbox is intended as a framework for analysing recordings from microelectric arrays. The toolbox supports HDF5 recordings stored in the format from Multi channel systems. This is limited to the 60 MEA layout with recordings containing analog data, spike cutouts, and spike trains.

## Install using source code
This toolbox requires HDF5 package (McsMatlabDataTools ) from Multi Channel Systems, this can be downloaded at www.multichannelsystems.com or installed using the Add-on Explorer in Matlab. When this is done you are ready to run.

Other requirements:
* Matlab 2016a or newer
* Signal Processing Toolbox
    
#### GUI
    MEA_Analysis_Toolbox

![alt text](https://github.com/helgeanl/MEA_toolbox/blob/master/docs/toolbox.PNG "MEA Tooolbox")

#### Terminal based script
Run this script in matlab and a dialogbox will pop up to open the recording. Include mostly the same options as in the GUI, with the addition with more information about the recordings stored in the HDF5 file and different filters. The script is also needed if there is stored more than one of each recording type, e.g. raw data together with filtered data. The user can then select which one to process.

    MEA_Toolbox


