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
spectra=a';
new_spectra=spectra;
N=1000;
SD=std(new_spectra(:,N));
RSD=SD/mean(new_spectra(:,N));
mean(RSD)
%dlmwrite('DC_80.txt', [std(new_spectra), 'delimiter', ' ');
dlmwrite('TQM_simulation.txt', [mean(new_spectra);std(new_spectra)]', 'delimiter', ' ');
%for i=1:3
%plot(x_data(:,1),spectra(1,:))
%hold on
%end