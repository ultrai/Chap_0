function final = image_present2(I,L)
%  I= image_example;
%  L = L_pred';
    %% Smoothening of contour
        x = [1:1000]';
        y = L(:,1);
        y(isnan(y)) = 0;
        f = fit(x, y, 'smoothingspline','SmoothingParam', 0.6);
        L(:,1) = round(f(x));
        y = L(:,2);
        y(isnan(y)) = 0;
        f = fit(x, y, 'smoothingspline','SmoothingParam', 0.6);
        L(:,2) = round(f(x));
        y = L(:,3);
        y(isnan(y)) = 0;
        f = fit(x, y, 'smoothingspline','SmoothingParam', 0.6);
        L(:,3) = round(f(x));
        
    %% Actual implementation
    R=1;
    s = size(I);
    label = zeros(s);
    for col = 1:s(2)
    if L(col,1)>0&&L(col,2)>0 && L(col,3)>0
        
        label(1:(L(col,1)-1),col) = 1;
        label(L(col,1):(L(col,2)-1),col) = 2;
        label(L(col,2):(L(col,3)-1),col) = 3;
        label(L(col,3):end,col) = 4;
    end
    end
    I = mat2gray(I);
    I_1 = I(:,1:500);
    I_2 = I(:,501:end);
    L_2 = label(:,501:end);

    contour_1(:,:,1) = I_1;
    contour_1(:,:,2) = I_1;
    contour_1(:,:,3) = I_1;

    for col = 1:500
    if L(col,1)>R&&L(col,2)>R && L(col,3)>R
        contour_1((L(col,1)-R):(L(col,1)+R),col,1) = 0;
        contour_1((L(col,1)-R):(L(col,1)+R),col,2) = 150;
        contour_1((L(col,1)-R):(L(col,1)+R),col,3) = 255;
        
        contour_1((L(col,2)-R):(L(col,2)+R),col,1) = 255;
        contour_1((L(col,2)-R):(L(col,2)+R),col,2) = 0;
        contour_1((L(col,2)-R):(L(col,2)+R),col,3) = 0;
        
        contour_1((L(col,3)-R):(L(col,3)+R),col,1) = 0;
        contour_1((L(col,3)-R):(L(col,3)+R),col,2) = 255;
        contour_1((L(col,3)-R):(L(col,3)+R),col,3) = 0;
    end
    end
    contour_1 = uint8(contour_1*255);
    OUT = image_result(I_2, L_2);
    %figure,imshow(OUT)
    final(:,:,1) =  [contour_1(:,:,1) OUT(:,:,1)];
    final(:,:,2) =  [contour_1(:,:,2) OUT(:,:,2)];
    final(:,:,3) =  [contour_1(:,:,3) OUT(:,:,3)];
end