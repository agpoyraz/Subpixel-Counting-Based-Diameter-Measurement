function [im_desired] = eliminate_small_objects(im,threshold)
% eliminate_small_objects 
% This function finds only desired object on image and removes small objects or noises. 
% input: image and threshold
% image: Measurement image(Taken from industiral camera and telecentric
%         lens.
% output: Only biggest image with no noise or any small objects.
%   Detailed explanation goes here

im_mask = zeros(size(im,1),size(im,2));
bw_th = imcomplement(im>threshold);

CC = bwconncomp(bw_th);
for i=1:numel(CC.PixelIdxList)
    boyutlar2(i) = size(CC.PixelIdxList{i},1);
end
[index_ise_yaramayan,index2] = maxk(boyutlar2,2);
im_mask(CC.PixelIdxList{1,index2(1)}) = 1;
im_desired = uint8(im_mask.*double(im));
im_desired(im_desired==0) = 255;
end