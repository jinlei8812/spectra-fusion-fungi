%Reconsctruct all txt into one
% ��ȡ��ǰĿ¼�µ�����.txt�ļ�
clc,clear;
fileList = dir('*.txt');
% ����ÿ���ļ����򿪡���ȡ���ݻ�����������
a=[];
for i = 1:length(fileList)
    fileName = fileList(i).name; % ��ȡ�ļ���
    x_data=load(fileName);
    a=[a,x_data(:,2)];
    % ������Ҫ���ļ�������Ӧ�Ĳ���
    %fprintf('���ڴ����ļ���%s\n', fileName);
end
fina_spectra=[x_data(:,1),a];
avreage_spectra=[x_data(:,1),mean(a,2)];
savename = 'firstadd_0.067mg.mat';
%save(savename, 'fina_spectra');
dlmwrite('firstadd_0.067mg.txt',avreage_spectra,'delimiter', ' ');
plot(avreage_spectra(:,1),avreage_spectra(:,2))
%x2=mean(fina_jinpu_blank(:,2:end),2);