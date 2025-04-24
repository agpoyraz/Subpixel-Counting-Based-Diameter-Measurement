function [alt_th,ust_th,im_filled] = determine_thresholds(im_filled,edge_method,average_type)
% calibration_for_subpixel_counting
% 
% This function must be executed before running the subpixel counting 
% method. It is designed to automatically determine the lower and upper 
% threshold values required for edge transition analysis.
%
% The algorithm operates by first detecting the largest connected component 
% in the input image. Then, the derivatives of all rows and columns are 
% computed to analyze intensity transitions. The points with the maximum 
% gradient changes are identified, and the intensity values at those points 
% are used to determine the threshold levels.
%
% The function returns both lower and upper bounds for the transition regions.
% It is normal for the upper threshold to approach 255, as the most significant 
% intensity changes typically occur around this maximum intensity level. 
% However, for full automation and robustness, this value is dynamically 
% computed within the function.
%
% The final output includes the positions of the maximum intensity changes, 
% which are critical for accurate diameter measurement using subpixel 
% edge detection.

%numberofmaxk = 9;
%average_type = 'median';%mean, median, max
if strcmp(edge_method,'intermediate')
    
    [Gx,Gy] =  imgradientxy(im_filled,'intermediate'); %intermediate,sobel,robert,previtt
    [yatay_max,yatay_max_index] = max(abs(Gx),[],2);
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
end



end
