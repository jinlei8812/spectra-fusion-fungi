clc,clear;
%% ѵ����
x1=load('spectra_37.mat');
X=x1.spectra_combined;
y1=load('number_37.mat');
Y=y1.Label;
% �������
% ���� X �ǹ��׾���Y ������ǩ����
% X: N x M ����, Y: N x 1 ����
unique_classes = unique(Y); % ��ȡ�������
train_idx = []; % ѵ��������
test_idx = [];  % ���Լ�����
for i = 1:length(unique_classes)
    class = unique_classes(i);
    class_indices = find(Y == class); % �ҵ���ǰ��������
    num_samples = length(class_indices);
    
    if class == 7 % ���� C �������� 3 ��ʾ
        test_count = min(30, num_samples); % ���30��������Ϊ���Լ������70�ȵĻ���Ϊ15
    else
        test_count = min(60, num_samples); % ����������60��������Ϊ���Լ�
    end
    
    % ������Լ���ѵ����
    test_idx = [test_idx; class_indices(end-test_count+1:end)]; % ��Ӳ��Լ�����
    train_idx = [train_idx; class_indices(1:end-test_count)];  % ���ѵ��������
end

% ��ȡѵ�����Ͳ��Լ�
TrainData = X(train_idx, :);
Label_train = Y(train_idx);
TestData = X(test_idx, :);
Label_test = Y(test_idx);
% ������ݼ���С
% ������ݼ���С
%fprintf('ѵ������С: %d\n', size(X_train, 1));
%fprintf('���Լ���С: %d\n', size(X_test, 1));
CVSC=[];
%% ����ѧϰ��
%%  ELM
P_train=TrainData';
T_train=Label_train';
%% test datasets
P_test=TestData';
T_test=Label_test';
% net
for i=1:15
[IW,B,LW,TF,TYPE] = elmtrain(P_train,T_train,100,'sig',1);
Y_pre = elmpredict(P_test,IW,B,LW,TF,TYPE);
resum=[Label_test,Y_pre'];
statis_SC=CVaccuration(Label_test,Y_pre',9);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=mean(CVSC);
SC_sigma=std(CVSC);