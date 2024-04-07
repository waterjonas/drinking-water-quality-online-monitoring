function I_I_start_control()

 %  Folder where fluorescence raw data is saved
 path_to_watch = 'C:\Users\Public\fluorescence_spectroscopy\readings\';   
 fileObj = System.IO.FileSystemWatcher(path_to_watch);
 fileObj.Filter = '*.dat';
 fileObj.EnableRaisingEvents = true;
 addlistener(fileObj,'Created', @eventhandlerChanged);
 process = true;
 while process
    pause(0.001);
 end
 end
 function eventhandlerChanged(~,~)
    I_II_PARAFAC
 end
 