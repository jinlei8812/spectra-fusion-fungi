function corrected_spectrum = align_peaks(lambda, spectrum, peak_positions, shift_values)
    % lambda: ԭʼ����
    % spectrum: ԭʼ����
    % peak_positions: ��ҪУ���ķ�λ��
    % shift_values: ÿ�����ƫ��������
    
    corrected_lambda = lambda;  % ����ԭʼ����
    for i = 1:length(peak_positions)
        % ���������Χ�ڣ��ҵ��ӽ�Ŀ����λ��
        idx = find(abs(lambda - peak_positions(i)) < 3, 1);
        if ~isempty(idx)
            corrected_lambda(idx) = lambda(idx) - shift_values(i);  % ������λ��
        end
    end
    
    % ? **��ֹ��ֵ����ȷ�� corrected_lambda �ǵ�������**
    [corrected_lambda, unique_idx] = unique(corrected_lambda);  
    spectrum = spectrum(unique_idx);  % ���ֶ�Ӧ�Ĺ�������
    
    % ���в�ֵУ����ȷ���� NaN��
    corrected_spectrum = interp1(corrected_lambda, spectrum, lambda, 'spline', 'extrap');
end
