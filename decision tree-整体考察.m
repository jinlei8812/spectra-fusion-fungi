%% 提取光谱
clc,clear;
%% 训练集
x1=load('train_spectra.mat');
x_train= x1.spectra_train;
y1=load('label_train.mat');
y_train_label=y1.Label_train;
%% 测试集
x2=load('test_spectra.mat');
x_test= x2.spectra_test;
y2=load('label_test.mat');
y_test_label=y2.Label;
%% Softmax caculation
%[n,m]=size(x_train);
CVDT=[];
%% calculation
for i=1:15
	TrainData=x_train; %提取训练集数据 
	TestData=x_test; %提取测试集数据
    Label_train=y_train_label;
    Label_test=y_test_label;
    %% RF caculation
net=fitctree(TrainData,Label_train);
Y_pre=predict(net,TestData);
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,4);
CVDT=[CVDT;statis_DT];
end
DT_Avreage=mean(CVDT);
DT_sigma=std(CVDT);