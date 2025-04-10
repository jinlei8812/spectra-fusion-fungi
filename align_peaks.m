function corrected_spectrum = align_peaks(lambda, spectrum, peak_positions, shift_values)
    % lambda: 原始波长
    % spectrum: 原始光谱
    % peak_positions: 需要校正的峰位置
    % shift_values: 每个峰的偏移修正量
    
    corrected_lambda = lambda;  % 复制原始波长
    for i = 1:length(peak_positions)
        % 在误差允许范围内，找到接近目标峰的位置
        idx = find(abs(lambda - peak_positions(i)) < 3, 1);
        if ~isempty(idx)
            corrected_lambda(idx) = lambda(idx) - shift_values(i);  % 修正峰位置
        end
    end
    
    % ? **防止插值错误：确保 corrected_lambda 是单调递增**
    [corrected_lambda, unique_idx] = unique(corrected_lambda);  
    spectrum = spectrum(unique_idx);  % 保持对应的光谱数据
    
    % 进行插值校正（确保无 NaN）
    corrected_spectrum = interp1(corrected_lambda, spectrum, lambda, 'spline', 'extrap');
end
