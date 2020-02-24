[filename, user_canceled]=imgetfile;
A = importdata(filename);
info = dicominfo(filename);
img=dicomread(info);

titleinput = 'input';
dims = [1 35];
prompt1 = ('Enter Series Title') 
definput1 =('e.g. VPFX3mINUTES')
ImageName = inputdlg(prompt1,titleinput,dims,definput1);
imNam = cell2mat(ImageName)