clear;
files =  uigetdir([]);
d = dir([files, '\*.dcm']);
nfiles=length(d);

for i=23:nfiles
    %sets up counter later in code
total_area_binary=0;
total_area_normalized=0;
    %Allows the loop to grab different filenames
filename = d(i).name;
    %Opens the dicom image 
info = dicominfo(filename);
    %reads the dicom image into image form
Y = dicomread(info);
%figure('Name',filename,'NumberTitle','off');
%imshow(Y,[]);
    %converts the image to a normalized form
normalizedImage = uint8(255*mat2gray(Y));
Outsidearea= Y<100;
    %creates a figure to show the image
f= figure('Name',"Normalized image"+filename,'NumberTitle', 'off');
%imshow(normalizedImage);
    %conversts the normalized image into a binary image to reveal just the
    %boundary signals
binaryimage = normalizedImage<100;
[labelled_hotspots, num] = bwlabel(binaryimage, 8);
    %Provides data about the determined regions
region_data_binary = regionprops('table',labelled_hotspots,'area','MajorAxisLength','MinorAxisLength',"Centroid")
    %SUPPOSED TO COUNT THE TOTAL REGION AREA
for g= 0:length(region_data_binary.Area)
%total_area_binary= total_area_binary + region_data_binary.Area;
region_data_binary.Area;
end
    %PROVIDES DATA ABOUT THE OTHER REGION ( THE WRONG ONE )
%region_data_normalized = regionprops('table',normalizedImage,'area','MajorAxisLength','MinorAxisLength',"Centroid");
    %SUPPOSED TO COUNT THE  TOTAL AREA FOR THAT BIT (SHOULD EB UNECCESARY)
%for k =0:length(region_data_normalized.Area)
%total_area_normalized= total_area_normalized+region_data_normalized.Area;
%end
%snr=(region_data_binary.Area - region_data_normalized.Area)/region_data_binary.Area


    %Plots the image on to half of a plot
subplot(1,3,1), imshow(normalizedImage)
title("Normalized image" +total_area_normalized);
    %plots the remvoed boundary areaes 
subplot(1,3,2), imshow(binaryimage)
title("Binary image" +total_area_binary);
axis on
subplot(1,3,3), imshow(Outsidearea)
title("Outside area");
axis on
%msg="Are the regions as expected?" ;
%title="Manually define regions?";
%F= uiconfirm(f, msg, title,...
   % 'Options',{'yes','No'});
   % if F=='yes'
    %close(f)
    
   % else 
    %print("poo")
   % end
end


