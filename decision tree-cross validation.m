%% ��ȡ����
clc,clear;
%% ѵ����
x1=load('spectra_70.mat');
x_train=x1.spectra_combined;
y1=load('number_70.mat');
y_label=y1.Label;
%% ���Լ�
%x2=load('test_spectra.mat');
%x_test=x2.spectra_test;
%y2=load('label_test.mat');
%y_test_label=y2.Label;
%% K-fold crassvalid������֤����
[n,m]=size(x_train);
CVSC=[];
cell={};
SC_Avreage=[];
SC_sigma=[];
%% K-fold crassvalid������֤����
[n,m]=size(x_train);
CVDT=[];
DT_Avreage=[];
DT_sigma=[];
%% CV
k=10;
indices=crossvalind('KFold',n,k);
%% calculation
for i=1:15
for i=1:k
	test=(indices==i); %���Ϊ�߼�ֵ��ÿ��ѭ��ѡȡһ������Ϊ���Լ�
	train=~test; %ȡtest�Ĳ�����Ϊѵ����
	TrainData=x_train(train,:); %��ȡѵ�������� 
	TestData=x_train(test,:); %��ȡ���Լ�����
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
    %% RF caculation
net=fitctree(TrainData,Label_train);
Y_pre=predict(net,TestData);
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,9);
CVDT=[CVDT;statis_DT];
end
end
DT_Avreage=[DT_Avreage;mean(CVDT)];
DT_sigma=[std(CVDT);DT_sigma];
