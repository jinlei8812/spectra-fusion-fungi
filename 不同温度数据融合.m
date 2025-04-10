% �������ݴ洢Ϊһ�� cell ���� spectra���¶�����Ϊ temperature
% ÿ����Ԫ�����һ���¶��µĹ��׾�����Ϊ������Ŀ����Ϊ����ֵ
% ���磺spectra{1} �� a �¶ȵĹ��ף�spectra{2} �� b �¶ȵĹ���
clc,clear;
%% 37
x1=load('BL_ZKR_37.mat');
x11=x1.fina_spectra';
x37=x11(2:end,:);
%% 45
x2=load('BL_ZKR_45.mat');
x22=x2.fina_spectra';
x45=x22(2:end,:);
%% 50
x3=load('BL_ZKR_50.mat');
x33=x3.fina_spectra';
x50=x33(2:end,:);
%%
x4=load('BL_ZKR_60.mat');
x44=x4.fina_spectra';
x60=x44(2:end,:);
%%
x5=load('BL_ZKR_70.mat');
x55=x5.fina_spectra';
x70=x55(2:end,:);
%% combined to a cell
spectra={x37,x45,x50,x60,x70};
% ��ȡ��������Ŀ
num_temperatures = length(spectra); % �¶�������
max_num_spectra = max(cellfun(@(x) size(x, 1), spectra)); % �ҵ���������
% ��ȡ����ά��
feature_length = size(spectra{1}, 2); % ÿ�����׵�����ֵ����

% ��ʼ���ںϾ�����Ϊ������Ŀ����Ϊ��ͬ�¶ȵ�����ֵ
fusion_matrix = zeros(max_num_spectra, num_temperatures * feature_length);

% ��ÿ���¶ȵ����ݽ��д���
for i = 1:num_temperatures
    current_spectra = spectra{i}; % ��ǰ�¶ȵĹ�������
    num_current_spectra = size(current_spectra, 1); % ��ǰ�¶ȵĹ�����
    
    if num_current_spectra < max_num_spectra
        % ���㵱ǰ�¶ȵ�ƽ������
        mean_spectrum = mean(current_spectra, 1);
        
        % ��ƽ�����ײ���
        additional_spectra = repmat(mean_spectrum, max_num_spectra - num_current_spectra, 1);
        current_spectra = [current_spectra; additional_spectra];
    end
    
    % ����ǰ�¶ȵ����ݲ����ںϾ���
    col_start = (i - 1) * feature_length + 1; % ��ǰ�¶������е���ʼλ��
    col_end = i * feature_length; % ��ǰ�¶������еĽ���λ��
    fusion_matrix(:, col_start:col_end) = current_spectra;
end

savename = 'BL_ZKR_fusion.mat';
save(savename, 'fusion_matrix');
% ����� fusion_matrix ��Ϊ����� 2D ����
% �У�������Ŀ�������ͳһΪ max_num_spectra��
% �У���ͬ�¶ȵĹ�������ֵƴ��