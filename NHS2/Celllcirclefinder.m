clear;
cells = imread ('cells.jpg');
binary_cells=~im2bw(cells );

[binary_cells_label,nocells]=bwlabel(binary_cells,8);

subplot(1,2,1);imagesc(binary_cells_label);colormap(gray); colorbar; axis off; axis image;

Circularity=regionprops(binary_cells_label, "circularity");

for i=1:nocells
    L=find(binary_cells_label==i);
     if Circularity(i).Circularity<0.9
         binary_cells_label(L)=0;
     end

end

subplot(1,2,2); imagesc(binary_cells_label); colormap(gray); colorbar; axis off; axis image;