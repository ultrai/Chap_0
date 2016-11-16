function [Out Out2 Idx_image] = Image_Result_chen2(Probability,Image)
Idx_image = size(Probability,2)-[1:size(Probability,1)]'*ones(1,size(Probability,2));
mask = Probability>0.8;
mask = bwareaopen(mask,200);
Out = chenvese_trial1(Probability,mask,50,0.7,'Chan');
Out = bwareaopen(Out,500);


y = size(Probability,2)-max(Idx_image.*Out);
y(y==size(Probability,2))=0;
x = [1:size(Probability,2)];
y = spline(x,y,x);
y = smooth(x,y,1,'rloess');

% x(y==0)=[];
% y(y==0)=[];
% [smth,x, y] = interate(Probability, x, y', 0.8, 0.2,1, 1, 1, 1, 1, 50);
% figure, imshow(smth);
R = Image;
G = Image;
B = Image;
Idx_image = zeros(size(R));
for col =1:size(Image,2)
if y(col)>0
Idx_image(y(col),col) = 255;
end
end
Idx_image=Idx_image>0;
Idx_image = imdilate(Idx_image,strel('disk',3));
R(Idx_image) = 255;
G(Idx_image) = 0;
B(Idx_image) = 0;
Out2 = cat(3,R,G,B);

end
