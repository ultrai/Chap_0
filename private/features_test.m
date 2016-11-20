function [Pred,Probab,Probab2,Probab3, Label] = features_test(images, layerMaps,b)

Label = zeros(512,1000,100);
Pred = zeros(512,1000,100);
Probab = zeros(512,1000,100);
Probab2 = zeros(512,1000,100);
Probab3 = zeros(512,1000,100);

for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
                feature = Tissue_features(I);
                [pred, votes, prediction_pre_tree] = classRF_predict(feature,b);
                probab = votes(:,2)./((sum(votes'))');
                probab2 = votes(:,3)./((sum(votes'))');
                probab3 = votes(:,4)./((sum(votes'))');
                
                label = Index_label(I,L);
                label = label(:);
                label_temp = label>0;
                
                pred = pred.*label_temp;
                label = label.*label_temp;
                probab = probab.*label_temp;
                probab2 = probab2.*label_temp;
                probab3 = probab3.*label_temp;
                
                pred = reshape(pred,size(I));
                probab = reshape(probab,size(I));
                probab2 = reshape(probab2,size(I));
                probab3 = reshape(probab3,size(I));
                label = reshape(label,size(I));
           
           Label(:,:,stack) = label;
           Probab(:,:,stack) = probab;
           Probab2(:,:,stack) = probab2;
           Probab3(:,:,stack) = probab3;
           Pred(:,:,stack) = pred;
           end
                     
end
end