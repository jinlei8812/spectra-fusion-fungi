%% data fusion computing
clc,clear;
%% °×É«ÄîÖé¾ú
x1=load('BL_fusion.mat');
x_BL=x1.a;
[m1,~]=size(x_BL);
label_BL=ones(1,m1);
%% ¹â»¬ÄîÖé¾ú
x2=load('GH_fusion.mat');
x_GH=x2.a;
[m2,~]=size(x_GH);
label_GH=2*ones(1,m2);
%% ÈÈ´øÄîÖé¾ú
x3=load('RJ_fusion.mat');
x_RJ=x3.fusion_matrix;
[m3,~]=size(x_RJ);
label_RJ=3*ones(1,m3);
%% Á­µ¶¾ú
x4=load('LD_fusion.mat');
x_LD=x4.fusion_matrix;
[m4,~]=size(x_LD);
label_LD=4*ones(1,m4);
%% ÇàÃ¹¾ú
x5=load('QM_fusion.mat');
x_QM=x5.fusion_matrix;
[m5,~]=size(x_QM);
label_QM=5*ones(1,m5);
%% ÍÁÇúÃ¹
x6=load('TQ_fusion.mat');
x_TQ=x6.fusion_matrix;
[m6,~]=size(x_TQ);
label_TQ=6*ones(1,m6);
%% ºìÉ«í®Ñ«¾ü
x7=load('HM_fusion.mat');
x_HM=x7.fusion_matrix;
[m7,~]=size(x_HM);
label_HM=7*ones(1,m7);
%% »ÆÇúÃ¹
x8=load('HQ_fusion.mat');
x_HQ=x8.fusion_matrix;
[m8,~]=size(x_HQ);
label_HQ=8*ones(1,m8);
%% ½ÍÄ¸¾ú
x9=load('JM_fusion.mat');
x_JM=x9.fusion_matrix;
[m9,~]=size(x_JM);
label_JM=9*ones(1,m9);
%%
spectra_combined = [x_BL; x_GH;x_RJ; x_LD; x_QM;x_TQ;x_HM; x_HQ; x_JM];
Label = [label_BL'; label_GH';label_RJ'; label_LD'; label_QM';label_TQ';label_HM'; label_HQ'; label_JM'];
%savename = 'TQ_fusion.mat';
save('spectra_fusion.mat', 'spectra_combined');
save('label_fusion.mat', 'Label');