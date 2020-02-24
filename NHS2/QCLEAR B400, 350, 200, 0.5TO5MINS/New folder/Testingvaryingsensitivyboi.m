clear;
files =  uigetdir([]);
d = dir([files, '\*.dcm']);
nfiles=length(d);

for i=1:nfiles
total_area_binary=0;
total_area_Phantom=0;
filename = d(i).name;
info = dicominfo(filename);
Y = dicomread(info);
normalizedImage = uint8(255*mat2gray(Y));
Outsidearea= Y<100;

%N= [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5]/10
N=[0.4 0.45]
for A = 1:length(N)
binaryimage=imbinarize(Y,'adaptive','ForegroundPolarity','bright','Sensitivity',N(A));


Normalized = imbinarize(Y);

[labelled_hotspots, num] = bwlabel(binaryimage, 8);
region_data_hotspots = regionprops('table',labelled_hotspots,'area','MajorAxisLength','MinorAxisLength',"Centroid");

[labelled_phantom,num] =bwlabel(Normalized,8);   
region_data_Phantom = regionprops('table', labelled_phantom, 'Area','MajorAxisLength', 'MinorAxisLength', 'Centroid');

for g= 1:length(region_data_hotspots.Area)
total_area_binary = total_area_binary + region_data_hotspots.Area(g);
end
for g=1:length(region_data_Phantom.Area)
total_area_Phantom = total_area_Phantom + region_data_Phantom.Area(g);
end 


snr=total_area_binary/(total_area_Phantom - total_area_binary);
disp("snr " + filename + N(A)+ ": " +snr)


f= figure('Name',""+filename + N(A),'NumberTitle', 'off');   
subplot(1,3,1), imshow(Y)
title("Original");
subplot(1,3,2), imshow(binaryimage)
title("Hotspots");
subplot(1,3,3), imshow(Normalized)
title("Total area")

end
end


