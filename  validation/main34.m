restoredefaultpath;matlabrc
clear all
close all
cd('C:\Users\MICT\Desktop\Retina Med IA - validation')
load('parameters.mat')
files='D:\Data\Retina OCT data from duke\';
files1 = dir(strcat(files,'OCT Retina\AMD\*.mat'));
files2 = dir(strcat(files,'OCT Retina\Control\*.mat'));


%parfor (Count = 1:50,5)%samples
for Count = 1:50
    Count
    for temp = 0:(train-1)
        fprintf('Converting feature for training control Count: %0.3f%%\n',Count)
        Data = load([strcat(files,'OCT Retina\Control\'),files2(Idx_control(Count+temp)).name]);
      
        [Output_control, Label_control] = Segment(Data.images, Data.layerMaps);
        save(['confusion\' files2(Idx_control(Count+temp)).name ],'Output_control','Label_control','-v7.3')
        fprintf('Converting feature for AMD training Count: %0.3f%%\n',Count)
        Data = load([strcat(files,'OCT Retina\AMD\'),files1(Idx_AMD(Count+temp)).name]);
        
        [Output_AMD, Label_AMD] = Segment(Data.images, Data.layerMaps);
        save(['confusion\' files1(Idx_AMD(Count+temp)).name ],'Output_AMD','Label_AMD','-v7.3')
        
    end
end
%%
clear all
files = dir('confusion\*.mat');
C = [];
Sen = [];
Spe = [];
Acc= [];
for Count = 1:numel(files)
    Count
    load(['confusion\' files(Count).name]);
    if exist('Output_AMD')
        Output_AMD = Output_AMD(:);
        Label_AMD = Label_AMD(:);
        Output_AMD(Label_AMD==0)=[];
        Label_AMD(Label_AMD==0)=[];
        stats = confusionmatStats(Label_AMD,Output_AMD);
        Sen = [Sen;[stats.sensitivity]'];
        Spe = [Spe;[stats.specificity]'];
        Acc = [Acc;stats.accuracy];
        %c = confusionmat(Label_AMD,Output_AMD);
        %C = cat(3,C,c);
        
    else
        Output_control = Output_control(:);
        Label_control = Label_control(:);
        Output_control(Label_control==0)=[];
        Label_control(Label_control==0)=[];
        
        stats = confusionmatStats(Label_control,Output_control);
        Sen = [Sen;[stats.sensitivity]'];
        Spe = [Spe;[stats.specificity]'];
        Acc = [Acc;stats.accuracy];
%         c = confusionmat(Label_control,Output_control);
%         C = cat(3,C,c);
    end
end
