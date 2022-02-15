%Practica 1
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings

%Solicitar del usuario la cantidad de clases
cantidadDeClases = input("Cuantas clases se deben generar: ");
clases = {};
for i = 1:cantidadDeClases
    cantidadRepresentantes = input("Cuantos representantes tendra la clase "+i+": ");
    ubicacion = input("Ubicación de la clase "+i+": ");
    dispersion = input("Dispersion de la clase "+i+": ");
    clases{i} = (rand(2,cantidadRepresentantes)+ubicacion)*dispersion;
end
disp(clases);

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

%Graficando el vector desconocido
plot(vector(1,:),vector(2,:), 'ko','MarkerSize',10,'MarkerFaceColor','k'); %Graficar el vector

[minimo,index] = min(distancias); %Se obtiene el valor menor del arreglo
if minimo > norm(mean(clases{index},2) - [0;0]) %Asume que solo puede pertenecer a la clase si su distancia es menor, a la del centroide con respecto al origen
    fprintf("El vector desconocido no pertenece a ninguna clase\n"); %Imprimir que no pertenece
else
    fprintf("El vector desconocido pertence a la clase: %d\n", index); %Imprimir la clase a la que pertenece
end

disp("fin del programa");
