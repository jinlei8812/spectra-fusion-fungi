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
CVELM=[];
ELM_Avreage=[];
ELM_sigma=[];
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
