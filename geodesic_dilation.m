function [t2]=geodesic_dilation(F,G,n)

% functionality: peform geodesic dilation as per Gonzalez
% usage        : input- F(marker image), G(mask image), n(size of geodesic dilation)
%                if it is a number the algo does the GEODESIC DILATION of 
%                that particular size, if it is "inf" the algo does 
%                MORPHOLOGICAL RECONSTRUCTION BY DILATION, output-O(result 
%                of geodesic dilation)
% references   : Gonzalez 4th edn
% date         : 16-08-22
% author       : varun makkar

% CAUTION REMINDER: F,G & O are binary images

% synthetic images for experimentation
% this example demonstrates the role of se used for connectivity purposes
% in geodesic dilation
% G=zeros(256);
% G(50:100,50:100)=1;
% G(101:150,101:150)=1;
% G=logical(G);
% 
% F=zeros(size(G));
% seed=256*70+50;
% F(seed)=1;
% F=logical(F);
% n=100;


c=8; % connectivity
% make sure that c(connectivity) is either 8 or 4
if c==8
    se=strel('square',3);
else
    se=strel('diamond',1);
end

t1=F;
t2=imdilate(F,se) & G;
if n<inf
    % geodesic dilation
    for i=1:n
        t1=t2;
        t2=imdilate(t1,se) & G;
        %imshow(t2);
    end
else
    % morphological reconstruction by dilation
    while ~isequal(t1 , t2)
        t1=t2;
        t2=imdilate(t1,se) & G;
        %imshow(t2);
    end
end
% figure,imshow(G);
% title('G');
% figure,imshow(F);
% title('F');