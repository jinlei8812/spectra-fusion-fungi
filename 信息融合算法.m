% 定义文件名的通用部分
spectraPrefix = 'spectra_';
spectraSuffix = '.mat';
labelPrefix = 'number_';
labelSuffix = '.mat';
% 定义文件编号范围
fileNumbers = [50,60,70]; % 可根据实际文件编号设置
% 初始化结果矩阵
results = [];
for num = fileNumbers
    % 构建文件名
    spectraName = [spectraPrefix, num2str(num), spectraSuffix];
    labelName = [labelPrefix, num2str(num), labelSuffix];
    % 加载文件 (确保变量名统一，否则需要调整代码)
    spectraData = load(spectraName);
    labelData = load(labelName);
    if isfield(spectraData, 'spectra_combined') && isfield(labelData, 'Label')
        X = spectraData.spectra_combined; % 光谱数据
        Y = labelData.Label; % 标签数据
    else
        error(['文件中未找到变量: ', spectraName, ' 或 ', labelName]);
    end

    % 获取所有类别的索引
    unique_classes = unique(Y); % 获取所有类别
    train_idx = []; % 训练集索引
    test_idx = [];  % 测试集索引

    for i = 1:length(unique_classes)
        class = unique_classes(i);
        class_indices = find(Y == class); % 找到当前类别的索引
        num_samples = length(class_indices);
        
        % 根据类别设置测试集大小
        if class == 7 % 假设 C 类用数字 7 表示
            test_count = min(30, num_samples); % 前30个光谱作为测试集
        else
            test_count = min(60, num_samples); % 其它类别前60个光谱作为测试集
        end

        % 分配测试集和训练集
        test_idx = [test_idx; class_indices(1:test_count)]; % 添加测试集索引
        train_idx = [train_idx; class_indices(test_count+1:end)]; % 添加训练集索引
    end

    % 提取训练集和测试集
    TrainData = X(train_idx, :);
    Label_train = Y(train_idx);
    TestData = X(test_idx, :);
    Label_test = Y(test_idx);

    % 输出数据集大小
    %fprintf('文件 %s: 训练集大小 %d, 测试集大小 %d\n', spectraName, size(TrainData, 1), size(TestData, 1));

    % 分类模型训练与预测
    trainlabel_out = transfer(Label_train, 9); % 假设 transfer 是自定义函数
    net = trainSoftmaxLayer(TrainData', trainlabel_out', 'MaxEpochs', 500); % Softmax层训练
    Y_pre1 = net(TestData'); % 预测

    % 数据转换为二值化输出
    output_pre1 = math_transfer(Y_pre1); % 假设 math_transfer 是自定义函数
    Y_pre = bina_transfer(output_pre1); % 假设 bina_transfer 是自定义函数

    % 存储计算结果
    results = [results, Y_pre]; % 拼接列矩阵
end

% 最终的结果矩阵
%disp('计算结果矩阵:');
%disp(results);
% 假设 results 矩阵已生成
% 行表示真菌的光谱数目，列表示不同温度的检测结果
% 分类结果：1, 2, 3, 4 等表示真菌的类别
%% 初始化最终结果矩阵
finalResults = nan(size(results, 1), 1); % 每行最终结果

% 遍历每一行结果
for i = 1:size(results, 1)
    row = results(i, :); % 获取当前行
    uniqueVals = unique(row, 'sorted'); % 当前行的唯一值
    counts = histcounts(row, [uniqueVals - 0.5, uniqueVals(end) + 0.5]); % 统计每个类别的数量

    % 找到最大占比的类别
    [maxCount, maxIdx] = max(counts); 
    maxFraction = maxCount / length(row);
    finalLabel = uniqueVals(maxIdx);

    % 检查是否满足 60% 的占比条件
    if maxFraction >= 0.6
        finalResults(i) = finalLabel; % 记录类别值
    else
        % 检查是否有两个类别数值相等
        equalCounts = find(counts == maxCount); % 找到数量相等的类别索引
        if length(equalCounts) == 2
            % 如果只有两个数值相等，则取其类别值
            finalResults(i) = uniqueVals(equalCounts(1)); % 任选一个即可
        else
            % 无法鉴别
            finalResults(i) = -1; % 标记为无法鉴别
        end
    end
end


% 输出最终结果
disp('最终结果矩阵:');
disp(finalResults);

% 如果需要将结果保存到文件中
% save('finalResults.mat', 'finalResults');
%X_result=[results,finalResults];
%%
resum=[Label_test,finalResults];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,finalResults,9);
%CVSC=[CVSC;statis_SC];
% 输出最终结果
disp('最终结果矩阵:');
disp(finalResults);

% 如果需要将结果保存到文件中
% save('finalResults.mat', 'finalResults');
