clc,clear;
x1=load('spectra_37.mat');
X=x1.spectra_combined;
y1=load('number_37.mat');
Y=y1.Label;
% 定义参数
%N = 65; % 设置测试集大小（可以修改为任意正整数）
unique_labels = unique(Y); % 获取所有类别
test_indices = []; % 用于存储测试集的索引
train_indices = []; % 用于存储训练集的索引
CVSC=[];
SC_Avreage=[];
SC_sigma=[];
for i = 1:length(unique_labels)
    % 获取当前类别的所有索引
    label = unique_labels(i);
    label_indices = find(Y == label);
    % 检查是否有足够的样本数
    if length(label_indices) < N
        error('类别 %d 的样本数少于 %d，无法分割', label, N);
    end
    % 获取测试集的最后 N 个样本
    test_indices = [test_indices; label_indices(end-N+1:end)];
    % 获取训练集的其余样本
    train_indices = [train_indices; label_indices(1:end-N)];
end
% 构造训练集和测试集
TrainData = X(train_indices, :);
Label_train = Y(train_indices);
TestData = X(test_indices, :);
Label_test = Y(test_indices);
CVSC=[];
%% 极限学习机
%%  ELM
P_train=TrainData';
T_train=Label_train';
%% test datasets
P_test=TestData';
T_test=Label_test';
% net
for i=1:15
[IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,100,'sig',1);
Y_pre = elmpredict(P_test,IW,B,LW,TF,TYPE);
resum=[Label_test,Y_pre'];
statis_SC=CVaccuration(Label_test,Y_pre',9);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=mean(CVSC);
SC_sigma=std(CVSC);