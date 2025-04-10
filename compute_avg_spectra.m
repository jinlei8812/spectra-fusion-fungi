function avgSpectra = compute_avg_spectra(A, B, N)
    unique_classes = unique(B);  % 获取所有唯一的菌种类别
    num_classes = length(unique_classes);
    [n, m] = size(A);
    
    avgSpectra = zeros(num_classes, m);  % 预分配平均光谱矩阵
    
    for i = 1:num_classes
        class_id = unique_classes(i);
        row_indices = find(B == class_id);  % 找到该类别的所有行索引
        num_samples = length(row_indices);
        
        % 如果该菌种的行数大于N，则仅取前N行计算平均光谱
        if num_samples > N
            row_indices = row_indices(1:N);
            num_samples = N;
        end
        
        % 输出菌种类别及其行数范围
        fprintf('菌种 %d: 行数范围 [%d, %d], 选取 %d 行\n', class_id, min(row_indices), max(row_indices), num_samples);
        
        % 计算该菌种的平均光谱
        avgSpectra(i, :) = mean(A(row_indices, :), 1);
    end
end