%%          Install drEEM toolbox
cd 'C:\Users\Jonas\MATLAB\drEEM-0.6.5\' 
dreeminstall

%%          Remove old sample files
%   Folder for current PARAFAC modeling
A = 'C:\Users\Public\fluorescence_spectroscopy\readings\';

%   Folder for old sample files
B = 'C:\Users\Public\fluorescence_spectroscopy\archive\';
filenames=dir(fullfile(A,'*.dat'));

%   base data contains 72 samples (3 files each). Including the current
%   sample, 219 files are considered for PARAFAC modeling
num_base = 219;
C = size(filenames,1); 
move = C - num_base;

%   If folder A contains more than 219 samples, the older sample files are
%   removed to folder B
%   Samples naming convention: YYYY-MM-DD-HH-MM-SS
if C > num_base    
   for f = 1:move
   movefile(fullfile(filenames(f).folder,filenames(f).name),B)
   end
end

%%         Define size of the raw data set
flusize = 'A2..EE126';      % Matrice with respective EEM data       
abssize = 'A1..B134';       % Matrice with respective absorbance data         

%%          Import raw data
%   Import every sample (fluorescence)
cd('C:\Users\Public\fluorescence_spectroscopy\readings\');
[X,Emmat,Exmat,fl,outdata]=readineems(3,'*SEM.dat',flusize,[0 1],0,0);                  
DS = assembledataset(X,Exmat(1,:),Emmat(:,1),'RU','filelist',fl,[]);
clearvars -except DS datalocation savelocation flusize abssize

%   Import corresponding blank (fluorescence)
[X_b,Emmat_b,Exmat_b,fl_b,outdata_b]=readineems(3,'*BEM.dat',flusize,[0 1],0,0);        
DSb = assembledataset(X_b,Exmat_b(1,:),Emmat_b(:,1),'RU','filelist',fl_b,[]);
clearvars -except DS DSb datalocation savelocation flusize abssize

%   Import absorbance spectra
[S_abs,W_abs,wave_abs,filelist_abs]=readinscans('Abs','dat_1_2',abssize,0,0,'*ABS');    

%   Define Absorbance Spectra
A=[wave_abs;S_abs];          
Abs.A=A;                    
Abs.filelist=cellstr(filelist_abs);
Abs.wave=wave_abs;
SAK254 = Abs.A(2,19);
SAK436 = Abs.A(2,79);
clearvars -except DS DSb Abs datalocation savelocation flusize abssize SAK254 SAK436

%%          Check file alignment
try
   isequal(size(cellstr(num2str((1:DS.nSample)'))),size(DS.filelist),size(DSb.filelist),size(Abs.filelist));
   isequal(extractBefore(DS.filelist,15),extractBefore(DSb.filelist,15),extractBefore(Abs.filelist,15));
catch   
   error('Missmatch: DS.nSample, DS.filelist, DSb.filelist')
end
clearvars -except DS DSb Abs datalocation savelocation flusize abssize SAK254 SAK436

%%          Adaption of the EEM data according to absorbance data
disp('Abs wavelengths: min and max')
AbsRange=[min(Abs.wave) max(Abs.wave)];
disp(AbsRange)
disp('EEM wavelengths: min and max')
EEMRange=[min([DS.Em' DS.Ex']) max([DS.Em' DS.Ex'])];
disp(EEMRange)

%   Removal of wavelenths <240nm and >600nm
Xin=subdataset(DS,[],...
   logical(double(DS.Em<AbsRange(1))+ double(DS.Em>AbsRange(2))),...
   logical(double(DS.Ex<AbsRange(1))+ double(DS.Ex>AbsRange(2))));
B=subdataset(DSb,[],...
   logical(double(DS.Em<AbsRange(1))+ double(DS.Em>AbsRange(2))),...
   logical(double(DS.Ex<AbsRange(1))+ double(DS.Ex>AbsRange(2))));

%%          EEM correction - IFE and normalization of the EEMs with Raman peak intensity 
%   Folder for saving variables (outside the reading folder)
cd('C:\Users\Public\fluorescence_spectroscopy\variables\');
RamanWavel=351;                     %350 nm in literature, here: 351 nm
Sr=squeeze(B.X(:,:,DSb.Ex==351));
W=[B.Em';Sr];                       %2D Matrix of the 351nm Raman scan
B.W=W;

[XcRU, Arp, IFCmat, BcRU, XcQS, QS_RU]=fdomcorrect(Xin.X,Xin.Ex,Xin.Em,...
   [Xin.Em ones(size(Xin.Em))],[Xin.Ex ones(size(Xin.Ex))],...  
   B.W,[351 381 426],Abs.A,B.X,B.W,[],[]);

%%          Consolidation of the data set 
Xin.X=XcRU;             	                    %X is in Raman Units
Xin.RamanArea=Arp;                              %Raman Peak Area
Xin.IFE=IFCmat;                                 %IFE correction factors
Xin.Abs_wave=Abs.A(1,:);                        %Abs wavelengths
Xin.Abs=Abs.A(2:end,:);                         %Abs data
Xin.Ram_wave=B.Em';                             %Water Raman wavelengths
Xin.Emcor='internally corrected by AquaLog';    %corrected by AquaLog not drEEM
Xin.Excor='internally corrected by AquaLog';    %corrected by AquaLog not drEEM
Xin.RamOpt=[350 381 426];                       %Raman integration range on Em spectrum
Xin.RamSource='Water Raman scans extracted from blanks';
clearvars -except Xin SAK254 SAK436
checkdataset(Xin)

%   Save Xin
cd('C:\Users\Public\fluorescence_spectroscopy\variables\')
save('Xin')

%%          Preprocessing of the data set
%   Scattertreatment - Removal of noisy and unreliable wavelengths (Em>580 and Ex <250 nm)
Xstart = subdataset(Xin,[],Xin.Em>580,Xin.Ex<250);   
Xstart = subdataset(Xstart,[],Xstart.Em<240,Xstart.Ex>550);
clearvars -except Xstart SAK254 SAK436

%%          Rayleigh and Raman scattering
Xs = smootheem(Xstart,[12 30],[7 2],[15 18],[],[0 1 0 0],[],3382,0); 

%%          Automatic function removes errors for each EEM 
dataout = rmspikes(Xs,'interpolate',true);

%   Normalization 
Xpre = normeem_aut(dataout);

%%          Model generation and export
cd('C:\Users\Public\fluorescence_spectroscopy\')
model = randinitanal(Xpre,6,'starts',10,'constraints','nonnegativity','convgcrit',1e-6); 

%   Withdrawal of normalization
results = normeem(model,'reverse',6);
aExcel = actxserver('Excel.Application');

%   Suppress Excel warning popups, like for overwriting a file
Excel.DisplayAlerts = false;

%   Export fluorescence, absorbance data
data = modelexport_aut(results,6,'model_data_6.xlsx');
writematrix(SAK254, 'sak254.txt');
writematrix(SAK436, 'sak436.txt');