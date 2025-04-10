clear,clc;
x1_mssa=load('fina_MSSA.mat');
JP_MSSA=x1_mssa.a';
[n1,m1]=size(JP_MSSA);
label_MSSA=ones(n1,1);
%% 提取金浦
x2_mrsa=load('fina_MRSA.mat');
JP_MRSA=x2_mrsa.a';
[n2,m2]=size(JP_MRSA);
label_MRSA=2*ones(n2,1);
%% 合并数据集
X=[JP_MSSA;JP_MRSA];
Y=[label_MSSA;label_MRSA];
[n,m]=size(X);
%% 训练集划分计算
testRatio = 0.2;
% 训练集索引
trainIndices = crossvalind('HoldOut',n, testRatio);
% 测试集索引
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% 训练集和训练标签
trainData = X(trainIndices, :);
trainLabel =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% 测试集和测试标签
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
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[testLabel,Y_pre];
statis_SAE=CVaccuration(testLabel,Y_pre,2);