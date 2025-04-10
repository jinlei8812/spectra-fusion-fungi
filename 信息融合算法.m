% �����ļ�����ͨ�ò���
spectraPrefix = 'spectra_';
spectraSuffix = '.mat';
labelPrefix = 'number_';
labelSuffix = '.mat';
% �����ļ���ŷ�Χ
fileNumbers = [50,60,70]; % �ɸ���ʵ���ļ��������
% ��ʼ���������
results = [];
for num = fileNumbers
    % �����ļ���
    spectraName = [spectraPrefix, num2str(num), spectraSuffix];
    labelName = [labelPrefix, num2str(num), labelSuffix];
    % �����ļ� (ȷ��������ͳһ��������Ҫ��������)
    spectraData = load(spectraName);
    labelData = load(labelName);
    if isfield(spectraData, 'spectra_combined') && isfield(labelData, 'Label')
        X = spectraData.spectra_combined; % ��������
        Y = labelData.Label; % ��ǩ����
    else
        error(['�ļ���δ�ҵ�����: ', spectraName, ' �� ', labelName]);
    end

    % ��ȡ������������
    unique_classes = unique(Y); % ��ȡ�������
    train_idx = []; % ѵ��������
    test_idx = [];  % ���Լ�����

    for i = 1:length(unique_classes)
        class = unique_classes(i);
        class_indices = find(Y == class); % �ҵ���ǰ��������
        num_samples = length(class_indices);
        
        % ����������ò��Լ���С
        if class == 7 % ���� C �������� 7 ��ʾ
            test_count = min(30, num_samples); % ǰ30��������Ϊ���Լ�
        else
            test_count = min(60, num_samples); % �������ǰ60��������Ϊ���Լ�
        end

        % ������Լ���ѵ����
        test_idx = [test_idx; class_indices(1:test_count)]; % ��Ӳ��Լ�����
        train_idx = [train_idx; class_indices(test_count+1:end)]; % ���ѵ��������
    end

    % ��ȡѵ�����Ͳ��Լ�
    TrainData = X(train_idx, :);
    Label_train = Y(train_idx);
    TestData = X(test_idx, :);
    Label_test = Y(test_idx);

    % ������ݼ���С
    %fprintf('�ļ� %s: ѵ������С %d, ���Լ���С %d\n', spectraName, size(TrainData, 1), size(TestData, 1));

    % ����ģ��ѵ����Ԥ��
    trainlabel_out = transfer(Label_train, 9); % ���� transfer ���Զ��庯��
    net = trainSoftmaxLayer(TrainData', trainlabel_out', 'MaxEpochs', 500); % Softmax��ѵ��
    Y_pre1 = net(TestData'); % Ԥ��

    % ����ת��Ϊ��ֵ�����
    output_pre1 = math_transfer(Y_pre1); % ���� math_transfer ���Զ��庯��
    Y_pre = bina_transfer(output_pre1); % ���� bina_transfer ���Զ��庯��

    % �洢������
    results = [results, Y_pre]; % ƴ���о���
end

% ���յĽ������
%disp('����������:');
%disp(results);
% ���� results ����������
% �б�ʾ����Ĺ�����Ŀ���б�ʾ��ͬ�¶ȵļ����
% ��������1, 2, 3, 4 �ȱ�ʾ��������
%% ��ʼ�����ս������
finalResults = nan(size(results, 1), 1); % ÿ�����ս��

% ����ÿһ�н��
for i = 1:size(results, 1)
    row = results(i, :); % ��ȡ��ǰ��
    uniqueVals = unique(row, 'sorted'); % ��ǰ�е�Ψһֵ
    counts = histcounts(row, [uniqueVals - 0.5, uniqueVals(end) + 0.5]); % ͳ��ÿ����������

    % �ҵ����ռ�ȵ����
    [maxCount, maxIdx] = max(counts); 
    maxFraction = maxCount / length(row);
    finalLabel = uniqueVals(maxIdx);

    % ����Ƿ����� 60% ��ռ������
    if maxFraction >= 0.6
        finalResults(i) = finalLabel; % ��¼���ֵ
    else
        % ����Ƿ������������ֵ���
        equalCounts = find(counts == maxCount); % �ҵ�������ȵ��������
        if length(equalCounts) == 2
            % ���ֻ��������ֵ��ȣ���ȡ�����ֵ
            finalResults(i) = uniqueVals(equalCounts(1)); % ��ѡһ������
        else
            % �޷�����
            finalResults(i) = -1; % ���Ϊ�޷�����
        end
    end
end


% ������ս��
disp('���ս������:');
disp(finalResults);

% �����Ҫ��������浽�ļ���
% save('finalResults.mat', 'finalResults');
%X_result=[results,finalResults];
%%
resum=[Label_test,finalResults];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,finalResults,9);
%CVSC=[CVSC;statis_SC];
% ������ս��
disp('���ս������:');
disp(finalResults);

% �����Ҫ��������浽�ļ���
% save('finalResults.mat', 'finalResults');
