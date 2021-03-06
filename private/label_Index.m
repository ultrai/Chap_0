function L = label_Index(label)
L1 = label==1;
L2 = label==2;
L3 = label==3;
L4 = label==4;
s = size(label);
L2 = imfill(L2,'holes');
L2 = bwareaopen(L2,20);
layer_1 = zeros(1,s(2));
for temp = 1:s(2)
    A_s = L2(:,temp);
    row = find(A_s==1);
    if length(row)>1
        layer_1(temp) = min(row);
    else layer_1(temp) = 0;
    end
end

L3 = imfill(L3,'holes');
L3 = bwareaopen(L3,20);
layer_2 = zeros(1,s(2));
for temp = 1:s(2)
    A_s = L3(:,temp);
    row = find(A_s==1);
    if length(row)>1
        layer_2(temp) = min(row);
    else layer_2(temp) = 0;
    end
end

L4 = imfill(L4,'holes');
L4 = bwareaopen(L4,20);
layer_3 = zeros(1,s(2));
for temp = 1:s(2)
    A_s = L4(:,temp);
    row = find(A_s==1);
    if length(row)>1
        layer_3(temp) = min(row);
    else layer_3(temp) = 0;
    end
end
L = [layer_1;layer_2;layer_3];
end
