function Feature=Tissue_features(I)
Scale=7;
Feature=[];
for level = 2:Scale+1
    Mask_l = 2^(level-1)-1;
    h = fspecial('average', [Mask_l Mask_l]);
    h = gpuArray(h);
      feature_1 = gather(conv2(gpuArray(double(I)),h,'same'));
    feature_2 = ((gather(conv2(gpuArray(double(I).^2),h,'same'))-feature_1.^2).^0.5);
   
    Feature=[Feature feature_1(:) feature_2(:)];
end
 feature_3_norm = sum(I);
  A=[];
    for row = 1:size(I,1)
        Block = I(1:row,:);
        atenuation = sum(Block);
        A = [A;[1-atenuation./feature_3_norm]];
    end
    feature_3=A;  
    Feature=[Feature feature_3(:)];