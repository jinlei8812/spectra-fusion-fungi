%%二维云图：
%% 提取光谱
clear,clc;
x1_CRKP=load('fina_CRKP.mat');
FK_CRKP=x1_CRKP.a';
[n1,m1]=size(FK_CRKP);
label_CRKP=ones(n1,1);
mean_CRKP=mean(FK_CRKP)';
SD_CRKP=std(FK_CRKP)';
%% 提取金浦
x1_CSKP=load('fina_CSKP.mat');
FK_CSKP=x1_CSKP.a';
[n2,m2]=size(FK_CSKP);
label_CSKP=2*ones(n2,1);
mean_CSKP=mean(FK_CSKP)';
SD_CSKP=std(FK_CSKP)';
%% 合并数据集
x_train=[FK_CRKP;FK_CSKP];
y_label=[label_CRKP;label_CSKP];
%% K-fold crassvalid交叉验证计算
%x_train=bacteria_score;
[n,m]=size(x_train);
CVDT=[];
DT_Avreage=[];
DT_sigma=[];
%% CV
k=10;
indices=crossvalind('KFold',n,k);
%% calculation
for j=1:15
for i=1:k
	test=(indices==i); %结果为逻辑值，每次循环选取一个组作为测试集
	train=~test; %取test的补集即为训练集
	TrainData=x_train(train,:); %提取训练集数据 
	TestData=x_train(test,:); %提取测试集数据
    Label_train=y_label(train,:);
    Label_test=y_label(test,:);
%% softmax classifier
trainlabel_out=transfer(Label_train,2);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',1000);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,2);
CVDT=[CVDT;statis_DT];
end
end
DT_Avreage=[DT_Avreage;mean(CVDT)];
DT_sigma=[std(CVDT);DT_sigma];

%%
X=x_train;
Y=y_label;
[n,m]=size(X);
testRatio = 0.2;
% 训练集索引
trainIndices = crossvalind('HoldOut', n, testRatio);
% 测试集索引
%save('trainIndices.mat','trainIndices')
testIndices = ~trainIndices;
% 训练集和训练标签
TrainData = X(trainIndices, :);
Label_train =Y(trainIndices, :);
%save('trainData.mat','trainData')
%save('trainLabel.mat','trainLabel')
% 测试集和测试标签
TestData= X(testIndices, :);
Label_test = Y(testIndices, :);
%save('testData.mat','testData')
%save('testLabel.mat','testLabel')
%% SOftmax
%% softmax classifier
trainlabel_out=transfer(Label_train,2);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',500);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[Label_test,Y_pre];
statis_DT=CVaccuration( Label_test,Y_pre,2);
%CVDT=[CVDT;statis_DT];
%% confusion matrix
m=confusionmat(Label_test,Y_pre);
statesNE = ["CRKP","CSKP "]
classlabels=categorical(statesNE);
cm = confusionchart(m,classlabels);
cm.Normalization = 'row-normalized';
sortClasses(cm,'descending-diagonal');
cm.Normalization = 'absolute';
%% %% save 
