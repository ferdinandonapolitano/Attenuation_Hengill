%% MURAT_PLOT Creates files for visualization in Matlab and Paraview
function Murat                      =   Murat_plot(Murat)
%%
% Importing all the necessary inputs and data for plotting
FLabel                              =   Murat.input.label;
origin                              =   Murat.input.origin;
ending                              =   Murat.input.end;
x                                   =   Murat.input.x;
y                                   =   Murat.input.y;
z                                   =   Murat.input.z;
sections                            =   Murat.input.sections;
plotV                               =   Murat.input.modvPlot;
cf                                  =   Murat.input.centralFrequency;
vS                                  =   Murat.input.averageVelocityS;
tWm                                 =   Murat.input.codaWindow;
kT                                  =   Murat.input.tresholdNoise;
B0                                  =   Murat.input.albedo;
Le1                                 =   Murat.input.extinctionLength;
QcM                                 =   Murat.input.QcMeasurement;
sped                                =   Murat.input.spectralDecay;
lapseTimeMethod                     =   Murat.input.lapseTimeMethod;

modvQc                              =   Murat.input.modv;
stepgX                              =   (modvQc(2,1) - modvQc(1,1))/2;
stepgY                              =   (modvQc(2,2) - modvQc(1,2))/2;
stepgZ                              =   (modvQc(2,3) - modvQc(1,3))/2;
modvQc(:,1)                         =   modvQc(:,1) + stepgX;
modvQc(:,2)                         =   modvQc(:,2) + stepgY;
modvQc(:,3)                         =   modvQc(:,3) + stepgZ;

Qm                                  =   Murat.data.inverseQc;
time0                               =   Murat.data.travelTime;
retainPeakDelay                     =   Murat.data.retainPeakDelay;
retainQc                            =   Murat.data.retainQc;
retainQ                             =   Murat.data.retainQ;
ray_crosses_pd                      =   Murat.data.raysPeakDelay;
ray_crosses_Qc                      =   Murat.data.raysQc;
ray_crosses_Q                       =   Murat.data.raysQ;
fitrobust                           =   Murat.data.fitrobust;
peakData                            =   Murat.data.peakDelay;
luntot                              =   Murat.data.totalLengthRay;
rma                                 =   Murat.data.raysPlot;
modv_pd                             =   Murat.data.modvPeakDelay;
modv_Qc                             =   Murat.data.modvQc;
modv_Q                              =   Murat.data.modvQ;
evestazDegrees                      =   Murat.data.locationsDeg;
energyRatio                         =   Murat.data.energyRatioBodyCoda;
codaNoiseRatio                      =   Murat.data.energyRatioCodaNoise;
Ac_i                                =   Murat.data.inversionMatrixQc;
RZZ                                 =   Murat.data.uncertaintyQc;
A_i                                 =   Murat.data.inversionMatrixQ;
residualQc                          =   Murat.data.residualQc;
residualQ                           =   Murat.data.residualQ;
locationM                           =   Murat.data.locationsM;
tCoda                               =   Murat.data.tCoda;
rapsp                               =   Murat.data.energyRatioBodyCoda;
% locDegOriginal                      =   Murat.data.locDegOriginal;

FPath                               =   './';
sizeTitle                           =   18;

lMF                                 =   size(ray_crosses_pd);
sections(3)                         =   sections(3)/1000;

% purpleorange                        =...
%     colMapGen([0.5 0 0.5],[0.91 0.41 0.17],256);

%% PLOTS - coverage and sensitivity
% Declustering is done before any frequency analysis, here we show the 2D
% rays before and after

% FName_Cluster                       =   'Clustering';
% clustering                          =   Murat_imageDeclustering(...
%     locDegOriginal,evestazDegrees,origin,ending,FName_Cluster);
storeFolder                     =   'RaysKernels';
% pathFolder                      =...
%         fullfile(FPath,FLabel,storeFolder,FName_Cluster);
% saveas(clustering,pathFolder,'tif');
% close(clustering)

evestaz                             =...
    [evestazDegrees(:,1:2) -evestazDegrees(:,3)/1000 ...
    evestazDegrees(:,4:5) evestazDegrees(:,6)/1000];


for k = 1:lMF(2)
    %% PLOT - RESULTS
    % Set up matrices. The points are set to the upper SW vertices to
    % work with the function "slice". All stored in the sub-folder.
    modv_Qc_k                       =   modv_Qc(:,:,k);
    [~,~,~,mQc]                     =   Murat_fold(x,y,z,modv_Qc_k(:,4));
    Z                               =   Z1/1000;
    evestaz_Qc                      =   evestaz(rtQck,:);
    %%
    % Qc results
    storeFolder                     =   'Results/Qc';
    FName_QcMap                     =   ['Qc-3D_' fcName '_Hz'];
    load('roma.mat'); %load the cpt from Scientific color Maps. The cpt is direclty in your folder
    cpt=flipud(roma); %here I invert the cpt (-I in GMT)
    Qcmap                           =   Murat_image3D(X,Y,Z,mQc,...
        cpt,sections,evestaz_Qc,x,y,z,FName_QcMap);
    hold on
    faults= shaperead('Faglie_LatLon.shp');  %load the shapefile in your folder
    mapshow(faults, 'Color','black', 'LineWidth',1.5) %read the shapefile
  
    %coastline
  
    coast = shaperead('Coastline.shp');
    mapshow(coast,'Facealpha',0, 'LineWidth',1)
    
    xlim([origin(2) ending(2)]); %if necessary, cut the shapefile in your area of interest
    ylim([origin(1) ending(1)]);
    hold on
    fx = [13.20 13.30 13.15 13.049 13.20]; %polygons as fault planes
    fy = [42.70 42.74 42.94 42.90 42.70];
    plot(fx,fy,'r-','LineWidth', 2);
    hold on
    fx2 = [13.21 13.09 13.22 13.33 13.21];
    fy2 = [42.877 42.83 42.62 42.66 42.877];
    plot(fx2,fy2,'r-','LineWidth', 2);    
    hold on
    Amx = [13.09 13.16 13.23]; %location of mainshocks
    Amy = [42.93 42.82 42.70];
    Amz = [-4.5 -5.6 -6.7];
    plot3(Amx,Amy,Amz, 'rp','MarkerSize',32,...
    'MarkerEdgeColor','black','LineWidth',2,...
    'MarkerFaceColor',[1 1 0])
    hold off
    title('Coda attenuation variations',...
        'FontSize',sizeTitle,'FontWeight','bold','Color','k');
    pathFolder                      =...
        fullfile(FPath,FLabel,storeFolder,FName_QcMap);
    Murat_saveFigures(Qcmap,pathFolder);

close all
