clear,clc;
x1_mssa=load('fina_MSSA.mat');
JP_MSSA=x1_mssa.a';
[n1,m1]=size(JP_MSSA);
label_MSSA=ones(n1,1);
%% ��ȡ����
x2_mrsa=load('fina_MRSA.mat');
JP_MRSA=x2_mrsa.a';
[n2,m2]=size(JP_MRSA);
label_MRSA=2*ones(n2,1);
%% �ϲ����ݼ�
X=[JP_MSSA;JP_MRSA];
Y=[label_MSSA;label_MRSA];
[n,m]=size(X);
%% ѵ�������ּ���
testRatio = 0.2;
% ѵ��������
trainIndices = crossvalind('HoldOut',n, testRatio);
% ���Լ�����
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% ѵ������ѵ����ǩ
trainData = X(trainIndices, :);
trainLabel =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% ���Լ��Ͳ��Ա�ǩ
testData = X(testIndices, :);
testLabel = Y(testIndices, :);
%save('testData.mat','testData')
%save('testLabel.mat','testLabel')
trainData=X;
%% Sparse autoencoder modeling
hiddenSize=3;
autoenc = trainAutoencoder(trainData', hiddenSize,'MaxEpochs',800, ...
    'L2WeightRegularization', 0.001, ...
    'SparsityRegularization', 4, ...
    'SparsityProportion', 0.05, ...
    'DecoderTransferFunction','purelin');
feat1 = encode(autoenc,trainData');
trainlabel_out=transfer(trainLabel,2);
softnet = trainSoftmaxLayer(feat1,trainlabel_out','MaxEpochs',100);
stackednet = stack(autoenc,softnet);
%% Compute accuracy
Y_pre1 = stackednet(testData');
%%  caculation
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[testLabel,Y_pre];
statis_SAE=CVaccuration(testLabel,Y_pre,2);