% 光谱指纹相似度计算（峰位匹配）
 clc; clear; close all;
 % 用户输入峰匹配的误差范围
 tolerance = input('请输入峰匹配的误差范围 (nm)，按 Enter 使用默认值 ±2 nm: ');
  if isempty(tolerance)
        tolerance = 3; % 默认 ±3 nm
  end
  fprintf('使用峰匹配误差范围: ±%.2f nm\n', tolerance);
  %%  提取光谱
  load_spectra=load('fina_bailian60.mat');
  raw_spectra=load_spectra.fina_spectra;
  lambda=unique(raw_spectra(:,1));
  save('lambda.mat','lambda');
  spectrum1=mean(raw_spectra(:,2:32),2);
  %plot(lambda,spectrum1);
  loadtest_spectra=load('GH_60.mat');
  rawtest_spectra=loadtest_spectra.fina_spectra;
  %spectrum1=mean(raw_spectra(:,2:32),2);
  spectrum2=rawtest_spectra(:,2);
  % 提取峰位
  [peaks1, locs1] = findpeaks(spectrum1, lambda, 'MinPeakProminence', 0.05);
  [peaks2, locs2] = findpeaks(spectrum2, lambda, 'MinPeakProminence', 0.05);
  % 进行峰位匹配（使用用户定义的容差范围）
  matched_locs2 = match_peaks(locs1, locs2, tolerance);
    % 校正目标光谱，使其峰位对齐
  corrected_spectrum2 = align_peaks(lambda, spectrum2, locs2, matched_locs2);
 % 计算校正后相似度
    cosineSim = cosine_similarity(spectrum1, corrected_spectrum2);  %夹角余弦
    pearsonCorr = corr(spectrum1, corrected_spectrum2, 'Type', 'Pearson');% Pearson 相似度
    jaccard_sim = jaccard_similarity(spectrum1, corrected_spectrum2, 0.5)%Jaccard 相似度
    rho = corr(spectrum1, spectrum2, 'Type', 'Spearman');
    %Ou_similarity = 1 / (1 + norm(spectrum1 - corrected_spectrum2));