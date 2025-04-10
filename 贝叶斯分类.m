clc,clear;
%% ѵ����
x1=load('spectra_70.mat');
x_train=x1.spectra_combined;
y1=load('number_70.mat');
y_label=y1.Label;
%% K-fold crassvalid������֤����
[n,m]=size(x_train);
CVSC=[];
cell={};
SC_Avreage=[];
SC_sigma=[];
%% ��Ҷ˹����
[n,m]=size(x_train);
CVKNN=[];
KNN_Avreage=[];
KNN_sigma=[];
k=10;
indices=crossvalind('KFold',n,k);
for i=1:15
for i=1:k
	test=(indices==i); %���Ϊ�߼�ֵ��ÿ��ѭ��ѡȡһ������Ϊ���Լ�
	train=~test; %ȡtest�Ĳ�����Ϊѵ����
	TrainData=x_train(train,:); %��ȡѵ�������� 
	TestData=x_train(test,:); %��ȡ���Լ�����
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