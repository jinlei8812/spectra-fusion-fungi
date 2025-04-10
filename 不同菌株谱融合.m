%% ²»Í¬¾úÖêÆ×ÈÚºÏ
clc,clear;
%% 70
x1=load('GH_2457_70.mat');
x11=x1.fina_spectra;
%%
x2=load('GH_HSS_70.mat');
x22=x2.fina_spectra;
%%
x3=load('GH_LDY_70.mat');
x33=x3.fina_spectra;
%% 
x4=load('GH3726_70.mat');
x44=x4.fina_spectra;
%%
%x5=load('BL_WNJ_70.mat');
%x55=x5.fina_spectra;
%% 
%x6=load('BL_ZKR_70.mat');
%x66=x5.fina_spectra;
%%
fina_spectra=[x11,x22,x33,x44];
save('GH_70.mat', 'fina_spectra'); % Save combined spectra

