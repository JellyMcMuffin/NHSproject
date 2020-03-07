clear;
files =  uigetdir([]);
d = dir([files, '\*.dcm']);
nfiles=length(d);

for i=12
    sensitivity=0.464;
    
   

    
    
    
   
    
total_area_binary=0;
total_area_Phantom=0;
filename = d(i).name
info = dicominfo(filename);
Y = dicomread(info);
T_Half = 109.8*60;

AcqDT=strcat(info.AcquisitionDate, info.AcquisitionTime);
SeriesDT=strcat(info.SeriesDate, info.SeriesTime);
InjDT=strcat(info.SeriesDate, ...
    info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime);


AcqDateTime =datetime(AcqDT,'InputFormat','yyyyMMddHHmmss');
SeriesDateTIme = datetime(SeriesDT,'InputFormat','yyyyMMddHHmmss');
InjDateTime= datetime(InjDT,'InputFormat','yyyyMMddHHmmss.SS');

DecayTime =AcqDateTime - InjDateTime;
DecayTimeSeconds= seconds(DecayTime);
InjAct= info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
decayAct = InjAct * exp(-(DecayTimeSeconds)*log(2)/T_Half);

RescaleIntercept = info.(dicomlookup('0028', '1052'));
RescaleSlope = info.(dicomlookup('0028','1053'));
SUV = (double(Y)+RescaleIntercept)*RescaleSlope;
%  figure(1)
%  imshow(SUV,[]);
%  set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%  axis image;
%  %c=imellipse;
 

 
normalizedImage = uint8(255*mat2gray(Y));
Outsidearea= Y<100;

binaryimage=imbinarize(Y,'adaptive','ForegroundPolarity','bright','Sensitivity',sensitivity);
Normalized = imbinarize(Y);

[labelled_hotspots, num] = bwlabel(binaryimage, 8);
region_data_hotspots = regionprops('table',labelled_hotspots,'area','MajorAxisLength','MinorAxisLength',"Centroid");

%[labelled_phantom,num] =bwlabel(Normalized,8);   
%region_data_Phantom = regionprops('table', labelled_phantom, 'Area','MajorAxisLength', 'MinorAxisLength', 'Centroid');

for g= 1:length(region_data_hotspots.Area)
total_area_binary = total_area_binary + region_data_hotspots.Area(g);
end
%for g=1:length(region_data_Phantom.Area)
%total_area_Phantom = total_area_Phantom + region_data_Phantom.Area(g);
%end 


% snr=total_area_binary/(total_area_Phantom - total_area_binary);
filename
num
sensitivity

% 
% f= figure('Name',""+filename,'NumberTitle', 'off');
% subplot(1,4,1), imshow(Y)
% title("Original");
% subplot(1,4,2), imshow(binaryimage)
% title("Hotspots");
% subplot(1,4,3), imshow(Normalized)
% title("Total area")
% subplot(1,4,4), imshow(SUV)


end


