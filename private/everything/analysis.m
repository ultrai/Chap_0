cd('C:\Users\SPK Karri\Desktop\Retina Med IA')
test=115;
files = dir('*.mat'); 
train=numel(files)/test;
TP=zeros(train,test);
TN=zeros(train,test);
FP=zeros(train,test);
FN=zeros(train,test);
Prediction=zeros(100,1);

Label=zeros(100,1);

cd('C:\Users\SPK Karri\Desktop\Retina Med IA')
for Train_no = 47:(47+numel(files))
   TP_layer1=cell(100,1);
Sen1=TP_layer1;
Sen2=TP_layer1;
Sen3=TP_layer1;
Sen4=TP_layer1;
Spe1=TP_layer1;
Spe2=TP_layer1;
Spe3=TP_layer1;
Spe4=TP_layer1;
TP_layer2=TP_layer1;
TP_layer3=TP_layer1;
TP_layer4=TP_layer1;

TN_layer1=TP_layer1;
TN_layer2=TP_layer1;
TN_layer3=TP_layer1;
TN_layer4=TP_layer1;

FN_layer1=TP_layer1;
FN_layer2=TP_layer1;
FN_layer3=TP_layer1;
FN_layer4=TP_layer1;

FP_layer1=TP_layer1;
FP_layer2=TP_layer1;
FP_layer3=TP_layer1;
FP_layer4=TP_layer1;


    for Test_no = 1:101%test
        tic
        Train_no
        Test_no
        load(strcat('L_P_',num2str(Train_no),'_',num2str(Test_no),'.mat'))
        Layer1_prediction=P(:,1);
        Layer2_prediction=P(:,2);
        Layer3_prediction=P(:,3);
        Layer4_prediction=P(:,4);
        Layer1=L==1;
        Layer2=L==2;
        Layer3=L==3;
        Layer4=L==4;
        for thresh = 0.01:0.01:1
            Layer1_prediction_temp=Layer1_prediction>thresh;
            Layer2_prediction_temp=Layer2_prediction>thresh;
            Layer3_prediction_temp=Layer3_prediction>thresh;
            Layer4_prediction_temp=Layer4_prediction>thresh;
            
            TP_1=sum(Layer1.*Layer1_prediction_temp);
            TP_2=sum(Layer2.*Layer2_prediction_temp);
            TP_3=sum(Layer3.*Layer3_prediction_temp);
            TP_4=sum(Layer4.*Layer4_prediction_temp);
            TP_layer1{fix(thresh*100)}=[TP_layer1{fix(thresh*100)};TP_1];
            TP_layer2{fix(thresh*100)}=[TP_layer2{fix(thresh*100)};TP_2];
            TP_layer3{fix(thresh*100)}=[TP_layer3{fix(thresh*100)};TP_3];
            TP_layer4{fix(thresh*100)}=[TP_layer4{fix(thresh*100)};TP_4];
            
             
            TN_1=sum((~Layer1).*(~Layer1_prediction_temp));
            TN_2=sum((~Layer2).*(~Layer2_prediction_temp));
            TN_3=sum((~Layer3).*(~Layer3_prediction_temp));
            TN_4=sum((~Layer4).*(~Layer4_prediction_temp));
            TN_layer1{fix(thresh*100)}=[TN_layer1{fix(thresh*100)};TN_1];
            TN_layer2{fix(thresh*100)}=[TN_layer2{fix(thresh*100)};TN_2];
            TN_layer3{fix(thresh*100)}=[TN_layer3{fix(thresh*100)};TN_3];
            TN_layer4{fix(thresh*100)}=[TN_layer4{fix(thresh*100)};TN_4];
            
            FP_1=sum((~Layer1).*Layer1_prediction_temp);
            FP_2=sum((~Layer2).*Layer2_prediction_temp);
            FP_3=sum((~Layer3).*Layer3_prediction_temp);
            FP_4=sum((~Layer4).*Layer4_prediction_temp);
            FP_layer1{fix(thresh*100)}=[FP_layer1{fix(thresh*100)};FP_1];
            FP_layer2{fix(thresh*100)}=[FP_layer2{fix(thresh*100)};FP_2];
            FP_layer3{fix(thresh*100)}=[FP_layer3{fix(thresh*100)};FP_3];
            FP_layer4{fix(thresh*100)}=[FP_layer4{fix(thresh*100)};FP_4];
            
            FN_1=sum(Layer1.*(~Layer1_prediction_temp));
            FN_2=sum(Layer2.*(~Layer2_prediction_temp));
            FN_3=sum(Layer3.*(~Layer3_prediction_temp));
            FN_4=sum(Layer4.*(~Layer4_prediction_temp));
            FN_layer1{fix(thresh*100)}=[FN_layer1{fix(thresh*100)};FN_1];
            FN_layer2{fix(thresh*100)}=[FN_layer2{fix(thresh*100)};FN_2];
            FN_layer3{fix(thresh*100)}=[FN_layer3{fix(thresh*100)};FN_3];
            FN_layer4{fix(thresh*100)}=[FN_layer4{fix(thresh*100)};FN_4];
        
            Sen1{fix(thresh*100)}=[Sen1{fix(thresh*100)};TP_1/(TP_1+FN_1)];
            Sen2{fix(thresh*100)}=[Sen2{fix(thresh*100)};TP_2/(TP_2+FN_2)];
            Sen3{fix(thresh*100)}=[Sen3{fix(thresh*100)};TP_3/(TP_3+FN_3)];
            Sen4{fix(thresh*100)}=[Sen4{fix(thresh*100)};TP_4/(TP_4+FN_4)];
            Spe1{fix(thresh*100)}=[Spe1{fix(thresh*100)};TN_1/(TN_1+FP_1)];
            Spe2{fix(thresh*100)}=[Spe2{fix(thresh*100)};TN_2/(TN_2+FP_2)];
            Spe3{fix(thresh*100)}=[Spe3{fix(thresh*100)};TN_3/(TN_3+FP_3)];
            Spe4{fix(thresh*100)}=[Spe4{fix(thresh*100)};TN_4/(TN_4+FP_4)];
            
            
        end
    end
    toc
    save(strcat('ROC_',num2str(Train_no),'.mat'),'Sen1','Sen2','Sen3','Sen4',...
        'Spe1','Spe2','Spe3','Spe4','TP_layer1','TP_layer2','TP_layer3','TP_layer4',...
        'TN_layer1','TN_layer2','TN_layer3','TN_layer4','FN_layer1','FN_layer2',...
        'FN_layer3','FN_layer4','FP_layer1','FP_layer2','FP_layer3','FP_layer4','-v7.3');
end
            
        
            
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('D:\MedIA\New folder\')

test=115;
files = dir('*.mat'); 
train=numel(files)/test;
TP=zeros(train,test);
TN=zeros(train,test);
FP=zeros(train,test);
FN=zeros(train,test);
Prediction=zeros(100,1);

Label=zeros(100,1);
TP_layer1=cell(100,1);
Sen1=TP_layer1;
Sen2=TP_layer1;
Sen3=TP_layer1;
Sen4=TP_layer1;
Spe1=TP_layer1;
Spe2=TP_layer1;
Spe3=TP_layer1;
Spe4=TP_layer1;


TP_layer2=TP_layer1;
TP_layer3=TP_layer1;
TP_layer4=TP_layer1;

TN_layer1=TP_layer1;
TN_layer2=TP_layer1;
TN_layer3=TP_layer1;
TN_layer4=TP_layer1;

FN_layer1=TP_layer1;
FN_layer2=TP_layer1;
FN_layer3=TP_layer1;
FN_layer4=TP_layer1;

FP_layer1=TP_layer1;
FP_layer2=TP_layer1;
FP_layer3=TP_layer1;
FP_layer4=TP_layer1;

for Train_no = 1:numel(files)/test
    for Test_no = 1:test
        tic
        Train_no
        Test_no
        load(strcat('L_P_',num2str(Train_no),'_',num2str(Test_no),'.mat'))
        Layer1_prediction=P(:,1);
        Layer2_prediction=P(:,2);
        Layer3_prediction=P(:,3);
        Layer4_prediction=P(:,4);
        Layer1=L==1;
        Layer2=L==2;
        Layer3=L==3;
        Layer4=L==4;
        for thresh = 0.01:0.01:1
            Layer1_prediction_temp=Layer1_prediction>thresh;
            Layer2_prediction_temp=Layer2_prediction>thresh;
            Layer3_prediction_temp=Layer3_prediction>thresh;
            Layer4_prediction_temp=Layer4_prediction>thresh;
            
            TP_1=sum(Layer1.*Layer1_prediction_temp);
            TP_2=sum(Layer2.*Layer2_prediction_temp);
            TP_3=sum(Layer3.*Layer3_prediction_temp);
            TP_4=sum(Layer4.*Layer4_prediction_temp);
            TP_layer1{fix(thresh*100)}=[TP_layer1{fix(thresh*100)};TP_1];
            TP_layer2{fix(thresh*100)}=[TP_layer2{fix(thresh*100)};TP_2];
            TP_layer3{fix(thresh*100)}=[TP_layer3{fix(thresh*100)};TP_3];
            TP_layer4{fix(thresh*100)}=[TP_layer4{fix(thresh*100)};TP_4];
            
            TN_1=sum((~Layer1).*(~Layer1_prediction_temp));
            TN_2=sum((~Layer2).*(~Layer2_prediction_temp));
            TN_3=sum((~Layer3).*(~Layer3_prediction_temp));
            TN_4=sum((~Layer4).*(~Layer4_prediction_temp));
            TN_layer1{fix(thresh*100)}=[TN_layer1{fix(thresh*100)};TN_1];
            TN_layer2{fix(thresh*100)}=[TN_layer2{fix(thresh*100)};TN_2];
            TN_layer3{fix(thresh*100)}=[TN_layer3{fix(thresh*100)};TN_3];
            TN_layer4{fix(thresh*100)}=[TN_layer4{fix(thresh*100)};TN_4];
            
            FP_1=sum((~Layer1).*Layer1_prediction_temp);
            FP_2=sum((~Layer2).*Layer2_prediction_temp);
            FP_3=sum((~Layer3).*Layer3_prediction_temp);
            FP_4=sum((~Layer4).*Layer4_prediction_temp);
            FP_layer1{fix(thresh*100)}=[FP_layer1{fix(thresh*100)};FP_1];
            FP_layer2{fix(thresh*100)}=[FP_layer2{fix(thresh*100)};FP_2];
            FP_layer3{fix(thresh*100)}=[FP_layer3{fix(thresh*100)};FP_3];
            FP_layer4{fix(thresh*100)}=[FP_layer4{fix(thresh*100)};FP_4];
            
            FN_1=sum(Layer1.*(~Layer1_prediction_temp));
            FN_2=sum(Layer2.*(~Layer2_prediction_temp));
            FN_3=sum(Layer3.*(~Layer3_prediction_temp));
            FN_4=sum(Layer4.*(~Layer4_prediction_temp));
            FN_layer1{fix(thresh*100)}=[FN_layer1{fix(thresh*100)};FN_1];
            FN_layer2{fix(thresh*100)}=[FN_layer2{fix(thresh*100)};FN_2];
            FN_layer3{fix(thresh*100)}=[FN_layer3{fix(thresh*100)};FN_3];
            FN_layer4{fix(thresh*100)}=[FN_layer4{fix(thresh*100)};FN_4];
        end
    end
    toc
end
            
        
            
        
        
        
        
    