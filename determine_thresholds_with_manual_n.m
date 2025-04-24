function [alt_th,ust_th,im_filled] = determine_thresholds_with_manual_n(BW,th,edge_method,numberofmaxk,average_type)
% calibration_for_subpixel_counting_manual
%
% This function is a manual alternative to the automated threshold calibration 
% process used in the subpixel counting method. Unlike the fully automatic version, 
% this implementation requires the user to manually specify the number of maximum 
% derivative points (`numberOfMaxK`) to consider during calibration.
%
% The function identifies the largest connected component in the input image, 
% then computes the derivatives across all rows and columns. Based on the 
% user-defined `numberOfMaxK` parameter, it selects the top-K strongest intensity 
% transitions to estimate the lower and upper threshold values.
%
% While this version allows for more control and experimentation with the sensitivity 
% of the threshold selection, it requires careful tuning of the `numberOfMaxK` value 
% to ensure accurate subpixel diameter measurement.
%
% Output includes the estimated transition thresholds and the positions of the 
% strongest gradient changes based on the specified number of transitions.

%numberofmaxk = 9;
%average_type = 'median';%mean, median, max
if strcmp(edge_method,'intermediate')
    [im_desired] = eliminate_small_objects(BW,th);
    im_filled = imcomplement(imfill(imcomplement(im_desired)));
    [Gx,Gy] =  imgradientxy(im_filled,'intermediate'); %intermediate,sobel,robert,previtt
    [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
    [max_farklar,max_farklarin_konumu] = maxk(yatay_max,numberofmaxk);
    
    for i=1:numberofmaxk
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
    for j=1:numberofmaxk
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
        alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/(numberofmaxk*2));
        ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/(numberofmaxk*2));
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
%     sort([degerler_alt_dizi_x degerler_alt_dizi_y])
%     sort([degerler_ust_dizi_x degerler_ust_dizi_y])
end



if strcmp(edge_method,'prewitt') || strcmp(edge_method,'sobel') || strcmp(edge_method,'central') 
    [im_desired] = eliminate_small_objects(BW,th);
    im_filled = imcomplement(imfill(imcomplement(im_desired)));
    [Gx,Gy] =  imgradientxy(im_filled,edge_method); %intermediate,sobel,central,previtt
    [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
    [max_farklar,max_farklarin_konumu] = maxk(yatay_max,numberofmaxk);

    for i=1:numberofmaxk

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
    for j=1:numberofmaxk
        degerler_alt = im_filled(dusey_max_index(max_farklarin_konumu(j))-1,max_farklarin_konumu(j));
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
        alt_th = round((sum(degerler_alt_dizi_y) + sum(degerler_alt_dizi_x))/(numberofmaxk*2));
        ust_th = round((sum(degerler_ust_dizi_y) + sum(degerler_ust_dizi_x))/(numberofmaxk*2));
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
end

end
