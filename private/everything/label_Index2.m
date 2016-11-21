function L = label_Index2(label)
L1 = label==1;
L2 = label==2;
L3 = label==3;
L4 = label==4;
s = size(label);

for temp = 1:10:s(2)
    L1_temp = L1(:,temp:temp+9);
    L1(:,temp:temp+9) = large (L1_temp);
    
    L2_temp = L2(:,temp:temp+9);
    L2(:,temp:temp+9) = large (L2_temp);
    
    L3_temp = L3(:,temp:temp+9);
    L3(:,temp:temp+9) = large (L3_temp);
    
    L4_temp = L4(:,temp:temp+9);
    L4(:,temp:temp+9) = large (L4_temp);
    
end

L1 = imfill(L1,'holes');
L2 = imfill(L2,'holes');
L3 = imfill(L3,'holes');
L4 = imfill(L4,'holes');

layer_1 = zeros(1,s(2));
for temp = 1:s(2)
    A_s = L2(:,temp);
    row = find(A_s==1);
    if length(row)>1
        layer_1(temp) = min(row);
    else layer_1(temp) = 0;
    end
end

layer_2 = zeros(1,s(2));
for temp = 1:s(2)
    A_s = L3(:,temp);
    row = find(A_s==1);
    if length(row)>1
        layer_2(temp) = min(row);
    else layer_2(temp) = 0;
    end
end

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
