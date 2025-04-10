% 假设数据存储为一个 cell 数组 spectra，温度数据为 temperature
% 每个单元格包含一个温度下的光谱矩阵，行为光谱数目，列为特征值
% 例如：spectra{1} 是 a 温度的光谱，spectra{2} 是 b 温度的光谱
clc,clear;
%% 37
x1=load('BL_ZKR_37.mat');
x11=x1.fina_spectra';
x37=x11(2:end,:);
%% 45
x2=load('BL_ZKR_45.mat');
x22=x2.fina_spectra';
x45=x22(2:end,:);
%% 50
x3=load('BL_ZKR_50.mat');
x33=x3.fina_spectra';
x50=x33(2:end,:);
%%
x4=load('BL_ZKR_60.mat');
x44=x4.fina_spectra';
x60=x44(2:end,:);
%%
x5=load('BL_ZKR_70.mat');
x55=x5.fina_spectra';
x70=x55(2:end,:);
%% combined to a cell
spectra={x37,x45,x50,x60,x70};
% 获取最大光谱数目
num_temperatures = length(spectra); % 温度种类数
max_num_spectra = max(cellfun(@(x) size(x, 1), spectra)); % 找到最大光谱数
% 获取特征维度
feature_length = size(spectra{1}, 2); % 每个光谱的特征值个数

% 初始化融合矩阵，行为光谱数目，列为不同温度的特征值
fusion_matrix = zeros(max_num_spectra, num_temperatures * feature_length);

% 对每个温度的数据进行处理
for i = 1:num_temperatures
    current_spectra = spectra{i}; % 当前温度的光谱数据
    num_current_spectra = size(current_spectra, 1); % 当前温度的光谱数
    
    if num_current_spectra < max_num_spectra
        % 计算当前温度的平均光谱
        mean_spectrum = mean(current_spectra, 1);
        
        % 用平均光谱补齐
        additional_spectra = repmat(mean_spectrum, max_num_spectra - num_current_spectra, 1);
        current_spectra = [current_spectra; additional_spectra];
    end
    
    % 将当前温度的数据插入融合矩阵
    col_start = (i - 1) * feature_length + 1; % 当前温度特征列的起始位置
    col_end = i * feature_length; % 当前温度特征列的结束位置
    fusion_matrix(:, col_start:col_end) = current_spectra;
end

savename = 'BL_ZKR_fusion.mat';
save(savename, 'fusion_matrix');
% 输出的 fusion_matrix 即为所需的 2D 矩阵
% 行：光谱数目（补齐后统一为 max_num_spectra）
% 列：不同温度的光谱特征值拼接