function Out = large(BW)
[L,n] = bwlabel(BW);
Area = 0;
if n~=0
    for object = 1:n
        object_temp = L==object;
        area = sum(object_temp(:));
        if area > Area
            Area = area;
            Out = object_temp;
        end
    end
else  Out = BW;
     
end
