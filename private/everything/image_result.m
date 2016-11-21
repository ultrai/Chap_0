
function OUT = image_result(image,Pred)
    image = uint8(image*255);
    R=255*ones(size(Pred));
    G=R;
    B=R;

    R(Pred==1)=0;
    G(Pred==1)=150;
    B(Pred==1)=255;

    R(Pred==2)=255;
    G(Pred==2)=0;
    B(Pred==2)=0;

    R(Pred==3)=0;
    G(Pred==3)=255;
    B(Pred==3)=0;

    R(Pred==4)=255;
    G(Pred==4)=0;
    B(Pred==4)=255;
    R=double(R);
    G=double(G);
    B=double(B);

    %OUT = cat(3,R,G,B);


 Rfinal=image.*(uint8(Pred<0))+uint8(mat2gray(im2double(image)).*R);
 Gfinal=image.*(uint8(Pred<0))+uint8(mat2gray(im2double(image)).*G);
 Bfinal=image.*(uint8(Pred<0))+uint8(mat2gray(im2double(image)).*B);
 
 OUT = cat(3,Rfinal,Gfinal,Bfinal);
end