function [M]=fmask(n)

% functionality:here we construct the fractional mask using Left weighted 
%               integral concept of bspc paper as per the scheme of
%               arrangement of coefficients depicted in cssp paper.
% reference    :anil brother's bspc paper
% usage        :input-n,output-M is the required mask of order n+1 x n+1              
% author       :varun makkar
% date         :01-10-21

% CREATING THE FRACTIONAL MASK
a=0.85;
alpha=0.08;
% n=4; % order of the mask is n+1
d=2*(a^alpha)*gamma(alpha); % denominator, intermediatory variable 
syms x;

% C:coefficients
% D:intermediatory variable
% M:mask
% F:filtered image

C(1)=int(exp(-x)*x^(alpha-1),0,a)/d;
C(2)=int(exp(-x)*x^(alpha-1),0,2*a)/d;
C(n+1)=(int(exp(-x)*x^(alpha-1),0,n*a) - int(exp(-x)*x^(alpha-1),0,(n-1)*a))/d ;
for k=2:n-1
    C(k+1)=(int(exp(-x)*x^(alpha-1),0,a*(k+1))-int(exp(-x)*x^(alpha-1),0,a*(k-1)))/d ;
end
C=eval(C);

for i=1:n+1
    D(i)=C(i)+C(n+2-i);
end

M=zeros(n+1);
M((n/2)+1,:)=D;
M(:,(n/2)+1)=M(:,(n/2)+1)+transpose(D);
for i=1:n+1
    M(i,i)=M(i,i)+D(i);
end

for i=1:n+1
    M(n+2-i,i)=M(n+2-i,i)+D(i);
end
M=M/sum(M(:));
% % APPLYING THE FMASK ON THE IMAGE 
% 
% % A: image to be filtered
% % B: zero padded A
% % F: fractional filtered image, F and A are of same size
% % r,c: size of A
% % t1,t2: intermediary variables
% 
% [r c]=size(A);
% order=n+1; % order of the fmask is n+1 x n+1
% t1=floor(order/2);
% 
% B=zeros(r+2*t1,c+2*t1);
% B(t1+1:r+t1,t1+1:c+t1)=A; %Now B is the zero padded image A
% 
% for i=t1+1:r+t1
%     for j=1+t1:c+t1
%         t2=B(i-t1:i+t1,j-t1:j+t1);
%         F(i-t1,j-t1)=sum(sum(M.*t2));
%     end
% end
