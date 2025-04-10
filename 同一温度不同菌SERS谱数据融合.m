%% Combine fungi SERS data collected at different temperatures.
clc,clear;
% 定义变量
temp_value =70; % 可更改为60, 50等其他数值
temp_str = num2str(temp_value); % 将数值转换为字符串
%%  白色念珠菌
file_BL = ['fina_bailian_', temp_str, '.mat']; % 动态生成文件名
x_BL1=load(file_BL); % change temperature 
x_BL_2=x_BL1.fina_spectra;
x_BL=x_BL_2(:,2:end);
[~,m1]=size(x_BL);
label_BL=ones(1,m1);
%% 光滑念珠菌
file_GH = ['GH_', temp_str, '.mat']; % 动态生成文件名
x_GH1 = load(file_GH);
x_GH_2=x_GH1.fina_spectra;
x_GH=x_GH_2(:,2:end);
[~,m2]=size(x_GH);
label_GH=2*ones(1,m2);
%% 热带念珠菌
file_RL = ['RJ_', temp_str, '.mat']; % 动态生成文件名
x_RL1=load(file_RL); % change temperature 
x_RL_2=x_RL1.fina_spectra;
x_RL=x_RL_2(:,2:end);
[~,m3]=size(x_RL);
label_RL=3*ones(1,m3);
%%  镰刀菌
file_LD = ['fina_liandao_', temp_str, '.mat']; % 动态生成文件名
x_LD1=load(file_LD); % change temperature 
x_LD_2=x_LD1.fina_spectra;
x_LD=x_LD_2(:,2:end);
[~,m4]=size(x_LD);
label_LD=4*ones(1,m4);
%% 青霉菌
file_QM = ['fina_qingmei_', temp_str, '.mat']; % 动态生成文件名
x_QM1=load(file_QM); % change temperature 
x_QM_2=x_QM1.fina_spectra;
x_QM=x_QM_2(:,2:end);
[~,m5]=size(x_QM);
label_QM=5*ones(1,m5);
%%  土曲霉
file_TQ = ['TQ_', temp_str, '.mat']; % 动态生成文件名
x_TQ1=load(file_TQ); % change temperature 
x_TQ_2=x_TQ1.fina_spectra;
x_TQ=x_TQ_2(:,2:end);
[~,m6]=size(x_TQ);
label_TQ=6*ones(1,m6);
%% 红色毛癣菌
file_HM = ['HM_', temp_str, '.mat']; % 动态生成文件名
x_HM1 = load(file_HM);
x_HM_2=x_HM1.fina_spectra;
x_HM=x_HM_2(:,2:end);
[~,m7]=size(x_HM);
label_HM=7*ones(1,m7);
%% 黄曲霉
file_HQ = ['fina_huangqu_', temp_str, '.mat']; % 动态生成文件名
x_HQ1=load(file_HQ); % change temperature 
x_HQ_2=x_HQ1.fina_spectra;
x_HQ=x_HQ_2(:,2:end);
[~,m8]=size(x_HQ);
label_HQ=8*ones(1,m8);
%%  酵母菌
file_JM = ['fina_jiaomu_', temp_str, '.mat']; % 动态生成文件名
x_JM1=load(file_JM); % change temperature 
x_JM_2=x_JM1.fina_spectra;
x_JM=x_JM_2(:,2:end);
[~,m9]=size(x_JM);
label_JM=9*ones(1,m9);
%% Combine data
spectra_combined = [x_BL'; x_GH';x_RL'; x_LD'; x_QM';x_TQ';x_HM'; x_HQ'; x_JM'];
Label = [label_BL'; label_GH';label_RL'; label_LD'; label_QM';label_TQ';label_HM'; label_HQ'; label_JM'];
%% Save SERS data at one temperature
file_spectra = ['spectra_', temp_str, '.mat']; % Dynamic file name
file_number = ['number_', temp_str, '.mat']; % Dynamic file name
save(file_spectra, 'spectra_combined'); % Save combined spectra
save(file_number, 'Label'); % Save labels




