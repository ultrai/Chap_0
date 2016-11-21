function [Pred,Probab, Label] = features_test(images, layerMaps,b)

Label = zeros(512,1000,100);
Pred = zeros(512,1000,100);
Probab = {};
for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
                feature = Tissue_features(I);
                [pred, votes, prediction_pre_tree] = classRF_predict(feature,b);
                probab = votes(:,3)./((sum(votes'))');
                label = Index_label(I,L);
                label = label(:);
                label_temp = label>0;
                
                pred = pred.*label_temp;
                label = label.*label_temp;
                probab = probab.*label_temp;
                
                pred = reshape(pred,size(I));
                label = reshape(label,size(I));
           Probab = cat(1,Probab,probab);
           Label(:,:,stack) = label;
           Pred(:,:,stack) = pred;
           end
                     
end
end