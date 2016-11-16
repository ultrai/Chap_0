restoredefaultpath;matlabrc
% K-means sampling
%same as main2 but differnt training protocols
clear all
close all
cd('C:\Users\SPK Karri\Desktop\Retina Med IA - Copy')
% files='E:\Data\Retina OCT data from duke\';
% files1 = dir(strcat(files,'OCT Retina\AMD\*.mat'));
% files2 = dir(strcat(files,'OCT Retina\Control\*.mat'));
% mkdir('AMD');
% mkdir('Control');
% no_AMD = numel(files1);
% no_control = numel(files2);
% 
% samples = 50; % Sample samples
% train = 1;
% test = samples-train;
% Idx_AMD = randperm (no_AMD,samples);
% Idx_control = randperm (no_control,samples);
% save('parameters.mat','-v7.3')
%     
addpath(genpath('C:\Users\SPK Karri\Desktop\Retina Med IA - Copy\RF_MexStandalone-v0.02-precompiled'))
load('parameters.mat')
warning off;
mkdir('K-means_confusion')
for Count =2% 7:samples
    Feature=[];
    Label=[];
    for temp = 0:(train-1)
        fprintf('Converting feature for training control Count: %0.3f%%\n',Count)
        load([strcat(files,'OCT Retina\Control\'),files2(Idx_control(Count+temp)).name]);
      
        [Feature_control, Label_control] = features_train2(images, layerMaps);
        Feature = [Feature;Feature_control];
        Label = [Label;Label_control];
        clear 'images' 'layerMaps' 'Feature_control' 'Label_control'
    
        fprintf('Converting feature for AMD training Count: %0.3f%%\n',Count)
        load([strcat(files,'OCT Retina\AMD\'),files1(Idx_AMD(Count+temp)).name]);
        
        [Feature_AMD, Label_AMD] = features_train2(images, layerMaps);
        Feature = [Feature;Feature_AMD];
        Label = [Label;Label_AMD];
        clear 'images' 'layerMaps' 'Feature_AMD' 'Label_AMD'
    
    end
    
    fprintf('Training Forest with sample: %0.1f%%\n out of %0.1f%%\n',Count, samples)
    b = classRF_train(Feature,Label,10); 
    
%     BaggedEnsemble = TreeBagger(5,Feature,Label,'OOBPred','On','NPrint',1','OOBVarImp','on','Method','classification','NVarToSample',1);
%     BaggedEnsemble.OOBPermutedVarDeltaError
%     figure,plot(oobError(BaggedEnsemble))
% xlabel('Number of grown trees')
% ylabel('Out-of-bag classification error')
    clear 'Feature_control' ' Feature_AMD' 'Label_control' 'Label_AMD'
    
%     fprintf('saving Forest with sample: %0.1f%%\n out of %0.1f%%\n',Count, samples)
%     save(strcat('Forest_',num2str(Count),'.mat'),'b','-v7.3')
%         
     for Count_test = 1:train:samples
          Pred = [];
         Label = [];
        
         for temp = 0:(train-1)
    
        
%             fprintf('Converting feature for testing control Count: %0.3f%%\n',Count_test)
            load([strcat(files,'OCT Retina\Control\'),files2(Idx_control(Count_test+temp)).name]);
      
%             fprintf('predicting control Count: %0.3f%%\n',Count)
            [Pred_control,Prob_control ,Label_control] = features_test(images, layerMaps, b);
%             save(strcat('Control\Prediction_Control_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'images','Pred_control','Prob_control','Label_control','-v7.3')
            Pred_control(Label_control==0)=[];
            Label_control(Label_control==0)=[];
        
            
%             fprintf('Converting feature for testing AMD Count: %0.3f%%\n',Count_test)
            load([strcat(files,'OCT Retina\AMD\'),files1(Idx_AMD(Count_test+temp)).name]);
      
            fprintf('predicting AMD Count: %0.3f%%\n',Count)
            [Pred_AMD,Prob_AMD, Label_AMD] = features_test(images, layerMaps, b);
%             save(strcat('AMD\Prediction_AMD_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'images','Pred_AMD','Prob_AMD','Label_AMD','-v7.3')
            Pred_AMD(Label_AMD==0)=[];
            Label_AMD(Label_AMD==0)=[];
        
            Pred = [Pred;Pred_control(:);Pred_AMD(:)];
            Label = [Label;Label_control(:);Label_AMD(:)];
            clear 'Pred_control' 'Pred_AMD' 'Label_control' 'Label_AMD' 
        
%             Pred(Label==0)=[];
%             Label(Label==0)=[];
        
            
         end
         
         stats = confusionmatStats(Label,Pred);
%          stats.accuracy
             stats.sensitivity(3)
         
        
        save(strcat('K-means_confusion\ConfusionStats_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'stats','-v7.3')
        
     end
clear 'b'
end
        

%% Evaluation
clear all;
close all;
Test = 50;
Train = 1;

Sensitivity_1 = zeros(Train,Test);
Sensitivity_2 = zeros(Train,Test);
Sensitivity_3 = zeros(Train,Test);
Sensitivity_4 = zeros(Train,Test);

Specificity_1 = zeros(Train,Test);
Specificity_2 = zeros(Train,Test);
Specificity_3 = zeros(Train,Test);
Specificity_4 = zeros(Train,Test);

Precision_1 = zeros(Train,Test);
Precision_2 = zeros(Train,Test);
Precision_3 = zeros(Train,Test);
Precision_4 = zeros(Train,Test);

Recall_1 = zeros(Train,Test);
Recall_2 = zeros(Train,Test);
Recall_3 = zeros(Train,Test);
Recall_4 = zeros(Train,Test);

F_Score_1 = zeros(Train,Test);
F_Score_2 = zeros(Train,Test);
F_Score_3 = zeros(Train,Test);
F_Score_4 = zeros(Train,Test);


Accuracy = zeros(Train,Test);
for train = 2%1:Train
    for test = 1:Test
       if train~=test
        load(strcat('ConfusionStats_',num2str(train),'_',num2str(test),'_0.mat'));
        Accuracy(train,test) = stats.accuracy;
        Sensitivity_1(train,test) = stats.sensitivity(1);
        Sensitivity_2(train,test) = stats.sensitivity(2);
        Sensitivity_3(train,test) = stats.sensitivity(3);
        Sensitivity_4(train,test) = stats.sensitivity(4);
        
        Specificity_1(train,test) = stats.specificity(1);
        Specificity_2(train,test) = stats.specificity(2);
        Specificity_3(train,test) = stats.specificity(3);
        Specificity_4(train,test) = stats.specificity(4);
    
        Precision_1(train,test) = stats.precision(1);
        Precision_2(train,test) = stats.precision(2);
        Precision_3(train,test) = stats.precision(3);
        Precision_4(train,test) = stats.precision(4);
        
        Recall_1(train,test) = stats.recall(1);
        Recall_2(train,test) = stats.recall(2);
        Recall_3(train,test) = stats.recall(3);
        Recall_4(train,test) = stats.recall(4);
        
        F_Score_1(train,test) = stats.Fscore(1);
        F_Score_2(train,test) = stats.Fscore(2);
        F_Score_3(train,test) = stats.Fscore(3);
        F_Score_4(train,test) = stats.Fscore(4);

        
        
        end
        
    end
end
%figure, imshow(imresize(Sensitivity_3,20,'nearest'))
%figure, imshow(imresize(F_Score_3,20,'nearest'))
% saveas(gcf,'fscore_3.tif','tif');
mean(F_Score_3(2,:))
std(F_Score_3(2,:))
mean(Sensitivity_3(2,:))
std(Sensitivity_3(2,:))


