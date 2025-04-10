%% 提取光谱
clc,clear;
%% 训练集
x1=load('spectra_70.mat');
x_train=x1.spectra_combined;
y1=load('number_70.mat');
y_label=y1.Label;
%% 测试集
%x2=load('test_spectra.mat');
%x_test=x2.spectra_test;
%y2=load('label_test.mat');
%y_test_label=y2.Label;

%% K-fold crassvalid交叉验证计算
[n,m]=size(x_train);
CVELM=[];
ELM_Avreage=[];
ELM_sigma=[];
%% CV
k=10;
indices=crossvalind('KFold',n,k);
%% calculation
for i=1:15
for i=1:k
	test=(indices==i); %结果为逻辑值，每次循环选取一个组作为测试集
	train=~test; %取test的补集即为训练集
	TrainData=x_train(train,:); %提取训练集数据 
	TestData=x_train(test,:); %提取测试集数据
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
    %% RF caculation
   P_train=TrainData';
    T_train= Label_train';
    P_test=TestData';
    T_test=Label_test';
% net
   [IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,100,'sig',1);
   Y_pre = elmpredict(P_test,IW,B,LW,TF,TYPE);
resum=[Label_test,Y_pre'];
%cell{j,i}=resum;
statis_RF=CVaccuration( Label_test,Y_pre',9);
CVELM=[CVELM;statis_RF];
end
end
ELM_Avreage=mean(CVELM);
ELM_sigma=std(CVELM);
