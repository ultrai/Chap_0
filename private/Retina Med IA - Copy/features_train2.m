function [Feature, Label] = features_train2(images, layerMaps)
% Kmeans clustering for selection of samples
Feature=[];
Label=[];
for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
               tic
                feature = Tissue_features(I);
                label = Index_label(I,L);
                label = label(:);
                feature(label==0,:)=[];    % removing unannotated pixels
                label(label==0)=[];
                
                sample1 = sum(label==1);   % # of samples for each class
                sample2 = sum(label==2);
                sample3 = sum(label==3);
                sample4 = sum(label==4);
 
%                 d1 = feature;
%                 d2 = feature;
%                 d3 = feature;
%                 d4 = feature;
%                 d1(label~=1,:)=[];
%                 d2(label~=2,:)=[];
%                 d3(label~=3,:)=[];
%                 d4(label~=4,:)=[];
                
                
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
                sample3
                if stack<51
                sample3 = stack*10;
                else sample3 = (50-(stack-50))*10;
                end
                d1_Idx = d1(1:sample3,1);
                d2_Idx = d2(1:sample3,1);
                d3_Idx = d3(1:sample3,1);
                d4_Idx = d4(1:sample3,1);
% d1_Idx = 1*ones(sample3,1);%
% d2_Idx = 2*ones(sample3,1);%
% d3_Idx = 3*ones(sample3,1);%
% d4_Idx = 4*ones(sample3,1);%
toc
                tic
                [~,d1] = kmeans(d1(:,2:end),sample3);
                [~,d2] = kmeans(d2(:,2:end),sample3);
                [~,d3] = kmeans(d3(:,2:end),sample3);
                [~,d4] = kmeans(d4(:,2:end),sample3);
                stack
                toc
                Feature = [Feature;[d1;d2;d3;d4]];
                Label = [Label;[d1_Idx;d2_Idx;d3_Idx;d4_Idx]];
 
           end
end