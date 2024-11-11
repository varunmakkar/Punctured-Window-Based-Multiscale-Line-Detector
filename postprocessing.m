function PI=postprocessing(SI)

% functionality: perform the post processing steps to eradicate small
%                noisy segments
% reference    : IET Image Processing, Improved multi scale line detection
%                method for retinal blood vessel segmentation
% usage        : input the binary sgmented image-SI, output-PI is the result
%                of post processing


% cc.PixelIdxList{i} contains the linear indices of the 4-connected components in SI
cc=bwconncomp(SI,4); 

% compute 'MajorAxisLength'& 'EquivDiameter' for each connected component in cc
stats = regionprops('table',cc,'MajorAxisLength','EquivDiameter');
ed = stats.EquivDiameter;
ma = stats.MajorAxisLength;
circ = ed./ma; % degree of circularity of each connected component

minpoints=30; % threshold to discard c-components with size less than minpoints
cT = 0.4;   % cicularity threshold
for i = 1:numel(circ)
    circularity = circ(i);
    if circularity > cT || numel(cc.PixelIdxList{i}) < minpoints
        SI(cc.PixelIdxList{i}) = 0;
    end
end

% closing operation-to fill up small gaps within the thick vessels
se=strel("disk",1); 
PI=imclose(SI, se);
% % alternatively- fill small holes 
% t1=imfill(PI,"holes") - PI;  % image with all the holes
% t2=bwareaopen(t1,150,8); % image with holes of size more that __ pixels only
% t3=t1-t2; % image with holes of size less that __ pixels only
% PI=PI | t3;
