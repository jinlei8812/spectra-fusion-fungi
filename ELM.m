clc,clear;
x1=load('spectra_37.mat');
X=x1.spectra_combined;
y1=load('number_37.mat');
Y=y1.Label;
% �������
%N = 65; % ���ò��Լ���С�������޸�Ϊ������������
unique_labels = unique(Y); % ��ȡ�������
test_indices = []; % ���ڴ洢���Լ�������
train_indices = []; % ���ڴ洢ѵ����������
CVSC=[];
SC_Avreage=[];
SC_sigma=[];
for i = 1:length(unique_labels)
    % ��ȡ��ǰ������������
    label = unique_labels(i);
    label_indices = find(Y == label);
    % ����Ƿ����㹻��������
    if length(label_indices) < N
        error('��� %d ������������ %d���޷��ָ�', label, N);
    end
    % ��ȡ���Լ������ N ������
    test_indices = [test_indices; label_indices(end-N+1:end)];
    % ��ȡѵ��������������
    train_indices = [train_indices; label_indices(1:end-N)];
end
% ����ѵ�����Ͳ��Լ�
TrainData = X(train_indices, :);
Label_train = Y(train_indices);
TestData = X(test_indices, :);
Label_test = Y(test_indices);
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