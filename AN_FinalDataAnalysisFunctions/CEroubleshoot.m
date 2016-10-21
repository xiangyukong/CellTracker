%%

ff = dir('.');
k = 25;
if ~isdir(ff(k).name)
matfile = ff(k).name;
mkFullCytooPlotPeaks('PluriNtwInh_Furin(nodal_Inh).mat');
disp(matfile)
end

%% get the raw image files from .btf or .tif

MMdirec1 = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/13_20160222-PaperFigures_DATA/CEtroubleshooting/Control_diff3ngmlFGFindiff';
chan = {'DAPI'};
filenames1 = 'Control_diff3ngml.btf';
flag = 1;% flag = 1 for .btf; flag = 0 or [] for .tif

[acoords]=templateSplitOlympData(MMdirec1,chan,filenames1,flag);



%% plot montage with colonies and colony sizes labeled

dir ='/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/13_20160222-PaperFigures_DATA/CEtroubleshooting/Control_diff3ngmlFGFindiff';%'/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/2_NO_QUADRANTS_goodData(esi017Cells)/2016-10-03-densityR/62um';%'/Volumes/data2/Anastasiia/totestClonyGrouping/torun';
%dir = '/Volumes/data2/Anastasiia/2016-04-06-Inhibitors(Bi_FGFRi)/FGFRi_extracted';
matfile = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/13_20160222-PaperFigures_DATA/CEtroubleshooting/didnotwork/C_diff_fgfindiff.mat';
chan = 'DAPI';
scale = 0.2;
N =8;
labelMontageColonies(dir,matfile,chan,scale,N)
%% label image numbers on the montage
%dir = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/9_LiveCllImaging/06-05-2016-fixedGFPs4cells_troubleshooting/GFP-Smad4cellsTroubleshootandSox2stain/gfps4_june3';
dir = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/2_NO_QUADRANTS_goodData(esi017Cells)/2016-10-19-R2otherMEKiandLEFTY/R2control';
matfile = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/13_20160222-PaperFigures_DATA/CEtroubleshooting/worked/GFPs4cells_failedimagingJune3.mat';
chan = 'DAPI';
scale = 0.2;


labelStitchPreviewMM(dir,matfile,chan,scale)
%% plot the usual analysis (mean vs N)
nms = {'C_pluri_fgfindiff','C_diff_fgfindiff','FGFi_BMP4_fgfindiff'};    % ,'Lefty_R','otherMEKi_R'  dapi gfp(sox2) rfp(nanog)
nms2 = {'control no BMP4','control with 3 ng/ml bmp4','MEKi with 3 ng/ml BMP4'};%  ,'Lefty','MEKi*'  nanog(555) peaks{}(:,8), pERK(488) peaks{}(:,6)
%  nms = {'ControluCol_pAkt','MEKi_uCol_pAkt'};    % ,'Lefty_R','otherMEKi_R'  dapi gfp(sox2) rfp(nanog)
%  nms2 = {'C','MEKi'};%  ,'Lefty','MEKi*'  nanog(555) peaks{}(:,8), pERK(488) peaks{}(:,6)
 
dapimax =5000;%now used as the area thresh in colony analysis; dapimax is set to max 60000 within the generalized mean function
chanmax = 60000;
dir = '.';

usemeandapi =[];
flag1 = 1;
[mediaonly,~,~,~,~]= plotallanalysisAN(1.2,nms,nms2,dir,[],[],[8 5],[8 6],'Sox2','Dapi',0,1,dapimax,chanmax,usemeandapi,flag1);  
% h = figure(1);
% h.Children.FontSize = 14;
% ylim([0 8]);
% xlim([0 7]);
% for k=1:2
% figure(6), subplot(1,2,k)
% xlim([0 8])
% ylim([0 4])
% end
%% compare regions with good pattern and not good patter (based on image numbers)
nms = {'C_pluri_fgfindiff160'};    % ,'Lefty_R','otherMEKi_R'  dapi gfp(sox2) rfp(nanog)
nms2 = {'Control pluri fgfindiff'};%  ,'Lefty','MEKi*'  nanog(555) peaks{}(:,8), pERK(488) peaks{}(:,6)
dapimax =5000;%now used as the area thresh in colony analysis; dapimax is set to max 60000 within the generalized mean function
chanmax = 60000;
usemeandapi =[];
index1 = [8 5];
param1 = 'Sox2';
flag = 0;
dir = '.';
% gfps4 chip
% imN1 = [281,301,302,321,322];% unpatterned region
% imN2 = [189,190,191,269,270,271,290,291,292]  ;%[113:120][86, 88, 108, 127,107,128,45,126,147][189,190,191,269,270,271,290,291,292] patterned region

% control fgf in diff chip
imN1 = [290,315,302,327,326,329,212];% unpatterned region
imN2 = [6,101,102,356,356,357,358,359,360,176:182,191,192,195,370] ;%patterned region

[rawdata1,totalcells1] =  Intensity_vs_ColSizeSelectImages(nms,nms2,dir,index1,param1,dapimax,chanmax,usemeandapi,flag,imN1);
[rawdata2,totalcells2] =  Intensity_vs_ColSizeSelectImages(nms,nms2,dir,index1,param1,dapimax,chanmax,usemeandapi,flag,imN2);

figure(8), plot(rawdata1{1}(1:5),'b*-','markersize',18,'linewidth',2);hold on
figure(8), plot(rawdata2{1}(1:5),'r*-','markersize',18,'linewidth',2);hold on
figure(8), plot(4,mean(rawdata1{1}(~isnan(rawdata1{1}))),'mx','markersize',18,'linewidth',2)
legend('NO PATTERN','PATTERN','mean no pattern');
xlim([0 5.5]);
ylim([0 3]);
xlabel('Colony Size');
ylabel(['Expression of ' num2str(param1) ' marker']);
figure(9), plot(totalcells1,'b*-','markersize',18,'linewidth',2);hold on
figure(9), plot(totalcells2,'r*-','markersize',18,'linewidth',2);
legend('NO PATTERN','PATTERN');
xlim([0 5.5]);
ylabel('Total Cells');
xlabel('Colony Size');
%% rerun colony grouping
direc = '/Users/warmflashlab/Desktop/A_NEMASHKALO_Data_and_stuff/13_20160222-PaperFigures_DATA/CEtroubleshooting/Control_FGFinDiffexper';%'/Volumes/data2/Anastasiia/totestClonyGrouping/torun';
paramfile = '/Users/warmflashlab/CellTracker/paramFiles/setUserParamAN20X_uCOL_mek.m';
run(paramfile);

ff = readMMdirectory(direc);
%for k=1:size(ff,1)
  % if isdir(ff(k).name) == 0
   %outfile = ff(k).name;
   outfile = 'C_pluri_fgfindiff.mat';
   
   load([direc filesep outfile],'bIms','nIms','dims');
   [colonies, peaks]=peaksToColonies([direc filesep outfile]);


     plate1=plate(colonies,dims,direc,ff.chan,bIms,nIms, outfile);
%
     plate1.mm = 1;
     plate1.si = size(bIms{1});
    save([direc filesep outfile],'plate1','peaks','-append');
    disp('done');
   % save([direc filesep outfile],'colonies','peaks','-append');
 %  end
%end




