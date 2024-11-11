function [SI]=hyst_thd_4RVS(I)

% functionality: to perform hysteresis thresholding on the input image I.
% caution      : assumes that I is double 2d matrix with values in the
%                range 0 to 1. modified to work on the full range of I.

% [r c] = size(I);
% [counts bins] = imhist(I);
% ThresholdRatio = 0.90;
% Percentage_of_nonvessel_pixels = 0.93;
% 
% t1 = find(cumsum(counts) > Percentage_of_nonvessel_pixels*r*c,1,'first');
% highThresh = bins(t1);    
% lowThresh = ThresholdRatio*highThresh;

% thresholds for drive dataset
highThresh=0.6134;
lowThresh=0.5834;

% % thresholds for stare dataset
% highThresh=0.8328;
% lowThresh=0.7428;

% % thresholds for chasedb1 dataset
% highThresh=0.7528;
% lowThresh=0.7528;

% % thresholds for rcslo dataset
% highThresh=0.9928;
% lowThresh=.7928;


F = imbinarize(I,highThresh);
G = imbinarize(I,lowThresh); 
SI=geodesic_dilation(F,G,inf);
