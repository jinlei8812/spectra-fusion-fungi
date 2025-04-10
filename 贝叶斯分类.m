clc,clear;
%% 训练集
x1=load('spectra_70.mat');
x_train=x1.spectra_combined;
y1=load('number_70.mat');
y_label=y1.Label;
%% K-fold crassvalid交叉验证计算
[n,m]=size(x_train);
CVSC=[];
cell={};
SC_Avreage=[];
SC_sigma=[];
%% 贝叶斯分类
[n,m]=size(x_train);
CVKNN=[];
KNN_Avreage=[];
KNN_sigma=[];
k=10;
indices=crossvalind('KFold',n,k);
for i=1:15
for i=1:k
	test=(indices==i); %结果为逻辑值，每次循环选取一个组作为测试集
	train=~test; %取test的补集即为训练集
	TrainData=x_train(train,:); %提取训练集数据 
	TestData=x_train(test,:); %提取测试集数据
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
    %% training
md1=fitcnb(TrainData,Label_train);
Y_pre=predict(md1,TestData);
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_KNN=CVaccuration(Label_test,Y_pre,9);
CVKNN=[CVKNN;statis_KNN];
end
end
KNN_Avreage=mean(CVKNN);
KNN_sigma=std(CVKNN);