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
CVSC=[];
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
%% softmax classifier
for i=1:15
hiddenSize=50;
autoenc = trainAutoencoder(TrainData', hiddenSize,'MaxEpochs',500, ...
    'L2WeightRegularization', 0.01, ...
    'SparsityRegularization', 4, ...
    'SparsityProportion', 0.05, ...
    'DecoderTransferFunction','purelin');
feat1 = encode(autoenc,TrainData');
trainlabel_out=transfer(Label_train,9);
softnet = trainSoftmaxLayer(feat1,trainlabel_out','MaxEpochs',500);
stackednet = stack(autoenc,softnet);
%% Compute accuracy
Y_pre1 = stackednet(TestData');
%%  caculation
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration( Label_test,Y_pre,9);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=mean(CVSC);
SC_sigma=std(CVSC);

