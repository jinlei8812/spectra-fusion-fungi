%%��ά��ͼ��
%% ��ȡ����
clear,clc;
x1_CRKP=load('fina_CRKP.mat');
FK_CRKP=x1_CRKP.a';
[n1,m1]=size(FK_CRKP);
label_CRKP=ones(n1,1);
mean_CRKP=mean(FK_CRKP)';
SD_CRKP=std(FK_CRKP)';
%% ��ȡ����
x1_CSKP=load('fina_CSKP.mat');
FK_CSKP=x1_CSKP.a';
[n2,m2]=size(FK_CSKP);
label_CSKP=2*ones(n2,1);
mean_CSKP=mean(FK_CSKP)';
SD_CSKP=std(FK_CSKP)';
%% �ϲ����ݼ�
x_train=[FK_CRKP;FK_CSKP];
y_label=[label_CRKP;label_CSKP];
%% K-fold crassvalid������֤����
%x_train=bacteria_score;
[n,m]=size(x_train);
CVDT=[];
DT_Avreage=[];
DT_sigma=[];
%% CV
k=10;
indices=crossvalind('KFold',n,k);
%% calculation
for j=1:15
for i=1:k
	test=(indices==i); %���Ϊ�߼�ֵ��ÿ��ѭ��ѡȡһ������Ϊ���Լ�
	train=~test; %ȡtest�Ĳ�����Ϊѵ����
	TrainData=x_train(train,:); %��ȡѵ�������� 
	TestData=x_train(test,:); %��ȡ���Լ�����
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
%% softmax classifier
trainlabel_out=transfer(Label_train,2);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',1000);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,2);
CVDT=[CVDT;statis_DT];
end
end
DT_Avreage=[DT_Avreage;mean(CVDT)];
DT_sigma=[std(CVDT);DT_sigma];

%%
X=x_train;
Y=y_label;
[n,m]=size(X);
testRatio = 0.2;
% ѵ��������
trainIndices = crossvalind('HoldOut', n, testRatio);
% ���Լ�����
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% ѵ������ѵ����ǩ
TrainData = X(trainIndices, :);
Label_train =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% ���Լ��Ͳ��Ա�ǩ
TestData= X(testIndices, :);
Label_test = Y(testIndices, :);
%save('testData.mat','testData')
%save('testLabel.mat','testLabel')
%% SOftmax
%% softmax classifier
trainlabel_out=transfer(Label_train,2);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',500);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,2);
%CVDT=[CVDT;statis_DT];
%% confusion matrix
m=confusionmat(Label_test,Y_pre);
statesNE = ["CRKP","CSKP "]
classlabels=categorical(statesNE);
cm = confusionchart(m,classlabels);
cm.Normalization = 'row-normalized';
sortClasses(cm,'descending-diagonal');
cm.Normalization = 'absolute';
%% %% save 
