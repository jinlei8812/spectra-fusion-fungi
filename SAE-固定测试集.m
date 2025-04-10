clc,clear;
%% 训练集
x1=load('spectra_37.mat');
X=x1.spectra_combined;
y1=load('number_37.mat');
Y=y1.Label;
% 定义参数
% 假设 X 是光谱矩阵，Y 是类别标签向量
% X: N x M 矩阵, Y: N x 1 向量
unique_classes = unique(Y); % 获取所有类别
train_idx = []; % 训练集索引
test_idx = [];  % 测试集索引
CVSC=[];
for i = 1:length(unique_classes)
    class = unique_classes(i);
    class_indices = find(Y == class); % 找到当前类别的索引
    num_samples = length(class_indices);
    
    if class == 7 % 假设 C 类用数字 3 表示
        test_count = min(30, num_samples); % 最后30个光谱作为测试集，如果70度的话，为15
    else
        test_count = min(60, num_samples); % 其它类别最后60个光谱作为测试集
    end
    
    % 分配测试集和训练集
    test_idx = [test_idx; class_indices(end-test_count+1:end)]; % 添加测试集索引
    train_idx = [train_idx; class_indices(1:end-test_count)];  % 添加训练集索引
end
% 提取训练集和测试集
TrainData = X(train_idx, :);
Label_train = Y(train_idx);
TestData = X(test_idx, :);
Label_test = Y(test_idx);
%% softmax classifier
for i=1:15
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
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,Y_pre,9);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=mean(CVSC);
SC_sigma=std(CVSC);

