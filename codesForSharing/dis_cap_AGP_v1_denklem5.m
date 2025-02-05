function [cap] = dis_cap_AGP_v1_denklem5(BW,th,esik)
%UNTİTLED2 denklem2 ile aynı sadece eşik değerleri
%calibration_for_subpixel_counting.m fonksiyonundan otomatik olarak
%gelmektedir.

BW = imfill(imcomplement(BW));
bw_th=imcomplement( imcomplement(BW) > th);
%bw_th_filled = imfill(imcomplement(bw_th),'holes');
CC = bwconncomp(bw_th);


for i=1:numel(CC.PixelIdxList)
    boyutlar2(i) = size(CC.PixelIdxList{i},1);
end
[index_ise_yaramayan,index2] = maxk(boyutlar2,2);

BW = imcomplement(BW);
degerler = BW(CC.PixelIdxList{index2(1)});
part1 = sum(degerler<esik); 
degerler(degerler<esik) = 0;
normalizasyon = 1 - ((single(degerler)-esik)/(th-esik));

normalizasyon(normalizasyon<0) = 0;
normalizasyon(normalizasyon>1) = 0;
part2 = sum(normalizasyon);

indeksler = single(CC.PixelIdxList{index2(1)}) .* single(normalizasyon>0);
indeksler = indeksler(indeksler~=0);


Toplam_Alan = part1+part2;
cap = sqrt(Toplam_Alan/pi)*2;
end

