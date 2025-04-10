function avgSpectra = compute_avg_spectra(A, B, N)
    unique_classes = unique(B);  % ��ȡ����Ψһ�ľ������
    num_classes = length(unique_classes);
    [n, m] = size(A);
    
    avgSpectra = zeros(num_classes, m);  % Ԥ����ƽ�����׾���
    
    for i = 1:num_classes
        class_id = unique_classes(i);
        row_indices = find(B == class_id);  % �ҵ�����������������
        num_samples = length(row_indices);
        
        % ����þ��ֵ���������N�����ȡǰN�м���ƽ������
        if num_samples > N
            row_indices = row_indices(1:N);
            num_samples = N;
        end
        
        % ������������������Χ
        fprintf('���� %d: ������Χ [%d, %d], ѡȡ %d ��\n', class_id, min(row_indices), max(row_indices), num_samples);
        
        % ����þ��ֵ�ƽ������
        avgSpectra(i, :) = mean(A(row_indices, :), 1);
    end
end