clc
clear all
close all
warning off all
%programa para generar 3 clases, con m representantes cada una

%generando clases de datos

c1x=randn(1,1000);
c1y=randn(1,1000);
c1=[c1x(:,:);c1y(:,:)];

c2x=randn(1,1000)+5;
c2y=randn(1,1000)+10;
c2=[c2x(:,:);c2y(:,:)];

c3x=(randn(1,1000)-8)*3;
c3y=(randn(1,1000)-15)*3;
c3=[c3x;c3y];

vx=input('dame el valor del punto en la coord x=')
vy=input('dame el valor del punto en la coor y=')
vector=[vx;vy]

media1=mean(c1,2);
media2=mean(c2,2);
media3=mean(c3,2);

dist1=norm(media1-vector);
dist2=norm(media2-vector);
dist3=norm(media3-vector);

dist_tot=[dist1 dist2 dist3]
minimo=min(dist_tot)
dato2=find(minimo==dist_tot)

fprintf('el vector desconocido pertenece a la clase%d\n',dato2)



figure(1)
plot(c1x(1,:),c1y(1,:),'ro','MarkerSize',10,'MarkerFaceColor','r')
grid on
hold on
plot(c2x(1,:),c2y(1,:),'bo','MarkerSize',10,'MarkerFaceColor','g')
plot(c3x(1,:),c3y(1,:),'ko','MarkerSize',10,'MarkerFaceColor','r')
plot(vector(1,:),vector(2,:),'yo','MarkerSize',10,'MarkerFaceColor','y')
legend('clase1','clase2','clase3','punto')



disp('fin de proceso.....')





