clear all; clear all; 
srcFile=dir('C:\Users\Samue\OneDrive\Documents\MATLAB\NHS\QCLEAR B400, 350, 200, 0.5TO5MINS\QCLEAR\*.dcm')

for i=1;length(srcFile)
    filename=strcat('C:\Users\Samue\OneDrive\Documents\MATLAB\NHS\QCLEAR B400, 350, 200, 0.5TO5MINS\QCLEAR', srcFile(i).name)
    A=importdata(filename)
    I=dicomread(filename)
    info=Dicominfo(filename)
    se=strel('line',1,1);
end