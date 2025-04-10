%% ��ȡ����
clc,clear;
%% ѵ����
x1=load('spectra_37.mat');
x_train=x1.spectra_combined;
y1=load('number_37.mat');
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
for j=1:15
k=10;
indices=crossvalind('KFold',n,k);
%% calculation
for i=1:k
	test=(indices==i); %���Ϊ�߼�ֵ��ÿ��ѭ��ѡȡһ������Ϊ���Լ�
	train=~test; %ȡtest�Ĳ�����Ϊѵ����
	TrainData=x_train(train,:); %��ȡѵ�������� 
	TestData=x_train(test,:); %��ȡ���Լ�����
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
%% softmax classifier
hiddenSize=50;
autoenc = trainAutoencoder(TrainData', hiddenSize,'MaxEpochs',500, ...
    'L2WeightRegularization', 0.01, ...
    'SparsityRegularization', 4, ...
    'SparsityProportion', 0.05, ...
    'DecoderTransferFunction','purelin');
feat1 = encode(autoenc,TrainData');
trainlabel_out=transfer(Label_train,9);
softnet = trainSoftmaxLayer(feat1,trainlabel_out','MaxEpochs',500);
stackednet = stack(autoenc,softnet);
%% Compute accuracy
Y_pre1 = stackednet(TestData');
%%  caculation
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,Y_pre,9);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=[SC_Avreage;mean(CVSC)];
SC_sigma=[SC_sigma;std(CVSC)];
end
Acurracy_SC=mean(SC_Avreage);
sigma_SC=mean(SC_sigma);
%RSD=sigma_SC./Acurracy_SC;