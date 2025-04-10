clc,clear;
%% 训练集
x1=load('spectra_fusion.mat');
X0=x1.spectra_combined;
%X=[X0(:,1:1270*1);X0(:,1+1270*1)];
y1=load('Label_fusion.mat');
Y=y1.Label;
%%
% 温度索引和分段定义
num_dims = 1270; % 每个温度光谱的维度
temperature_indices = [1,2,3,4]; % 选择的温度索引（如 37°C, 45°C, 50°C）
fusion_num=size(temperature_indices,2);
% 初始化融合光谱
fused_spectrum_selected = [];
% 提取和组合每个温度的光谱
for i = temperature_indices
    start_col = (i-1) * num_dims + 1; % 起始列
    end_col = i * num_dims;          % 结束列
    fused_spectrum_selected = [fused_spectrum_selected,X0(:, start_col:end_col)];
end
X=fused_spectrum_selected;
%Y=Y0(1:1270*2,:);
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
%% 计算每个菌种的平均光谱
A=TrainData;
B=Label_train;
unique_classes = unique(B);  % 获取所有唯一的菌种类别
num_classes = length(unique_classes);
[n, m] = size(A);
avgSpectra = zeros(num_classes, m);  % 预分配平均光谱矩阵
    for i = 1:num_classes
        class_id = unique_classes(i);
        row_indices = find(B == class_id);  % 找到该类别的所有行索引
        
        % 输出菌种类别及其行数范围
       % fprintf('菌种 %d: 行数范围 [%d, %d], 共 %d 行\n', class_id, min(row_indices), max(row_indices), length(row_indices));
        
        % 计算该菌种的平均光谱
        avgSpectra(i, :) = mean(A(row_indices, :), 1);
    end
   % plot( avgSpectra(8, :));

%%  计算待测矩阵相似度
%lambda_raw=load('lambda.mat');
%lambda=lambda_raw.lambda;
lambda_new=linspace(1, 1270*fusion_num, 1270*fusion_num);
tolerance = 3; % 默认 ±3
num_A = size(avgSpectra, 1); % A 中菌种数量
num_B = size(TestData, 1); % B 中菌种数量
cos_sim = []; % 余弦相似度矩阵
cos_id=[];
pearson_sim = [];% Pearson 相关性矩阵
pearson_id=[];
  for i = 1:num_B
        cos_match_idx = 0; % 存储当前 B 样品的最佳匹配菌种
        cos_similarity = 0; % 记录最高相似度
        pearson_match_idx = 0; % 存储当前 B 样品的最佳匹配菌种
        pearson_similarity = 0; % 记录最高相似度
        for j = 1:num_A
            % 计算余弦相似度
            spectrum1=avgSpectra(j,:);
            [peaks1, locs1] = findpeaks(spectrum1,lambda_new', 'MinPeakProminence', 0.05);
            spectrum2=TestData(i,:);
            [peaks2, locs2] = findpeaks(spectrum2, lambda_new', 'MinPeakProminence', 0.05);
   % 进行峰位匹配（使用用户定义的容差范围）
        matched_locs2 = match_peaks(locs1, locs2, tolerance);
    % 校正目标光谱，使其峰位对齐
         corrected_spectrum2 = align_peaks(lambda_new, spectrum2, locs2, matched_locs2);
   % 计算校正后相似度
          cosineSim(i,j) = cosine_similarity(spectrum1, corrected_spectrum2);  %夹角余弦
          pearsonCorr(i,j) = corr(spectrum1', corrected_spectrum2', 'Type', 'Pearson');% Pearson 相似度
     %比较夹角余弦相似度
          if  cosineSim(i,j) > cos_similarity
                    cos_similarity =cosineSim(i,j);
                    cos_match_idx = j; % 记录匹配的标准菌种
          end
      % 比较Pearson相似度
            if   pearsonCorr(i,j) > pearson_similarity
                    pearson_similarity =pearsonCorr(i,j);
                    pearson_match_idx = j; % 记录匹配的标准菌种
            end 
        end
        cos_sim=[cos_sim,cos_similarity];
        cos_id=[cos_id, cos_match_idx];
        pearson_sim =[pearson_sim, pearson_similarity];
        pearson_id=[pearson_id,pearson_match_idx];
  end
    cos_results=[cos_sim',cos_id'];
    pearson_results=[pearson_sim', pearson_id'];
   %% 比较和输出最终结果
  Threshold=0.85;
  n1=size(cos_results,1);
  for i=1:n1
      if  cos_results(i,1)<Threshold
         cos_results(i,2)=0;
      end
      if  pearson_results(i,1)<Threshold
         pearson_results(i,2)=0;
      end
  end
  %%  相似度计算
  %夹角余弦
resum_cos=[Label_test,cos_results(:,2)];
statis_cos=CVaccuration( Label_test,cos_results(:,2),9);
Acurracy_cos=mean(statis_cos);
% Pearson相似度
resum_pearson=[Label_test,pearson_results(:,2)];
statis_pearson=CVaccuration( Label_test,pearson_results(:,2),9);
Acurracy_pearson=mean(statis_pearson);
  
  