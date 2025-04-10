function tuoqiu(location,radius,tou)
[xx,yy,zz]=sphere(30);%30是画出来的球面的经纬分面数...30的话就是30个经度, 30个纬度
xx=location(:,1)+radius(:,1)*xx;           % 圆心:(4,2,0)   半径:7
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
alpha(tou)         %设置透明度
shading flat       %
colormap winter
%for i=1:8
% view(360/8*i,30);
 %pause(0.1);
%end
