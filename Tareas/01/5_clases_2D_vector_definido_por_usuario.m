clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings

%PROGRAMA QUE CALCULA LA TOMA DE DECISIONES ENTRE LAS DOS CLASES DADO UN
%VECTOR DESCONOCIDO

%INTRODUCIR LOS DATOS DE MIS CLASES

clases = {[1,3,1,2,3;2,3,5,2,3], [6 6 7 8 8; 4 3 4 4 5], rand(2,5)+3, rand(2,5)+5, rand(2,5)-5}; %Arreglo con todas las clases

vx = input("Dame las coordenadas del vector en x=");
vy = input("Dame las coordenadas del vector en y=");

vector = [vx;vy];

grid on %Poner una cuadricula
hold on %Mantener lo que se haga despues del primer plot

%Calculando los parámetros por cada clase
distancias = zeros(1,length(clases));
cmap = hsv(length(clases));
for i = 1:length(clases)
    media = mean(clases{i},2); %Calcular la media/promedio/centro de gravedad de la clase i
    distancias(i) = norm(media - vector); %Calcular la distancia euclidiana entre el vector y la media de la clase i
    plot(clases{i}(1,:), clases{i}(2,:),'o','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i
end

%GRAFICANDO LAS CLASES
plot(vector(1,:),vector(2,:), 'ko','MarkerSize',10,'MarkerFaceColor','k'); %Graficar el vector

[minimo,index] = min(distancias); %Se obtiene el valor menor del arreglo
if minimo > norm(mean(clases{i},2) - [0;0])
    fprintf("El vector desconocido no pertenece a ninguna clase\n"); %Imprimir que no pertenece
else
    fprintf("El vector desconocido pertence a la clase: %d\n", index); %Imprimir la clase a la que pertenece
end

disp("fin del programa");
