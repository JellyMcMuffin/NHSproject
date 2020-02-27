clear;
files =  uigetdir([]);
d = dir([files, '\*.dcm']);
nfiles=length(d);

for i=23:nfiles
total_area_binary=0;
total_area_Phantom=0;
filename = d(i).name;
info = dicominfo(filename);
Y = dicomread(info);
T_Half = 109.8*60;

AcqDT=strcat(info.AcquisitionDate, info.AcquisitionTime);
SeriesDT=strcat(info.SeriesDate, info.SeriesTime);
InjDT=strcat(info.SeriesDate, ...
    info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime);


AcqDateTime =datetime(AcqDT,'InputFormat','yyyyMMddHHmmss')
SeriesDateTIme = datetime(SeriesDT,'InputFormat','yyyyMMddHHmmss')
InjDateTime= datetime(InjDT,'InputFormat','yyyyMMddHHmmss.SS')

DecayTime =AcqDateTime - InjDateTime;
DecayTimeSeconds= seconds(DecayTime);
InjAct= info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
decayAct = InjAct * exp(-(DecayTimeSeconds)*log(2)/T_Half);

RescaleIntercept = info.(dicomlookup('0028', '1052'));
RescaleSlope = info.(dicomlookup('0028','1053'));
SUV = (double(Y)+RescaleIntercept)*RescaleSlope;

 
normalizedImage = uint8(255*mat2gray(Y));
Outsidearea= Y<100;

binaryimage=imbinarize(Y,'adaptive','ForegroundPolarity','bright','Sensitivity',0.492);
Normalized = imbinarize(Y);

[labelled_hotspots, num2] = bwlabel(binaryimage, 8);
region_data_hotspots = regionprops('table',labelled_hotspots,'area','MajorAxisLength','MinorAxisLength','PixelList')

Pixels= region_data_hotspots.PixelList

[labelled_phantom,num] =bwlabel(Normalized,8);   
region_data_Phantom = regionprops('table', labelled_phantom, 'Area','MajorAxisLength', 'MinorAxisLength', 'Centroid');

for g= 1:length(region_data_hotspots.Area)
total_area_binary = total_area_binary + region_data_hotspots.Area(g);
end
for g=1:length(region_data_Phantom.Area)
total_area_Phantom = total_area_Phantom + region_data_Phantom.Area(g);
end 


for region=1:num2
    list=[];
    for pix=1:length(Pixels{region})
        Pixels(region);
        Pixel_location_x=Pixels{region}(pix);
        Pixel_location_Y=Pixels{region}(pix,2);
        pixval = impixel(SUV,Pixel_location_x,Pixel_location_Y);
        
    end
end


snr=total_area_binary/(total_area_Phantom - total_area_binary);
disp("snr " + filename +": " +snr)

f= figure('Name',""+filename,'NumberTitle', 'off' );
subplot(1,5,1), imshow(Y)
title("Original");
subplot(1,5,2), imshow(binaryimage)
title("Hotspots");
subplot(1,5,3), imshow(Normalized)
title("Total area")
subplot(1,5,4), imshow(SUV)
title("SUV")

%frame_h = get(handle(gcf),'JavaFrame');
%set(frame_h,'Maximized',1)

end


