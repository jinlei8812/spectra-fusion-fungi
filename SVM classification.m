%% SVM predicting
clear,clc;
x1_mssa=load('fina_MSSA.mat');
JP_MSSA=x1_mssa.a';
[n1,m1]=size(JP_MSSA);
label_MSSA=ones(n1,1);
%% 提取金浦
x2_mrsa=load('fina_MRSA.mat');
JP_MRSA=x2_mrsa.a';
[n2,m2]=size(JP_MRSA);
label_MRSA=2*ones(n2,1);
%% 合并数据集
X=[JP_MSSA;JP_MRSA];
Y=[label_MSSA;label_MRSA];
[n,m]=size(X);
%% 训练集划分计算
testRatio = 0.2;
% 训练集索引
trainIndices = crossvalind('HoldOut', n, testRatio);
% 测试集索引
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% 训练集和训练标签
trainData = X(trainIndices, :);
trainLabel =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% 测试集和测试标签
testData = X(testIndices, :);
testLabel = Y(testIndices, :);
%save('testData.mat','testData')
%save('testLabel.mat','testLabel')
%% SVM
SVMModel = fitcsvm(trainData,trainLabel,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
newX=testData;
[Y_pre,score] = predict(SVMModel,newX);
resum=[testLabel,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,2);
CVDT=[CVDT;statis_DT];
end
DT_Avreage=[DT_Avreage;mean(CVDT)];
DT_sigma=[std(CVDT);DT_sigma];
