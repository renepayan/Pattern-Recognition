clc %limpiar pantalla
clear all %Elimina todas las variables
close all %cierra todo
warning off all %Elimina las advertencias

%Programa que calcula la toma de decisiones entre dos clases
%Para un elemento desconocido en 3D

%Definir clases:
c1 = [0 1 1 1; 0 0 1 0; 0 0 0 1];
c2 = [0 0 1 0; 0 1 1 1; 1 1 1 0];
%vectorDesconocido = [0.3; 1; 0.7];
vx = input("Dame la coordenada del vector en x=");
vy = input("Dame la coordenada del vector en y=");
vz = input("Dame la coordenada del vector en z=");
vectorDesconocido = [vx; vy; vz];

%Graficando las variables
figure(1)
plot3(c1(1,:), c1(2,:), c1(3,:), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
%plot3: grafica en 3d
%Eje X (Primera dimension de C1)
%Eje Y (Primera dimension de C2)
%Eje Z (Primera dimension de C3)
%Color de linea rojo, con puntito relleno
%Tipo de letra MarkerSize
%Tamaño 10
%Tipo de color MarkerFaceColor
%Color de la letra: Azul 
grid on %Poner una cuadricula
hold on %Mantener el dibujo
plot3(c2(1,:), c2(2,:), c2(3,:), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot3(vectorDesconocido(1,:), vectorDesconocido(2,:), vectorDesconocido(3,:), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
legend('Clase1', 'Clase2', 'Vector desconocido'); %La leyenda de las 2 graficas

%Proceso matematico
media1 = mean(c1,2);
media2 = mean(c2,2);

dist1 = norm(media1-vectorDesconocido);
dist2 = norm(media2-vectorDesconocido);
dist_tot = [dist1,dist2];
minimo = min(min(dist_tot));
dato = find(dist_tot == minimo);

fprintf("El vector desconocido pertenece a la clase %d\n",(dato));
disp("fin de proceso")
