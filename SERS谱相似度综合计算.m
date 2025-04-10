clc,clear;
%% ѵ����
x1=load('spectra_fusion.mat');
X0=x1.spectra_combined;
%X=[X0(:,1:1270*1);X0(:,1+1270*1)];
y1=load('Label_fusion.mat');
Y=y1.Label;
%%
% �¶������ͷֶζ���
num_dims = 1270; % ÿ���¶ȹ��׵�ά��
temperature_indices = [1,2,3,4]; % ѡ����¶��������� 37��C, 45��C, 50��C��
fusion_num=size(temperature_indices,2);
% ��ʼ���ںϹ���
fused_spectrum_selected = [];
% ��ȡ�����ÿ���¶ȵĹ���
for i = temperature_indices
    start_col = (i-1) * num_dims + 1; % ��ʼ��
    end_col = i * num_dims;          % ������
    fused_spectrum_selected = [fused_spectrum_selected,X0(:, start_col:end_col)];
end
X=fused_spectrum_selected;
%Y=Y0(1:1270*2,:);
% �������
% ���� X �ǹ��׾���Y ������ǩ����
% X: N x M ����, Y: N x 1 ����
unique_classes = unique(Y); % ��ȡ�������
train_idx = []; % ѵ��������
test_idx = [];  % ���Լ�����
CVSC=[];
for i = 1:length(unique_classes)
    class = unique_classes(i);
    class_indices = find(Y == class); % �ҵ���ǰ��������
    num_samples = length(class_indices);
    
    if class == 7 % ���� C �������� 3 ��ʾ
        test_count = min(30, num_samples); % ǰ30��������Ϊ���Լ�
    else
        test_count = min(60, num_samples); % �������ǰ60��������Ϊ���Լ�
    end
    
    % ������Լ���ѵ����
    test_idx = [test_idx; class_indices(1:test_count)]; % ��Ӳ��Լ�����
    train_idx = [train_idx; class_indices(test_count+1:end)];  % ���ѵ��������
end

% ��ȡѵ�����Ͳ��Լ�
TrainData = X(train_idx, :);
Label_train = Y(train_idx);
TestData = X(test_idx, :);
Label_test = Y(test_idx);
%% ����ÿ�����ֵ�ƽ������
A=TrainData;
B=Label_train;
unique_classes = unique(B);  % ��ȡ����Ψһ�ľ������
num_classes = length(unique_classes);
[n, m] = size(A);
avgSpectra = zeros(num_classes, m);  % Ԥ����ƽ�����׾���
    for i = 1:num_classes
        class_id = unique_classes(i);
        row_indices = find(B == class_id);  % �ҵ�����������������
        
        % ������������������Χ
       % fprintf('���� %d: ������Χ [%d, %d], �� %d ��\n', class_id, min(row_indices), max(row_indices), length(row_indices));
        
        % ����þ��ֵ�ƽ������
        avgSpectra(i, :) = mean(A(row_indices, :), 1);
    end
   % plot( avgSpectra(8, :));

%%  �������������ƶ�
%lambda_raw=load('lambda.mat');
%lambda=lambda_raw.lambda;
lambda_new=linspace(1, 1270*fusion_num, 1270*fusion_num);
tolerance = 3; % Ĭ�� ��3
num_A = size(avgSpectra, 1); % A �о�������
num_B = size(TestData, 1); % B �о�������
cos_sim = []; % �������ƶȾ���
cos_id=[];
pearson_sim = [];% Pearson ����Ծ���
pearson_id=[];
  for i = 1:num_B
        cos_match_idx = 0; % �洢��ǰ B ��Ʒ�����ƥ�����
        cos_similarity = 0; % ��¼������ƶ�
        pearson_match_idx = 0; % �洢��ǰ B ��Ʒ�����ƥ�����
        pearson_similarity = 0; % ��¼������ƶ�
        for j = 1:num_A
            % �����������ƶ�
            spectrum1=avgSpectra(j,:);
            [peaks1, locs1] = findpeaks(spectrum1,lambda_new', 'MinPeakProminence', 0.05);
            spectrum2=TestData(i,:);
            [peaks2, locs2] = findpeaks(spectrum2, lambda_new', 'MinPeakProminence', 0.05);
   % ���з�λƥ�䣨ʹ���û�������ݲΧ��
        matched_locs2 = match_peaks(locs1, locs2, tolerance);
    % У��Ŀ����ף�ʹ���λ����
         corrected_spectrum2 = align_peaks(lambda_new, spectrum2, locs2, matched_locs2);
   % ����У�������ƶ�
          cosineSim(i,j) = cosine_similarity(spectrum1, corrected_spectrum2);  %�н�����
          pearsonCorr(i,j) = corr(spectrum1', corrected_spectrum2', 'Type', 'Pearson');% Pearson ���ƶ�
     %�Ƚϼн��������ƶ�
          if  cosineSim(i,j) > cos_similarity
                    cos_similarity =cosineSim(i,j);
                    cos_match_idx = j; % ��¼ƥ��ı�׼����
          end
      % �Ƚ�Pearson���ƶ�
            if   pearsonCorr(i,j) > pearson_similarity
                    pearson_similarity =pearsonCorr(i,j);
                    pearson_match_idx = j; % ��¼ƥ��ı�׼����
            end 
        end
        cos_sim=[cos_sim,cos_similarity];
        cos_id=[cos_id, cos_match_idx];
        pearson_sim =[pearson_sim, pearson_similarity];
        pearson_id=[pearson_id,pearson_match_idx];
  end
    cos_results=[cos_sim',cos_id'];
    pearson_results=[pearson_sim', pearson_id'];
   %% �ȽϺ�������ս��
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
  %%  ���ƶȼ���
  %�н�����
resum_cos=[Label_test,cos_results(:,2)];
statis_cos=CVaccuration( Label_test,cos_results(:,2),9);
Acurracy_cos=mean(statis_cos);
% Pearson���ƶ�
resum_pearson=[Label_test,pearson_results(:,2)];
statis_pearson=CVaccuration( Label_test,pearson_results(:,2),9);
Acurracy_pearson=mean(statis_pearson);
  
  