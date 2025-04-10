%% N=0.25 cal different spectra 
close all; clear all; clc
Without=[5.56	10.42	81.94	62.45	99.91	97.96	100
12.50	32.64	82.64	79.79	99.79	96.67	100
50.00	27.78	80.56	73.22	99.77	89.72	99.31
3.47	12.50	65.97	44.26	99.86	98.40	97.22
22.22	24.31	88.19	59.03	99.98	100	100];
mapminmax=[17.36	20.83	4.86	41.02	56.30	54.70	58.33
33.33	54.17	95.14	69.93	65.32	95.09	47.92
11.11	36.11	94.44	62.64	76.64	98.17	59.03
14.58	30.56	43.06	54.86	78.87	79.05	50.69
-11.81	49.31	50.69	5.93	83.06	88.61	89.58];
zscore=[33.33	28.47	82.64	84.24	97.66	99.86	96.53
13.89	54.17	95.83	80.49	89.31	95.60	82.64
0.69	36.81	55.56	74.56	87.18	96.50	86.11
20.14	20.14	33.33	54.56	92.48	70.19	100
34.72	23.61	93.75	89.95	99.93	100	100];
mapstd=[47.22	11.11	75.69	46.39	95.00	99.72	99.31
36.11	54.86	79.86	68.43	91.44	98.87	96.53
39.58	28.47	86.81	57.57	82.04	99.98	95.83
60.42	18.75	79.17	38.63	55.62	95.37	93.06
4.17	53.47	56.94	6.00	52.87	99.24	94.44];
Res=[mean(Without);mean(mapstd);mean(zscore);mean(mapminmax)];
b=bar3(Res,0.5);
%colorbar
caxis([1 100]);
for k=1:length(b)
    zdata=b(k).ZData;
    b(k).CData=zdata;
    b(k).FaceColor='interp';
end
set(gca,'xticklabel',{'PLS-DA','LDA','DT','ELM','SAE','RF','SC'});
set(gca,'yticklabel',{'No treatment','Mapstd','Mapmimax','Zscore'});
hXLabel=xlabel('ML models','Rotation',22);
hYLabel=ylabel('Spectra normalization methods','Rotation',-35);
hZLabel=zlabel('Accuracy/%');