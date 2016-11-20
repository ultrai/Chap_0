function [Out Out2 Idx_image] = Image_Result_chen(Probability,Image)
Idx_image = size(Probability,2)-[1:size(Probability,1)]'*ones(1,size(Probability,2));
attenuation = atten(Image);
attenuation = 1-attenuation;
Probability=mat2gray(Probability.*attenuation);

mask = Probability>(max(Probability(:))*0.8);
if sum(mask(:))<10000
    mask = (Probability)>(max(Probability(:))*0.6);
end
    
if sum(mask(:))>10000
mask_temp = bwareaopen(mask,200);
if sum(mask_temp(:))>10000
    mask=mask_temp;
end
end
Out_temp = chenvese_trial1(Probability,mask,50,0.7,'Chan');
if sum(Out_temp(:))>10000
    Out = Out_temp;
else Out = mask;
end
area =0 ;
[L n] = bwlabel(Out);
for temp =1:n
    A = sum(sum(L ==temp));
    if A>area
        area = A;
        object = temp;
    end
end
Out = L==object;
%Out = bwareaopen(Out,500);


y = size(Probability,2)-max(Idx_image.*Out);
y(y==size(Probability,2))=0;
x = [1:size(Probability,2)];
y = spline(x(1:5:length(x)),y(1:5:length(x)),x);
% y = smooth(x,y,1,'rloess');

x(y==0)=[];
y(y==0)=[];
%[y x]=find(Out-imerode(Out,strel('disk',1)));
% [smth,x, y] = interate(Probability, x', y', 0.8, 0.2,1, 1, 1, 1, 1, 50);
% figure, imshow(smth);
R = Image;
G = Image;
B = Image;
Idx_image = zeros(size(R));
y=round(y);
x=round(x);
for col =1:length(x)
if y(col)>0*x(col)>0    
Idx_image(y(col),x(col)) = 255;
end
end
Idx_image=Idx_image>0;
Idx_image = bwareaopen(Idx_image,3);
Idx_image = imdilate(Idx_image,strel('disk',3));
R(Idx_image) = 255;
G(Idx_image) = 0;
B(Idx_image) = 0;
Out2 = cat(3,R,G,B);

end
