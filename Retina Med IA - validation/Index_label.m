function label = Index_label(I,L)
s = size(I);
label = zeros(s);
for col = 1:s(2)
    if L(col,1)>0
        label(1:(L(col,1)-1),col) = 1;
        label(L(col,1):(L(col,2)-1),col) = 2;
        label(L(col,2):(L(col,3)-1),col) = 3;
        label(L(col,3):end,col) = 4;
    end
end
        
        
        