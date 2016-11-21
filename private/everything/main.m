restoredefaultpath;matlabrc
clear all
close all
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
load('parameters.mat')
for Count = 1:samples
    Feature=[];
    Label=[];
    for temp = 0:(train-1)
        fprintf('Converting feature for training control Count: %0.3f%%\n',Count)
        load([strcat(files,'OCT Retina\Control\'),files2(Idx_control(Count+temp)).name]);
      
        [Feature_control, Label_control] = features_train(images, layerMaps);
        Feature = [Feature;Feature_control];
        Label = [Label;Label_control];
        clear 'images' 'layerMaps' 'Feature_control' 'Label_control'
    
        fprintf('Converting feature for AMD training Count: %0.3f%%\n',Count)
        load([strcat(files,'OCT Retina\AMD\'),files1(Idx_AMD(Count+temp)).name]);
        
        [Feature_AMD, Label_AMD] = features_train(images, layerMaps);
        Feature = [Feature;Feature_AMD];
        Label = [Label;Label_AMD];
        clear 'images' 'layerMaps' 'Feature_AMD' 'Label_AMD'
    
    end
    
    fprintf('Training Forest with sample: %0.1f%%\n out of %0.1f%%\n',Count, samples)
    b = TreeBagger(5,Feature,Label,'NPrint',1); %,'Options',paroptions);  
    clear 'Feature_control' ' Feature_AMD' 'Label_control' 'Label_AMD'
    
%     fprintf('saving Forest with sample: %0.1f%%\n out of %0.1f%%\n',Count, samples)
%     save(strcat('Forest_',num2str(Count),'.mat'),'b','-v7.3')
%         
     for Count_test = 1:train:samples
          Pred = [];
         Label = [];
        
         for temp = 0:(train-1)
    
        
            fprintf('Converting feature for testing control Count: %0.3f%%\n',Count_test)
            load([strcat(files,'OCT Retina\Control\'),files2(Idx_control(Count_test+temp)).name]);
      
            fprintf('predicting control Count: %0.3f%%\n',Count)
            [Pred_control,Prob_control ,Label_control] = features_test(images, layerMaps, b);
            save(strcat('Control\Prediction_Control_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'images','Pred_control','Prob_control','Label_control','-v7.3')
            Pred_control(Label_control==0)=[];
            Label_control(Label_control==0)=[];
        
            
            fprintf('Converting feature for testing AMD Count: %0.3f%%\n',Count_test)
            load([strcat(files,'OCT Retina\AMD\'),files1(Idx_AMD(Count_test+temp)).name]);
      
            fprintf('predicting AMD Count: %0.3f%%\n',Count)
            [Pred_AMD,Prob_AMD, Label_AMD] = features_test(images, layerMaps, b);
            save(strcat('AMD\Prediction_AMD_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'images','Pred_AMD','Prob_AMD','Label_AMD','-v7.3')
            Pred_AMD(Label_AMD==0)=[];
            Label_AMD(Label_AMD==0)=[];
        
            Pred = [Pred;Pred_control(:);Pred_AMD(:)];
            Label = [Label;Label_control(:);Label_AMD(:)];
            clear 'Pred_control' 'Pred_AMD' 'Label_control' 'Label_AMD' 
        
%             Pred(Label==0)=[];
%             Label(Label==0)=[];
        
            
         end
         
         stats = confusionmatStats(Label,Pred);
        
        save(strcat('ConfusionStats_',num2str(Count),'_',num2str(Count_test),'_',num2str(temp),'.mat'),'stats','-v7.3')
        
     end
clear 'b'
end
        

