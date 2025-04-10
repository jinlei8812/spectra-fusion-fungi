function exp_visulization(xdat,r)
%clc,clear;
%ԭʼ���ݴ���
%xdat=score_test(:,1:3);
xm = mean(xdat); % ��ֵ
[n,m]=size(xdat); % �۲�����
colorv=jet(n);
xd = xdat-repmat(xm,[n,1]);
%%
%�ָ�ԭʼ����
x = xdat(:,1);
y = xdat(:,2);
z = xdat(:,3);
s = inv(cov(xdat));  % Э�������������
%r= chi2inv(0.95,3);  %%�����ֲ����95%���Ŷȵ�ֵ
%TitleText = '95%�������򣨻�����̬�ֲ���';
%r=20;
TitleText = '99.73%�������򣨻��ھ���ֲ���';      
rd = sum(xd*s.*xd,2); %%%���rd=x^2/��1+y^2/��2+z^3/��3
%%
% ��󻯴���
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
xyz =V*[x_axis(:)';y_axis(:)';z_axis(:)'];  % ������ת
x_axis = reshape(xyz(1,:),size(x_axis))+xm(1);
y_axis = reshape(xyz(2,:),size(y_axis))+xm(2);
z_axis = reshape(xyz(3,:),size(z_axis))+xm(3);
%h = mesh(x_axis,y_axis,z_axis,'FaceLighting','gouraud','LineWidth',0.01);  % ��������������ͼ
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
%��ɢ��ͶӰ�������У��۲�ֲ����
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
plot3(xm(1),xm(2),xm(3),'r+');  % ������
hold off;
%colormap gray
 writegif('С��KPCA������ά����.gif',frame,1);
 view(3);