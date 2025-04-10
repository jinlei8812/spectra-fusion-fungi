% 光谱数据深度学习分类完整代码
%% 加载数据
% 假设光谱数据存储在变量 X，标签存储在变量 Y
% X: num_samples x num_features
% Y: num_samples x 1 (整数标签，从1开始表示类别)
load('spectrum_data.mat'); % 替换为实际的数据文件名
clc,clear;
%% 训练集
x1=load('spectra_60.mat');
X=x1.spectra_combined;
y1=load('number_60.mat');
Y=y1.Label;
%% 测试集
%x2=load('test_spectra.mat');
%x_test=x2.spectra_test;
%y2=load('label_test.mat');
%y_test_label=y2.Label;
%% K-fold crassvalid交叉验证计算
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
	test=(indices==i); %结果为逻辑值，每次循环选取一个组作为测试集
	train=~test; %取test的补集即为训练集
	TrainData=x_train(train,:); %提取训练集数据 
	TestData=x_train(test,:); %提取测试集数据
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
%% 数据分割：训练集和测试集
% 80% 训练集, 20% 测试集
[trainIdx, testIdx] = dividerand(size(X, 1), 0.8, 0.2); 
X_train = X(trainIdx, :);
Y_train = Y(trainIdx);
X_test = X(testIdx, :);
Y_test = Y(testIdx);

%% 数据格式转换
% 将光谱数据转换为 4D 格式 [num_samples, num_features, 1, 1]
X_train = reshape(X_train, size(X_train, 1), size(X_train, 2), 1, 1);
X_test = reshape(X_test, size(X_test, 1), size(X_test, 2), 1, 1);

% 标签转换为分类变量
Y_train = categorical(Y_train);
Y_test = categorical(Y_test);

%% 构建卷积神经网络
layers = [
    imageInputLayer([size(X_train, 2), 1, 1], 'Name', 'input', 'Normalization', 'none') % 输入层
    convolution2dLayer([3, 1], 16, 'Padding', 'same', 'Name', 'conv1') % 第一卷积层
    reluLayer('Name', 'relu1') % 激活层
    maxPooling2dLayer([2, 1], 'Stride', [2, 1], 'Name', 'pool1') % 最大池化层
    convolution2dLayer([3, 1], 32, 'Padding', 'same', 'Name', 'conv2') % 第二卷积层
    reluLayer('Name', 'relu2')
    maxPooling2dLayer([2, 1], 'Stride', [2, 1], 'Name', 'pool2')
    fullyConnectedLayer(max(double(Y)), 'Name', 'fc') % 全连接层, 类别数=max(Y)
    softmaxLayer('Name', 'softmax') % Softmax 层
    classificationLayer('Name', 'output') % 分类层
];

%% 设置训练选项
options = trainingOptions('adam', ... % 使用 Adam 优化器
    'MaxEpochs', 20, ... % 最大迭代次数
    'InitialLearnRate', 1e-3, ... % 初始学习率
    'MiniBatchSize', 32, ... % 小批量大小
    'Shuffle', 'every-epoch', ... % 每轮数据打乱
    'Plots', 'training-progress', ... % 显示训练过程
    'ValidationData', {X_test, Y_test}); % 验证集

%% 训练网络
net = trainNetwork(X_train, Y_train, layers, options);
%% 测试网络
YPred = classify(net, X_test); % 预测
accuracy = sum(YPred == Y_test) / numel(Y_test); % 计算准确率
disp(['测试集准确率: ', num2str(accuracy * 100), '%']);
%% 绘制混淆矩阵
figure;
confusionchart(Y_test, YPred, 'Title', 'Confusion Matrix', ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');
