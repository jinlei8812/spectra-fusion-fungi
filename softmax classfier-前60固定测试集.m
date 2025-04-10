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
temperature_indices = [1,2,3,4,5]; % ѡ����¶��������� 37��C, 45��C, 50��C��
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
% ������ݼ���С
%fprintf('ѵ������С: %d\n', size(X_train, 1));
%fprintf('���Լ���С: %d\n', size(X_test, 1));
% �����
    %% RF caculation
trainlabel_out=transfer(Label_train,9);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',500);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,Y_pre,9);
CVSC=[CVSC;statis_SC];
Acurracy_SC=mean(CVSC);
sigma_SC=std(CVSC);