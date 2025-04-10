clc,clear;
%% ѵ����
x1=load('spectra_37.mat');
X=x1.spectra_combined;
y1=load('number_37.mat');
Y=y1.Label;
% �������
% ���� X �ǹ��׾���Y ������ǩ����
% X: N x M ����, Y: N x 1 A����
unique_classes = unique(Y); % ��ȡ�������
train_idx = []; % ѵ��������
test_idx = [];  % ���Լ�����
CVDT=[];
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
CVKNN=[];
    %% training
   for i=1:15
md1=fitcnb(TrainData,Label_train);
Y_pre=predict(md1,TestData);
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_KNN=CVaccuration(Label_test,Y_pre,9);
CVKNN=[CVKNN;statis_KNN];
   end
KNN_Avreage=mean(CVKNN);
KNN_sigma=std(CVKNN);