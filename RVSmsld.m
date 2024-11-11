function [D , B]=RVSmsld(A,Msk)
%function [B]=RVSmsld(A,Msk)

% functionality: segmentation of Retinal Blood Vessels 
% author       : varun makkar
% date         : 13-06-2022
% usage        : input the original RGB fundus image-A, and the image 
%                mask-Msk.output-D is the final segmented image returned
%                as logical data type and B-the response image generated
%                using line detectors.


% -----VARIABLES USED-----
% A: RGB fundus image
% Msk: mask to do the processing efficiently in just the ROI
% B: average response image(after standardisation)
% D: the final segmented image
% MLR: contains the modified line response for each length in "Lengths"
% M,C: intermediary image variables
% Ws: max window size(W in the reference paper)
% Lengths: the modified line responses are computed for each length in this
%          vector "Lengths"

% GRAY SCALE CONVERSION
A=A(:,:,2); % simply using the green channel
if ndims(Msk)==3
    Msk=im2bw(Msk(:,:,2));
end
A=im2double(A);
Msk=im2double(Msk);

% PREPROCESSING
A=imcomplement(A); % reminder:this algo works on the inverted green channel,
                   % basically making vessel profiles as local maxima.
% denoising                    
bspc_filter=fmask(2); %3x3 filter
A = imfilter(A,bspc_filter);
% contrast enhancement, applying CLAHE
A=adapthisteq(A,'clipLimit',0.02,'Distribution','rayleigh');
% erode the mask to avoid weird region near the border.
A=fakepad(A,Msk);

% COMPUTING THE MODIFIED LINE RESPONSES FOR L=1:2:Ws
Ws=15; % the max window size is denoted as W in the paper
Lengths=1:2:Ws; % the modified line responses are computed for each length in this vector "Lengths"
for i=1:numel(Lengths) 
    L=Lengths(i);
    MLR{i}=lineresponse3(A,L,Ws);
end

% STANDARDIZATION OF THE MODIFIED LINE RESPONSES AND 'A'
B=zeros(size(A));
for i=1:numel(Lengths) 
    MLR{i}=standardize_the_image(MLR{i},Msk);
    B=B+MLR{i};
end
A=standardize_the_image(A,Msk);
B=(B+A)/(numel(Lengths)+1); % taking the average of all the responses and the image
%figure,imshow(B)
% HYSTERESIS THRESHOLDING: TO GET THE SEGMENTED VESSELES
%as of now hyst_thd, is designed to work for images with intensity in [0,1]
%but now we have modified it to work on the full range of B
C=hyst_thd_4RVS(B); 

% POSTPROCESSING
D=postprocessing(C);