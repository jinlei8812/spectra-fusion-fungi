% �����������ѧϰ������������
%% ��������
% ����������ݴ洢�ڱ��� X����ǩ�洢�ڱ��� Y
% X: num_samples x num_features
% Y: num_samples x 1 (������ǩ����1��ʼ��ʾ���)
load('spectrum_data.mat'); % �滻Ϊʵ�ʵ������ļ���
clc,clear;
%% ѵ����
x1=load('spectra_60.mat');
X=x1.spectra_combined;
y1=load('number_60.mat');
Y=y1.Label;
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
%% ���ݷָѵ�����Ͳ��Լ�
% 80% ѵ����, 20% ���Լ�
[trainIdx, testIdx] = dividerand(size(X, 1), 0.8, 0.2); 
X_train = X(trainIdx, :);
Y_train = Y(trainIdx);
X_test = X(testIdx, :);
Y_test = Y(testIdx);

%% ���ݸ�ʽת��
% ����������ת��Ϊ 4D ��ʽ [num_samples, num_features, 1, 1]
X_train = reshape(X_train, size(X_train, 1), size(X_train, 2), 1, 1);
X_test = reshape(X_test, size(X_test, 1), size(X_test, 2), 1, 1);

% ��ǩת��Ϊ�������
Y_train = categorical(Y_train);
Y_test = categorical(Y_test);

%% �������������
layers = [
    imageInputLayer([size(X_train, 2), 1, 1], 'Name', 'input', 'Normalization', 'none') % �����
    convolution2dLayer([3, 1], 16, 'Padding', 'same', 'Name', 'conv1') % ��һ�����
    reluLayer('Name', 'relu1') % �����
    maxPooling2dLayer([2, 1], 'Stride', [2, 1], 'Name', 'pool1') % ���ػ���
    convolution2dLayer([3, 1], 32, 'Padding', 'same', 'Name', 'conv2') % �ڶ������
    reluLayer('Name', 'relu2')
    maxPooling2dLayer([2, 1], 'Stride', [2, 1], 'Name', 'pool2')
    fullyConnectedLayer(max(double(Y)), 'Name', 'fc') % ȫ���Ӳ�, �����=max(Y)
    softmaxLayer('Name', 'softmax') % Softmax ��
    classificationLayer('Name', 'output') % �����
];

%% ����ѵ��ѡ��
options = trainingOptions('adam', ... % ʹ�� Adam �Ż���
    'MaxEpochs', 20, ... % ����������
    'InitialLearnRate', 1e-3, ... % ��ʼѧϰ��
    'MiniBatchSize', 32, ... % С������С
    'Shuffle', 'every-epoch', ... % ÿ�����ݴ���
    'Plots', 'training-progress', ... % ��ʾѵ������
    'ValidationData', {X_test, Y_test}); % ��֤��

%% ѵ������
net = trainNetwork(X_train, Y_train, layers, options);
%% ��������
YPred = classify(net, X_test); % Ԥ��
accuracy = sum(YPred == Y_test) / numel(Y_test); % ����׼ȷ��
disp(['���Լ�׼ȷ��: ', num2str(accuracy * 100), '%']);
%% ���ƻ�������
figure;
confusionchart(Y_test, YPred, 'Title', 'Confusion Matrix', ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');
