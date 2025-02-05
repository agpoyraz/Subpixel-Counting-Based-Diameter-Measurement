function [alt_th,ust_th,im_filled] = calibration_for_subpixel_countingv2_nopreprocessing(im_filled,th,edge_method,numberofmaxk,average_type)
%calibration_for_subpixel_counting, subpixel counting yöntemini
%çalıştırmadan önce alt ve üst eşik değerinin otomatik olarak
%belirlenebilmesi için bu kodu çalıştırılması gerekmektedir. 
%Kod içinde öncelikle en büyük connected component bulunur. Ardından bütün
%satır ve sütunların türevi alınır. geçişin en büyük olduğu noktalar
%belirlenerek geçişin ortaya çıktığı ışık değeri(eşik) bulunur. Bize hem
%alt hem üst sınır bölgelerini verir. Üst sınır için 255 üretmesi
%normaldir. Çünkü 255'in değişti noktada maksimum değişkenlik ortaya çıkar.
%Ancak yine de kodun otomatikleştirilmesi açısından kod içerisinde
%üretilmesi gerekir.
% Max farkı veren konumlar alınır.
%   Detailed explanation goes here

%numberofmaxk = 9;
%average_type = 'median';%mean, median, max
if strcmp(edge_method,'intermediate')
    
    [Gx,Gy] =  imgradientxy(im_filled,'intermediate'); %intermediate,sobel,robert,previtt
    [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
    [max_farklar,max_farklarin_konumu] = maxk(yatay_max,numberofmaxk);
    max_farklarin_konumu = find(yatay_max==max(yatay_max));
        
    for i=1:numel(max_farklarin_konumu) 
        degerler_alt = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i)));
        degerler_ust = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))+1);
        if degerler_alt>degerler_ust
            temp = degerler_alt;
            degerler_alt = degerler_ust;
            degerler_ust = temp;
        end
        degerler_alt_dizi_x(i) = degerler_alt;
        degerler_ust_dizi_x(i) = degerler_ust;
    end
    [dusey_max,dusey_max_index] = max(abs(Gy));
    [max_farklar,max_farklarin_konumu] = maxk(dusey_max,numberofmaxk);
    max_farklarin_konumu = find(dusey_max==max(dusey_max));
    for j=1:numel(max_farklarin_konumu)
        degerler_alt = im_filled(dusey_max_index(max_farklarin_konumu(j)),max_farklarin_konumu(j));
        degerler_ust = im_filled(dusey_max_index(max_farklarin_konumu(j))+1,max_farklarin_konumu(j));
        if degerler_alt>degerler_ust
            temp = degerler_alt;
            degerler_alt = degerler_ust;
            degerler_ust = temp;
        end
        degerler_alt_dizi_y(j) = degerler_alt;
        degerler_ust_dizi_y(j) = degerler_ust;
    end
    
    if strcmp(average_type,'mean')
        alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/(numel(degerler_alt_dizi_y)+numel(degerler_alt_dizi_x)));
        ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/(numel(degerler_alt_dizi_y)+numel(degerler_alt_dizi_x)));
    end
    if strcmp(average_type,'median')
        alt_th = single(median([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(median([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    if strcmp(average_type,'max')
        alt_th = single(max([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(max([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    if strcmp(average_type,'max-min')
        alt_th = single(min([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(max([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    %sort([degerler_alt_dizi_x degerler_alt_dizi_y])
    %sort([degerler_ust_dizi_x degerler_ust_dizi_y])
end



if strcmp(edge_method,'prewitt') || strcmp(edge_method,'sobel') || strcmp(edge_method,'central') 
    
    [Gx,Gy] =  imgradientxy(im_filled,edge_method); %intermediate,sobel,central,previtt
    [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
    [max_farklar,max_farklarin_konumu] = maxk(yatay_max,numberofmaxk);
    max_farklarin_konumu = find(yatay_max==max(yatay_max));

    for i=1:numel(max_farklarin_konumu)
        degerler_alt = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))-1);
        degerler_ust = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))+1);
        if degerler_alt>degerler_ust
            temp = degerler_alt;
            degerler_alt = degerler_ust;
            degerler_ust = temp;
        end
        degerler_alt_dizi_x(i) = degerler_alt;
        degerler_ust_dizi_x(i) = degerler_ust;
    end
    [dusey_max,dusey_max_index] = max(abs(Gy));
    [max_farklar,max_farklarin_konumu] = maxk(dusey_max,numberofmaxk);
    max_farklarin_konumu = find(dusey_max==max(dusey_max));
    for j=1:numel(max_farklarin_konumu)
        try
        degerler_alt = im_filled(dusey_max_index(max_farklarin_konumu(j))-1,max_farklarin_konumu(j));
        degerler_ust = im_filled(dusey_max_index(max_farklarin_konumu(j))+1,max_farklarin_konumu(j));
        catch
            j=88;
        end
        if degerler_alt>degerler_ust
            temp = degerler_alt;
            degerler_alt = degerler_ust;
            degerler_ust = temp;
        end
        degerler_alt_dizi_y(j) = degerler_alt;
        degerler_ust_dizi_y(j) = degerler_ust;
    end
    if strcmp(average_type,'mean')
        alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/(numel(degerler_alt_dizi_y)+numel(degerler_alt_dizi_x)));
        ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/(numel(degerler_alt_dizi_y)+numel(degerler_alt_dizi_x)));
    end
    if strcmp(average_type,'median')
        alt_th = single(median([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(median([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    if strcmp(average_type,'max')
        alt_th = single(max([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(max([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    if strcmp(average_type,'max-min')
        alt_th = single(min([degerler_alt_dizi_x degerler_alt_dizi_y]));
        ust_th = single(max([degerler_ust_dizi_x degerler_ust_dizi_y]));
    end
    %sort([degerler_alt_dizi_x degerler_alt_dizi_y])
    %sort([degerler_ust_dizi_x degerler_ust_dizi_y])
end
a(1,:) = degerler_ust_dizi_x;
a(2,:) = degerler_alt_dizi_x;
a(3,:) = degerler_ust_dizi_x - degerler_alt_dizi_x;
b=a;
% if strcmp(edge_method,'central')
%     [im_desired] = eliminate_small_objects(BW,th);
%     im_filled = imcomplement(imfill(imcomplement(im_desired)));
%     [Gx,Gy] =  imgradientxy(im_filled,edge_method); %intermediate,sobel,central,previtt
%     [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
%     [max_farklar,max_farklarin_konumu] = maxk(yatay_max,5);
% 
%     for i=1:5
%         degerler_alt = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))-1);
%         degerler_ust = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))+1);
%         if degerler_alt>degerler_ust
%             temp = degerler_alt;
%             degerler_alt = degerler_ust;
%             degerler_ust = temp;
%         end
%         degerler_alt_dizi_x(i) = degerler_alt;
%         degerler_ust_dizi_x(i) = degerler_ust;
%     end
%     [dusey_max,dusey_max_index] = max(abs(Gy));
%     [max_farklar,max_farklarin_konumu] = maxk(dusey_max,5);
%     for j=1:5
%         degerler_alt = im_filled(dusey_max_index(max_farklarin_konumu(j))-1,max_farklarin_konumu(j));
%         degerler_ust = im_filled(dusey_max_index(max_farklarin_konumu(j))+1,max_farklarin_konumu(j));
%         if degerler_alt>degerler_ust
%             temp = degerler_alt;
%             degerler_alt = degerler_ust;
%             degerler_ust = temp;
%         end
%         degerler_alt_dizi_y(j) = degerler_alt;
%         degerler_ust_dizi_y(j) = degerler_ust;
%     end
%     alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/10);
%     ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/10);
% end
% 
% 
% if strcmp(edge_method,'sobel')
%     [im_desired] = eliminate_small_objects(BW,th);
%     im_filled = imcomplement(imfill(imcomplement(im_desired)));
%     [Gx,Gy] =  imgradientxy(im_filled,edge_method); %intermediate,sobel,central,previtt
%     [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
%     [max_farklar,max_farklarin_konumu] = maxk(yatay_max,5);
% 
%     for i=1:5
%         degerler_alt = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))-1);
%         degerler_ust = im_filled(max_farklarin_konumu(i),yatay_max_index(max_farklarin_konumu(i))+1);
%         if degerler_alt>degerler_ust
%             temp = degerler_alt;
%             degerler_alt = degerler_ust;
%             degerler_ust = temp;
%         end
%         degerler_alt_dizi_x(i) = degerler_alt;
%         degerler_ust_dizi_x(i) = degerler_ust;
%     end
%     [dusey_max,dusey_max_index] = max(abs(Gy));
%     [max_farklar,max_farklarin_konumu] = maxk(dusey_max,5);
%     for j=1:5
%         degerler_alt = im_filled(dusey_max_index(max_farklarin_konumu(j))-1,max_farklarin_konumu(j));
%         degerler_ust = im_filled(dusey_max_index(max_farklarin_konumu(j))+1,max_farklarin_konumu(j));
%         if degerler_alt>degerler_ust
%             temp = degerler_alt;
%             degerler_alt = degerler_ust;
%             degerler_ust = temp;
%         end
%         degerler_alt_dizi_y(j) = degerler_alt;
%         degerler_ust_dizi_y(j) = degerler_ust;
%     end
%     alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/10);
%     ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/10);
% end

end
