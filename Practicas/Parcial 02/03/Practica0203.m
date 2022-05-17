%Practica 3 del segundo parcial Algoritmos no supervisados
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc % limpiar pantalla
clear all % limpiar todo
close all % cierra todo
warning off all % Elimina los warnings

img = imread("/Users/rene/Desktop/EujhT2dWYAgXriZ.jpg");
figure(1);

imshow(img);
figure(1)
grid on
hold on

[width, height, colors] = size(img);
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

N = round(max([width height]) * 2);
x = randi(width, N);
y = randi(height, N);

muestras = {};
for i = 1:N
    R_muestra = single(R(x(i),y(i)));
    G_muestra = single(G(x(i),y(i)));
    B_muestra = single(B(x(i),y(i)));
    muestras{i} = [x(i) y(i) R_muestra G_muestra B_muestra];
end


grupos = {};
colores = {};
for i = 1:length(muestras)
    N_grupos = length(grupos);
    muestra = muestras{i};

    if i == 1
        grupos{1} = [muestra];
        continue;
    end

    
    distancias = zeros(1, N_grupos);
    for j = 1:N_grupos
        centroide = mean(grupos{j}, 1);
        distancias(j) = norm(muestra(3:5) - centroide(3:5));
    end
    [minimo, grupo] = min(distancias);


    if minimo < 140
        grupos{grupo} = [grupos{grupo}; muestra];
    else
        grupos{N_grupos + 1} = [muestra];
    end
end


colores = hsv(length(grupos));
labels = {};
for i = 1:length(grupos)
    color = 1 - (mean(grupos{i}(:,3:5), 1)/255);
    color = colores(i,:);
    labels{i} = "Grupo " + i;
    plot(grupos{i}(:,2),grupos{i}(:,1),'ko','MarkerSize',5,"Color",color,'MarkerFaceColor',color);
end
legend(labels,'Location','east','Orientation','vertical');
