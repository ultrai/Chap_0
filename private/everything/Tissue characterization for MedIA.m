restoredefaultpath;matlabrc
clear all
close all
files='E:\Data\Retina OCT data from duke\';
files1 = dir(strcat(files,'OCT Retina\AMD\*.mat'));
files2 = dir(strcat(files,'OCT Retina\Control\*.mat'));
mkdir('D:\MedIA\AMD\AMD');
mkdir('Control');
no_AMD = numel(files1);
no_control = numel(files2);
%% Generate Fetures for normal case 
for Count = 1:no_control
    fprintf('Converting feature for control Count: %0.3f%%\n',Count)
      load([strcat(files,'OCT Retina\Control\'),files2(Count).name]);
      Feature_normal=[];
        Label_normal=[];

       for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
               feature = Tissue_features(I);
               label = Index_label(I,L);
               label = label(:);
               feature(label==0,:)=[];
               label(label==0)=[];
                Feature_normal = [Feature_normal;feature];
                Label_normal = [Label_normal;label];
           end
       end
       fprintf('\n Saving features.....')
       save(strcat('Control\',files2(Count).name),'Feature_normal','Label_normal','-v7.3');
        Feature_normal=[];
        Label_normal=[];

end

%% Generate Fetures for AMD case 
for Count = 1:230%1:no_AMD
    fprintf('Converting feature for AMD Count: %0.3f%%\n',Count)
      load([strcat(files,'OCT Retina\AMD\'),files1(Count).name]);
      Feature_AMD=[];
        Label_AMD=[];

       for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
               feature = Tissue_features(I);
               label = Index_label(I,L);
               label = label(:);
               feature(label==0,:)=[];
               label(label==0)=[];
                Feature_AMD = [Feature_AMD;feature];
                Label_AMD = [Label_AMD;label];
           end
       end
       fprintf('\n Saving features.....')
       save(strcat('D:\MedIA\AMD\',files1(Count).name),'Feature_AMD','Label_AMD','-v7.3');
        Feature_AMD=[];
        Label_AMD=[];

end
%% Train Forest
clear all

files1 = dir('D:\MedIA\AMD\*.mat');
files2 = dir('Control\*.mat');
no_AMD = numel(files1);
no_control = numel(files2);
Acc_Anterior = zeros(no_control);
Acc_RPE = zeros(no_control);
Acc_Posterior = zeros(no_control);
Sen_Anterior = zeros(no_control);
Sen_RPE = zeros(no_control);
Sen_Posterior = zeros(no_control);
Spe_Anterior = zeros(no_control);
Spe_RPE = zeros(no_control);
Spe_Posterior = zeros(no_control);
P=[];
L=[];
feature=[];
label=[];

for Count = 1:no_control
    fprintf('Training data set on : %0.3f%%\n',Count)
      load(['Control\',files2(Count).name]);
      feature=[];label=[];
      feature=[feature;Feature_normal];
      clear 'Feature_normal'
      label=[label;Label_normal];
      clear 'Label_normal'
      temp=(2*(Count-1)+1);
      load(['D:\MedIA\AMD\',files1(temp).name]);
      feature=[feature;Feature_AMD];
      clear 'Feature_AMD'
      label=[label;Label_AMD];
      clear 'Label_AMD'
      
%       load(['D:\MedIA\AMD\',files1(temp+1).name]);
%       feature=[feature;Feature_AMD];
%       label=[label;Label_AMD];
  
       fprintf('Training tree bagger : \n')
       tic
%         paroptions = statset('UseParallel','always');
%        b = TreeBagger(5,feature,label);%,'Options',paroptions);%,'NPrint',1);
        b = classRF_train(feature,label,2);
    
       toc
P=[];
L=[];
L_pred=[];       
       for Count_temp = 1:no_control
           P=[];
L=[];
L_pred=[]; 
           feature=[];label=[];
            fprintf('Testing data set on : %0.3f%%\n',Count_temp)
            tic
            load(['Control\',files2(Count).name]);
            L=[L;Label_normal];
            clear 'Label_normal'
            
%             [labels_pred,prob_pred]= predict(b,Feature_normal);
%             labels_pred=str2double(labels_pred);
            test_options.predict_all = 1;
            [labels_pred, prob_pred, prediction_pre_tree] = classRF_predict(Feature_normal,b,test_options);
            clear 'Feature_normal'
            prob_pred = prob_pred./repmat((sum(prob_pred'))',[1,size(prob_pred,2)]);
            P=[P;prob_pred];
            clear 'prob_pred'
            L_pred=[L_pred;labels_pred];
            clear 'labels_pred'
             clear 'prediction_pre_tree'
            
            %labels_pred=str2double(labels_pred);            
            
            temp=(2*(Count-1)+1);
            load(['D:\MedIA\AMD\',files1(temp).name]);
            L=[L;Label_AMD];
            clear 'Label_AMD'
            
%             [labels_pred,prob_pred]= predict(b,Feature_AMD);
%             labels_pred=str2double(labels_pred); 
            [labels_pred, prob_pred, prediction_pre_tree] = classRF_predict(Feature_AMD,b,test_options);
            clear 'Feature_AMD'
            prob_pred = prob_pred./repmat((sum(prob_pred'))',[1,size(prob_pred,2)]);
          prob_pred = prob_pred./repmat((sum(prob_pred'))',[1,size(prob_pred,2)]);
            P=[P;prob_pred];
            clear 'prob_pred'
            clear 'prediction_pre_tree'
            L_pred=[L_pred;labels_pred];
            clear 'labels_pred'
            
            fprintf('Analyzing predictions')
            [TP_A,FP_A, TN_A, FN_A] = Confusion_matrix(L_pred,L,2);
            [TP_R,FP_R, TN_R, FN_R] = Confusion_matrix(L_pred,L,3);
            [TP_P,FP_P, TN_P, FN_P] = Confusion_matrix(L_pred,L,4);
            Acc_Anterior(Count,Count_temp)= (TP_A+TN_A)./(TP_A+TN_A+FP_A+FN_A);
            Acc_RPE(Count,Count_temp)= (TP_R+TN_R)./(TP_R+TN_R+FP_R+FN_R);
            Acc_Posterior(Count,Count_temp)= (TP_P+TN_P)./(TP_P+TN_P+FP_P+FN_P);
            Sen_Anterior(Count,Count_temp)= (TP_A)./(TP_A+FN_A);
            Sen_RPE(Count,Count_temp)= (TP_R)./(TP_R+FN_R);
            Sen_Posterior(Count,Count_temp)= (TP_P)./(TP_P+FN_P);
            Spe_Anterior(Count,Count_temp)= (TN_A)./(TN_A+FP_A);
            Spe_RPE(Count,Count_temp)= (TN_R)./(TN_R+FP_R);
            Spe_Posterior(Count,Count_temp)= (TN_P)./(TN_P+FP_P);
            fprintf('Saving Analysis')
            save(strcat('L_P_',num2str(Count),'_',num2str(Count_temp),'.mat'),'P','L','L_pred','-v7.3');
            
            if max(rem(Count_temp,20),Count_temp==no_control)==1
            save('Final.mat','Acc_Anterior','Acc_RPE','Acc_Posterior','Sen_Anterior','Sen_RPE',...
                'Sen_Posterior','Spe_Anterior','Spe_RPE','Spe_Posterior','-v7.3');
            end
            toc
       end
       clear b
end

%% For low computation facility
clear all

files1 = dir('D:\MedIA\AMD\*.mat');
files2 = dir('Control\*.mat');
files='E:\Data\Retina OCT data from duke\';
files3 = dir(strcat(files,'OCT Retina\AMD\*.mat'));
files4 = dir(strcat(files,'OCT Retina\Control\*.mat'));

no_AMD_old = numel(files3);
no_control_old = numel(files4);

no_AMD = numel(files1);
no_control = numel(files2);
Acc_Anterior = zeros(no_control);
Acc_RPE = zeros(no_control);
Acc_Posterior = zeros(no_control);
Sen_Anterior = zeros(no_control);
Sen_RPE = zeros(no_control);
Sen_Posterior = zeros(no_control);
Spe_Anterior = zeros(no_control);
Spe_RPE = zeros(no_control);
Spe_Posterior = zeros(no_control);
P=[];
L=[];
feature=[];
label=[];

for Count = 1:no_control
    fprintf('Training data set on : %0.3f%%\n',Count)
      load(['Control\',files2(Count).name]);
      feature=[];label=[];
      feature=[feature;Feature_normal];
      label=[label;Label_normal];
      temp=(2*(Count-1)+1);
      load(['D:\MedIA\AMD\',files1(temp).name]);
      feature=[feature;Feature_AMD];
      label=[label;Label_AMD];
  
       fprintf('Training tree bagger : \n')
       tic
        b = classRF_train(feature,label,2);
       toc
       clear 'feature' 'label'
Prob=[];
Label=[];
L_pred=[];       
    for Count_temp = 1:no_control
        tic
        fprintf('Converting feature for Control Count: %0.3f%%\n',Count_temp)
        load([strcat(files,'OCT Retina\Control\'),files4(Count).name]);
            
       for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
            feature = Tissue_features(I);
            label = Index_label(I,L);
            label = label(:);
            feature(label==0,:)=[];
            label(label==0)=[];
            test_options.predict_all = 1;
            [labels_pred, prob_pred, prediction_pre_tree] = classRF_predict(feature,b,test_options);
            prob_pred = prob_pred./repmat((sum(prob_pred'))',[1,size(prob_pred,2)]);
            Label=[Label;label];
            Prob=[Prob;prob_pred];
            L_pred=[L_pred;labels_pred];
           end
       end
        fprintf('Converting feature for AMD Count: %0.3f%%\n',Count)
        load([strcat(files,'OCT Retina\AMD\'),files3(Count).name]);
       for stack = 1:size(images,3)
           I = images(:,:,stack);
           L = squeeze(layerMaps(stack,:,:));
           L(isnan(L)) = 0 ;
           if sum(L(:)) > 0
            feature = Tissue_features(I);
            label = Index_label(I,L);
            label = label(:);
            feature(label==0,:)=[];
            label(label==0)=[];
            test_options.predict_all = 1;
            [labels_pred, prob_pred, prediction_pre_tree] = classRF_predict(feature,b,test_options);
            prob_pred = prob_pred./repmat((sum(prob_pred'))',[1,size(prob_pred,2)]);
            Label=[Label;label];
            Prob=[Prob;prob_pred];
            L_pred=[L_pred;labels_pred];
           end
       end
    
        
    
       fprintf('Analyzing predictions')
            [TP_A,FP_A, TN_A, FN_A] = Confusion_matrix(L_pred,Label,2);
            [TP_R,FP_R, TN_R, FN_R] = Confusion_matrix(L_pred,Label,3);
            [TP_P,FP_P, TN_P, FN_P] = Confusion_matrix(L_pred,Label,4);
            Acc_Anterior(Count,Count_temp)= (TP_A+TN_A)./(TP_A+TN_A+FP_A+FN_A);
            Acc_RPE(Count,Count_temp)= (TP_R+TN_R)./(TP_R+TN_R+FP_R+FN_R);
            Acc_Posterior(Count,Count_temp)= (TP_P+TN_P)./(TP_P+TN_P+FP_P+FN_P);
            Sen_Anterior(Count,Count_temp)= (TP_A)./(TP_A+FN_A);
            Sen_RPE(Count,Count_temp)= (TP_R)./(TP_R+FN_R);
            Sen_Posterior(Count,Count_temp)= (TP_P)./(TP_P+FN_P);
            Spe_Anterior(Count,Count_temp)= (FP_A)./(TN_A+FP_A);
            Spe_RPE(Count,Count_temp)= (FP_R)./(TN_R+FP_R);
            Spe_Posterior(Count,Count_temp)= (FP_P)./(TN_P+FP_P);
            fprintf('Saving Analysis')
            if max(rem(Count_temp,10),Count_temp==no_control)==1
            save('Final.mat','Acc_Anterior','Acc_RPE','Acc_Posterior','Sen_Anterior','Sen_RPE',...
                'Sen_Posterior','Spe_Anterior','Spe_RPE','Spe_Posterior','Prob','Label','L_pred','-v7.3');
            end
            toc
     
      
     end
       clear b
end      
   