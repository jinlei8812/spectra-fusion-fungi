function exp_visulization(xdat,r)
%clc,clear;
%原始数据处理
%xdat=score_test(:,1:3);
xm = mean(xdat); % 均值
[n,m]=size(xdat); % 观测组数
colorv=jet(n);
xd = xdat-repmat(xm,[n,1]);
%%
%分割原始矩阵
x = xdat(:,1);
y = xdat(:,2);
z = xdat(:,3);
s = inv(cov(xdat));  % 协方差矩阵的逆矩阵
%r= chi2inv(0.95,3);  %%卡方分布求得95%置信度的值
%TitleText = '95%置信椭球（基于正态分布）';
%r=20;
TitleText = '99.73%置信椭球（基于经验分布）';      
rd = sum(xd*s.*xd,2); %%%求得rd=x^2/λ1+y^2/λ2+z^3/λ3
%%
% 最大化窗口
figure;
set(gcf,'outerposition',get(0,'screensize'));
set(gcf,'color','w');
%%%  Calculate the meshgrid  and start drawing the pictures
[V, D]=eig(s); 
aa = sqrt(r/D(1,1));
bb = sqrt(r/D(2,2));
cc = sqrt(r/D(3,3));
[u,v] = meshgrid(linspace(-pi,pi,30),linspace(0,2*pi,30));
x_axis = aa*cos(u).*cos(v);
y_axis = bb*cos(u).*sin(v);
z_axis = cc*sin(u);
xyz =V*[x_axis(:)';y_axis(:)';z_axis(:)'];  % 坐标旋转
x_axis = reshape(xyz(1,:),size(x_axis))+xm(1);
y_axis = reshape(xyz(2,:),size(y_axis))+xm(2);
z_axis = reshape(xyz(3,:),size(z_axis))+xm(3);
%h = mesh(x_axis,y_axis,z_axis,'FaceLighting','gouraud','LineWidth',0.01);  % 绘制椭球面网格图
h = mesh(x_axis,y_axis,z_axis,'FaceColor','interp','Edgecolor',[0.9 0.95 0.9],'FaceLighting','phong');
alpha(0.01)
%set(h,'color','w')
hidden on;
hold on
%colormap white;
set(gca,'FontWeight','bold','Color',[0.3 0.3 0.3],'FontSize',14);
xlabel('X')
ylabel('Y')
zlabel('Z')
h=title(TitleText);
set(h,'color','m','fontsize',20);
grid on;
%feval('alpha',0.5)
%%
%将散点投影至椭球中，观察分布情况
 for i=1:n
    if(rd(i,:)<=r)
           plot3(x(i,:),y(i,:),z(i,:),'color',colorv(i,:),'Marker','p','MarkerFaceColor',colorv(i,:),'MarkerSize',20);
           % scatter3(x(i,:),y(i,:),z(i,:),10+i*0.5,'Marker','o','MarkerFaceColor',colorv(i,:),'MarkerEdgeColor',colorv(i,:))
          hold on;
    else
             plot3(x(i,:),y(i,:),z(i,:),'color',colorv(i,:),'Marker','v','MarkerFaceColor',colorv(i,:),'MarkerSize',30);
             % scatter3(x(i,:),y(i,:),z(i,:),10+i*0.5,'Marker','v','MarkerFaceColor',colorv(i,:),'MarkerEdgeColor',colorv(i,:))
            hold on;
    end
   % rotate3d
    pause(0.1);
 view(360/n*i,30);
 frame(i)=getframe(gcf);
 %axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(z_axis) max(z_axis) min(colorv) max(colorv)]);
 end  
plot3(xm(1),xm(2),xm(3),'r+');  % 椭球中
hold off;
%colormap gray
 writegif('小波KPCA经验三维坐标.gif',frame,1);
 view(3);