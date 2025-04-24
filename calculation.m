function [diameter] = calculation(BW,upper_th,bottom_th)

BW = imfill(imcomplement(BW)); % this step can be removed according to your image

bw_th=imcomplement( imcomplement(BW) > upper_th);
%bw_th_filled = imfill(imcomplement(bw_th),'holes');
CC = bwconncomp(bw_th);


for i=1:numel(CC.PixelIdxList)
    boyutlar2(i) = size(CC.PixelIdxList{i},1);
end
[index_ise_yaramayan,index2] = maxk(boyutlar2,2);

BW = imcomplement(BW);
degerler = BW(CC.PixelIdxList{index2(1)});
part1 = sum(degerler<bottom_th); 
degerler(degerler<bottom_th) = 0;
normalizasyon = 1 - ((single(degerler)-bottom_th)/(upper_th-bottom_th));

normalizasyon(normalizasyon<0) = 0;
normalizasyon(normalizasyon>1) = 0;
part2 = sum(normalizasyon);

total_area = part1+part2;
diameter = sqrt(total_area/pi)*2;
end

