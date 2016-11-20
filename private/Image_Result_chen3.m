function [Out Out2 Idx_image] = Image_Result_chen3(Probability,Image)
Idx_image = [1:size(Probability,1)]'*ones(1,size(Probability,2));
Out = chenvese_trial1(Probability,Probability>0.8,50,0.7,'Chan');
y = max(Idx_image.*Out);
y(y==size(Probability,2))=0;
x = [1:size(Probability,2)];
y = spline(x,y,x);
y = smooth(x,y,1,'rloess');

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
