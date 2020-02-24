info = dicominfo('QCLAER B400 1Min.dcm');
Y = dicomread(info);
figure
imshow(Y,[]);