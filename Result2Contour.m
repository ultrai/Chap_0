function Contour = Result2Contour(Result, Value)
BW = Result ==Value;
Idx_image = [1:size(Result,1)]'*ones(1,size(Result,2));
Sx = [-1;1];
Edge = conv2(double(BW),Sx,'same');
Edge = Edge>0;
Edge = bwareaopen(Edge,10);
[L n] = bwlabel(Edge);
area = [];
for Idx = 1:n
    BW_temp = L==Idx;
    area = [area;[sum(BW_temp(:)) Idx]];
end
area = sortrows(area);
Edge_temp = zeros(size(Edge));
for Idx = size(area,1):-1:round(size(area,1)*0.5)
        
     Edge_temp = Edge_temp +( L==area(Idx,2));
    
end
figure,imshow(Edge_temp)


[y x] = find(Edge_temp);
Result=mat2gray(Result);
[smth] = interate(cat(3,Result,Result,Result), x, y, 0.5, 0.5, 0.5, 0.5, 1, 1, 1,100);
Contour = [y x];
%%
 Result_temp = zeros(size(Result));
 Strip = find(Result(1,:));
 xx = [min(Strip):max(Strip)];
 yy = spline(x,y,xx);
% yy=round(yy);
% for temp = 1:length(yy)
%     Result_temp(yy(temp),xx(temp)) = 1;
% end
% figure,imshow(Result_temp)
% 
