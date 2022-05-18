%Practica 4 del segundo parcial Algoritmos semi supervisados
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc % limpiar pantalla
clear all % limpiar todo
close all % cierra todo
warning off all % Elimina los warnings

[file,path] = uigetfile('*.png;*.jpg;*.webp;*.svg','Archivos de imagen');
numClases = input("Cuantos clases se buscan: ");
img = imread(path+""+file);
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
%N = 10;
x = randi(width, N);
y = randi(height, N);

muestras = {};


for i = 1:N
    R_muestra = single(R(x(i),y(i)));
    G_muestra = single(G(x(i),y(i)));
    B_muestra = single(B(x(i),y(i)));
    muestras{i} = [x(i) y(i) R_muestra G_muestra B_muestra];
end
gruposFinales = {};
centroides = {};
for i = 1:numClases
    gruposFinales{i} = muestras{i};    
    centroides{i} = mean(gruposFinales{i}, 1);
end
while true
    nuevosCentroides = centroides;
    grupos = {};
    for i = 1:length(muestras)    
        muestra = muestras{i};            
        distanciaMenor = realmax;
        claseConDistanciaMenor = 0;
        for j = 1:numClases            
            centroide = nuevosCentroides{j};
            distancia = norm(muestra(3:5) - centroide(3:5));            
            if distancia < distanciaMenor
                distanciaMenor = distancia;
                claseConDistanciaMenor = j;
            end
        end          
        if(length(grupos) < claseConDistanciaMenor)
            grupos{claseConDistanciaMenor} = muestra;
        else
            if length(grupos{claseConDistanciaMenor}) == 0
                grupos{claseConDistanciaMenor} = muestra;
            else
                grupos{claseConDistanciaMenor} = [grupos{claseConDistanciaMenor}; muestra];
            end
        end               
        nuevosCentroides{claseConDistanciaMenor} = mean(grupos{claseConDistanciaMenor}, 1);                
    end
    sePuede = true;
    for j=1:numClases        
        if abs(nuevosCentroides{j}(1) - centroides{j}(1)) > 1e-6 | abs(nuevosCentroides{j}(2) - centroides{j}(2)) > 1e-6 | abs(nuevosCentroides{j}(3) - centroides{j}(3)) > 1e-6 | abs(nuevosCentroides{j}(4) - centroides{j}(4)) > 1e-6 | abs(nuevosCentroides{j}(5) - centroides{j}(5)) > 1e-6            
            sePuede = false;
            break;
        end
    end    
    if sePuede
        gruposFinales = grupos;
        break;
    else
        centroides = nuevosCentroides;
        disp("otra iteracion");
    end
end

colores = hsv(length(gruposFinales));
labels = {};
for i = 1:length(gruposFinales)
    color = 1 - (mean(grupos{i}(:,3:5), 1)/255);
    color = colores(i,:);
    labels{i} = "Grupo " + i;
    plot(gruposFinales{i}(:,2),gruposFinales{i}(:,1),'ko','MarkerSize',5,"Color",color,'MarkerFaceColor',color);
end
legend(labels,'Location','east','Orientation','vertical');
