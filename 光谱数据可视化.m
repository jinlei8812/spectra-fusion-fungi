clear,clc;
x1=load('fina_MSSA.mat');
x_spectra=x1.a;
%axis1=load('SERS_axis.mat');
%SERS_axis=axis1.axis;
%x_tr_tong=mapminmax(x_spectra,0,1);
y=[1 50 400];
x=[1800 400];
%spectra=[x_spectra1,x_spectra2,x_spectra3]';
%plot(spectra(2,:));
clims = [1000 30000];
imagesc(x,y,x_spectra',clims);
%colorv=parula(1000);
colormap(summer);
%%
axis square
set(gca,'ytick',[])
set(gca,'TickDir','out');
set(gca,'Fontsize',15,'LineWidth',3,'Fontweight','bold','Fontname','Times New Man')
xlabel('Raman shift/cm^{-1}','Fontsize',20,'Fontweight','bold','Fontname','Times New Man');
ax=gca;
ax.YAxis.Visible='off';
box off;
ax2=axes('Position',get(gca,'Position'),...
         'XAxisLocation','top',...
          'YAxisLocation','right',...
          'Color','none',...
          'XColor','k','YColor','k');
 set(ax2,'YTick',[]);
 set(ax2,'XTick',[]);   


