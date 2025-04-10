%%  �ٴ����
clc,clear;
%% ��ȡѵ����
x1=load('spectra_fusion.mat');
X0=x1.spectra_combined;
%X=[X0(:,1:1270*1);X0(:,1+1270*1)];
y1=load('Label_fusion.mat');
Y=y1.Label;
%% ��ȡ��������
%37
x_37=load('RYL_37.mat');
x_37spectra=x_37.fina_spectra(:,2:end);
%45
x_45=load('RYL_45.mat');
x_45spectra=x_45.fina_spectra(:,2:end);
%50
x_50=load('RYL_50.mat');
x_50spectra=x_50.fina_spectra(:,2:end);
%60
x_60=load('RYL_60.mat');
x_60spectra=x_60.fina_spectra(:,2:end);
%70 
x_70=load('RYL_70.mat');
x_70spectra=x_70.fina_spectra(:,2:end);
Clinical=[x_37spectra',x_45spectra',x_50spectra',x_60spectra',x_70spectra'];
% temperature SERS spectra fusion
%%  �����ں��¶�ѡ��

%%
% �¶������ͷֶζ���
num_dims = 1270; % ÿ���¶ȹ��׵�ά��
temperature_indices = [1,2,3,4]; % ѡ����¶��������� 1,2,3,4,5,�ֱ��Ӧ37��C, 45��C, 50��C,60,70��
% ��ʼ���ںϹ���
fused_trainspectrum_selected = [];
fused_testspectrum_selected = [];
% ��ȡ�����ÿ���¶ȵĹ���
for i = temperature_indices
    start_col = (i-1) * num_dims + 1; % ��ʼ��
    end_col = i * num_dims;          % ������
    fused_trainspectrum_selected = [fused_trainspectrum_selected,X0(:, start_col:end_col)];
    fused_testspectrum_selected = [fused_testspectrum_selected,Clinical(:, start_col:end_col)];
end

TrainData = fused_trainspectrum_selected;
Label_train = Y;
TestData = fused_testspectrum_selected;
Label_test = 2*ones(size(Clinical,1),1);

%% Machine learning model
trainlabel_out=transfer(Label_train,9);
net = trainSoftmaxLayer(TrainData',trainlabel_out','MaxEpochs',500);
Y_pre1= net(TestData');
output_pre1=math_transfer(Y_pre1);% ��������ת��Ϊ0��1�������Y_re��ֵС��0.5����Ϊ0
Y_pre=bina_transfer(output_pre1);% ��������ת��Ϊ1�����еĶ�����
resum=[Label_test,Y_pre];
%cell{j,i}=resum;



