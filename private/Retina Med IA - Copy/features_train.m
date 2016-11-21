function [Feature, Label] = features_train(images, layerMaps)
Feature=[];
Label=[];
for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
                feature = Tissue_features(I);
                label = Index_label(I,L);
                label = label(:);
                feature(label==0,:)=[];    % removing unannotated pixels
                label(label==0)=[];
                
                sample1 = sum(label==1);   % # of samples for each class
                sample2 = sum(label==2);
                sample3 = sum(label==3);
                sample4 = sum(label==4);
 
                data = sortrows([label,feature],1); % Sorting concatenated features and label based on labels
                clear 'feature' 'label'             % Clearing unwanted data
                d1 = data(1:sample1,:);             % Grouping samples from same class
                data(1:sample1,:)=[];
                d2 = data(1:sample2,:);
                data(1:sample2,:)=[];
                d3 = data(1:sample3,:);
                data(1:sample3,:)=[];
                d4 = data(1:sample4,:);
                clear 'data'
                
                r1 = randperm(size(d1,1),sample3);
                r2 = randperm(size(d2,1),sample3);
                r4 = randperm(size(d4,1),sample3);
                
                r1=sort(r1);
                r2=sort(r2);
                r4=sort(r4);
                d1_temp = [];
                d2_temp = [];
                d4_temp = [];
                
                for Idx = 1:length(r1)
                    d1_temp = [d1_temp;d1(r1(Idx),:)];
                    d2_temp = [d2_temp;d2(r2(Idx),:)];
                    d4_temp = [d4_temp;d4(r4(Idx),:)];
                    
                end
                d1 = d1_temp;
                d2 = d2_temp;
                d4 = d4_temp;
                
%                 d1 = datasample(d1,sample3);        % To avoid bias towards a group 'n' number of samples are randomly sampled 
%                 d2 = datasample(d2,sample3);        % Where n = samples3  which is group with least # of examples
%                 d4 = datasample(d4,sample3);
                 
                Feature = [Feature;[d1(:,2:end);d2(:,2:end);d3(:,2:end);d4(:,2:end)]];
                Label = [Label;[d1(:,1);d2(:,1);d3(:,1);d4(:,1)]];
 
           end
end