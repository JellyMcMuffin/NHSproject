clear;
files =  uigetdir([]);
d = dir([files, '\*.dcm']);
nfiles=length(d);


for i=18
   

filename = d(i).name;
info = dicominfo(filename);
Y = dicomread(info);
T_Half = 109.8*60;




f= figure('Name',""+filename,'NumberTitle', 'off' );

prompt2={'Image Sensitivity'};
dlgtitle=""+filename+' sensitivity';
dims=[1 75];
definput2={'0.4'};
sensitivity=inputdlg(prompt2,dlgtitle,dims,definput2)
sensitivity=str2double(sensitivity{1})

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

subplot(1,3,3), imshow(SUV)
title("SUV")
 
normalizedImage = uint8(255*mat2gray(Y));
Outsidearea= Y<100;

binaryimage=imbinarize(Y,'adaptive','ForegroundPolarity','bright','Sensitivity',sensitivity);
Normalized = imbinarize(Y);

[labelled_hotspots, num2] = bwlabel(binaryimage, 8);
region_data_hotspots = regionprops('table',labelled_hotspots,'all');%'area','MajorAxisLength','MinorAxisLength','PixelList','Centroid','PixelIdxList');
center = [region_data_hotspots.Centroid(1,1) region_data_hotspots.Centroid(1,2)];
Radii= mean([region_data_hotspots.MajorAxisLength(1) region_data_hotspots.MinorAxisLength(1)],2)/2;

Pixels= region_data_hotspots.PixelIdxList;

circle=drawcircle('Center',[128 128],'Radius',Radii);
%mask=createMask(circle,SUV);
background_pixels=SUV(circle.createMask);
max_background=max(background_pixels)
mean_background=mean(background_pixels)
std_background=std(background_pixels)



[labelled_phantom,num] =bwlabel(Normalized,8);   
region_data_Phantom = regionprops('table', labelled_phantom, 'Area','MajorAxisLength', 'MinorAxisLength', 'Centroid');
region_data_Phantom.Centroid;
%for g= 1:length(region_data_hotspots.Area)
%total_area_binary = total_area_binary + region_data_hotspots.Area(g);
%end
%for g=1:length(region_data_Phantom.Area)
%total_area_Phantom = total_area_Phantom + region_data_Phantom.Area(g);
%end 




SNR_mean=cell(num2, 1);
SNR_max=cell(num2, 1);
CNR_mean=cell(num2,1);
CNR_max=cell(num2,1);


for region=1:num2
    x=zeros([1 length(Pixels{region})]);
    for pix=1:length(Pixels{region})
     
        %Pixel_location_x=Pixels{region}(pix);
        %Pixel_location_Y=Pixels{region}(pix,2);
       % pixval = impixel(SUV,Pixel_location_x,Pixel_location_Y);
        pixnum=Pixels{region}(pix);
        pixval = SUV(pixnum);
       x(pix)=pixval(1);
    end
    SNR_mean{region}=mean(x)/std(x);
    SNR_max{region}=max(x)/std(x);
    CNR_mean{region}=(mean(x)-mean_background)/std_background;
    CNR_max{region}=(max(x)-mean_background)/std_background;
    %z_std{region}=std(x);
end

SNR_mean{7}=max_background/std_background
SNR_max{7}=mean_background/std_background

subplot(1,3,1), imshow(Y)
title("Original");
subplot(1,3,2), imshow(binaryimage)
title("Hotspots");
[filepath,name,ext]=fileparts(filename)
name
saveas(gcf, name+".png")


end


