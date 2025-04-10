clear,clc;
x1_mssa=load('fina_MSSA.mat');
JP_MSSA=x1_mssa.a';
[n1,m1]=size(JP_MSSA);
label_MSSA=ones(n1,1);
%% ��ȡ����
x2_mrsa=load('fina_MRSA.mat');
JP_MRSA=x2_mrsa.a';
[n2,m2]=size(JP_MRSA);
label_MRSA=2*ones(n2,1);
%% �ϲ����ݼ�
x_train=[JP_MSSA;JP_MRSA];
y_label=[label_MSSA;label_MRSA];
%% ѵ�������ּ���
testRatio = 0.2;
% ѵ��������
trainIndices = crossvalind('HoldOut',n, testRatio);
% ���Լ�����
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% ѵ������ѵ����ǩ
trainData = X(trainIndices, :);
trainLabel =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% ���Լ��Ͳ��Ա�ǩ
testData = X(testIndices, :);
testLabel = Y(testIndices, :);
%save('testData.mat','testData')
%save('testLabel.mat','testLabel')
%% softmax classifier
trainlabel_out=transfer(trainLabel,6);
net = trainSoftmaxLayer(trainData',trainlabel_out','MaxEpochs',200);
Y_pre= net(testData');
%% Compute accuracy
output_pre1=math_transfer(Y_pre);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
output_practical=transfer(testLabel,6)';
[n2,m2]=size(output_practical);
error=0;
for i=1:n2
    for j=1:m2
        if(abs(output_practical(i,j)-output_pre1(i,j)))
            error=error+1;
        end
    end
end
Accuracy=100-100*error/m2;