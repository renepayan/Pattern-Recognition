clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings

%PROGRAMA QUE CALCULA LA TOMA DE DECISIONES ENTRE LAS DOS CLASES DADO UN
%VECTOR DESCONOCIDO

%INTRODUCIR LOS DATOS DE MIS CLASES

c1 = [1,3,1,2,3;2,3,5,2,3]; %Primera clase
c2 = [6 6 7 8 8; 4 3 4 4 5]; %Segunda clase

vx = input("Dame las coordenadas del vector en x=");
vy = input("Dame las coordenadas del vector en y=");
vector = [vx;vy]; %Vector desconocido

%Calculando los parámetros por cada clase

media1 = mean(c1,2); %Calcular la media/promedio/centro de gravedad de la primer clase
media2 = mean(c2,2); %Calcular la media/promedio/centro de gravedad de la segunda clase

dist1 = norm(media1-vector); %Calcular la distancia euclidiana entre el vector y la media de la primer clase
dist2 = norm(media2-vector); %Calcular la distancia euclidiana entre el vector y la media de la segunda clase

%GRAFICANDO LAS CLASES
plot(c1(1,:),c1(2,:), 'ro','MarkerSize',10,'MarkerFaceColor','r'); %Graficar la primer clase
grid on %Poner una cuadricula
hold on %Mantener lo que se haga despues del primer plot
plot(c2(1,:),c2(2,:), 'bo','MarkerSize',10,'MarkerFaceColor','b'); %Graficar la segunda clase
plot(vector(1,:),vector(2,:), 'ko','MarkerSize',10,'MarkerFaceColor','k'); %Graficar el vector
legend('clase 1','Clase 2','Vector')


dato = [dist1,dist2]; %Se crea un arreglo con las distancias obtenidas
minimo = min(dato); %Se obtiene el valor menor del arreglo
dato2 = find(minimo == dato); %Se busca cual es la posicion del elemento menor en el arreglo

fprintf("El vector desconocido pertence a la clase: %\n", dato2); %Imprimir la clase a la que pertenece
disp("fin del programa");