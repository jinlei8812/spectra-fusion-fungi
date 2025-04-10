%% 提取光谱
clc,clear;
%% 训练集
x1=load('train_spectra.mat');
x_train= x1.spectra_train;
y1=load('label_train.mat');
y_train_label=y1.Label_train;
%% 测试集
x2=load('test_spectra.mat');
x_test= x2.spectra_test;
y2=load('label_test.mat');
y_test_label=y2.Label;
%% Softmax caculation
%[n,m]=size(x_train);
CVSC=[];
%SC_Avreage=[];
%SC_sigma=[];
for i=1:15
trainlabel_out=transfer(y_train_label,4);
net = trainSoftmaxLayer(x_train',trainlabel_out','MaxEpochs',500);
Y_pre1= net(x_test');
output_pre1=math_transfer(Y_pre1);% 将计算结果转化为0和1，即如果Y_re的值小于0.5，则为0
Y_pre=bina_transfer(output_pre1);% 将计算结果转化为1个阵列的多种类
resum=[y_test_label,Y_pre];
%cell{j,i}=resum;
statis_SC=CVaccuration(y_test_label,Y_pre,4);
CVSC=[CVSC;statis_SC];
end
SC_Avreage=mean(CVSC);
SC_sigma=std(CVSC);