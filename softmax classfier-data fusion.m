clc,clear;
%% 训练集
x1=load('spectra_fusion.mat');
X0=x1.spectra_combined;
%X=[X0(:,1270*1+1:1270*2),X0(:,1270*3+1:1270*4)];
y1=load('Label_fusion.mat');
Y=y1.Label;
%Y=Y(:1:1270*2);
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
        test_count = min(30, num_samples); % 前30个光谱作为测试集
    else
        test_count = min(60, num_samples); % 其它类别前60个光谱作为测试集
    end
    
    % 分配测试集和训练集
    test_idx = [test_idx; class_indices(1:test_count)]; % 添加测试集索引
    train_idx = [train_idx; class_indices(test_count+1:end)];  % 添加训练集索引
end

% 提取训练集和测试集
TrainData = X(train_idx, :);
Label_train = Y(train_idx);
TestData = X(test_idx, :);
Label_test = Y(test_idx);
% 输出数据集大小
%fprintf('训练集大小: %d\n', size(X_train, 1));
%fprintf('测试集大小: %d\n', size(X_test, 1));
% 检查结果
    %% RF caculation

trainlabel_out=transfer(Label_train,9);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',500);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,Y_pre,9);
CVSC=[CVSC;statis_SC];
%%
Acurracy_SC=mean(CVSC);
sigma_SC=std(CVSC);