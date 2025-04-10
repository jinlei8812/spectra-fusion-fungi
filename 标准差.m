%Reconsctruct all txt into one
% 获取当前目录下的所有.txt文件
clc,clear;
fileList = dir('*.txt');
% 遍历每个文件并打开、读取内容或者其他操作
a=[];
for i = 1:length(fileList)
    fileName = fileList(i).name; % 获取文件名
    x_data=load(fileName);
    a=[a,x_data(:,2)];
    % 根据需要对文件进行相应的操作
    %fprintf('正在处理文件：%s\n', fileName);
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