% ����ָ�����ƶȼ��㣨��λƥ�䣩
 clc; clear; close all;
 % �û������ƥ�����Χ
 tolerance = input('�������ƥ�����Χ (nm)���� Enter ʹ��Ĭ��ֵ ��2 nm: ');
  if isempty(tolerance)
        tolerance = 3; % Ĭ�� ��3 nm
  end
  fprintf('ʹ�÷�ƥ����Χ: ��%.2f nm\n', tolerance);
  %%  ��ȡ����
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
  % ��ȡ��λ
  [peaks1, locs1] = findpeaks(spectrum1, lambda, 'MinPeakProminence', 0.05);
  [peaks2, locs2] = findpeaks(spectrum2, lambda, 'MinPeakProminence', 0.05);
  % ���з�λƥ�䣨ʹ���û�������ݲΧ��
  matched_locs2 = match_peaks(locs1, locs2, tolerance);
    % У��Ŀ����ף�ʹ���λ����
  corrected_spectrum2 = align_peaks(lambda, spectrum2, locs2, matched_locs2);
 % ����У�������ƶ�
    cosineSim = cosine_similarity(spectrum1, corrected_spectrum2);  %�н�����
    pearsonCorr = corr(spectrum1, corrected_spectrum2, 'Type', 'Pearson');% Pearson ���ƶ�
    jaccard_sim = jaccard_similarity(spectrum1, corrected_spectrum2, 0.5)%Jaccard ���ƶ�
    rho = corr(spectrum1, spectrum2, 'Type', 'Spearman');
    %Ou_similarity = 1 / (1 + norm(spectrum1 - corrected_spectrum2));