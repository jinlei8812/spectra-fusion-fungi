function tuoqiu(location,radius,tou)
[xx,yy,zz]=sphere(30);%30�ǻ�����������ľ�γ������...30�Ļ�����30������, 30��γ��
xx=location(:,1)+radius(:,1)*xx;           % Բ��:(4,2,0)   �뾶:7
yy=location(:,2)+radius(:,2)*yy;
zz=location(:,3)+radius(:,3)*zz;
%figure;
set(gcf,'outerposition',get(0,'screensize'));
set(gcf,'color','w');
mesh(xx,yy,zz,'FaceColor','interp','EdgeColor','w','FaceLighting','phong')
%h = mesh(x_axis,y_axis,z_axis,'FaceColor','interp','Edgecolor',[0.9 0.95 0.9],'FaceLighting','phong');
xlabel('x')
ylabel('y')
zlabel('z')
axis equal
alpha(tou)         %����͸����
shading flat       %
colormap winter
%for i=1:8
% view(360/8*i,30);
 %pause(0.1);
%end
