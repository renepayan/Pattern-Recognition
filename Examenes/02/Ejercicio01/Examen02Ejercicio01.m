%Practica 4 del segundo parcial Algoritmos semi supervisados
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc % limpiar pantalla
clear all % limpiar todo
close all % cierra todo
warning off all % Elimina los warnings
numClases = 3;
img = imread("/Users/rene/Downloads/examen.jpg");
figure(1);

imshow(img);
figure(1)
grid on
hold on

[width, height, colors] = size(img);
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

N = 300;
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
ultimaPos = 1;
for i = 1:numClases
    for ultimaPos=ultimaPos:N
        muestra = muestras{ultimaPos};
        if(muestra(3) >= 250 && muestra(4) >= 250 && muestra(5) >= 250)            
        else            
            gruposFinales{i} = muestras{i};    
            centroides{i} = mean(gruposFinales{i}, 1);
            break;      
        end        
    end    
    ultimaPos=ultimaPos+1;
end
disp("Inicio:");
graficarCentroides(centroides,1);
numIteracion = 1;
while true
    fprintf("Iteracion %d:\n",numIteracion);
    numIteracion = numIteracion+1;
    nuevosCentroides = centroides;
    grupos = {};
    for i = 1:length(muestras)   
        muestra = muestras{i};          
        if(muestra(3) > 240 && muestra(4) > 240 && muestra(5) > 240)            
        else              
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
    end
    sePuede = true;
    for j=1:numClases        
        if abs(nuevosCentroides{j}(1) - centroides{j}(1)) > 1e-6 | abs(nuevosCentroides{j}(2) - centroides{j}(2)) > 1e-6 | abs(nuevosCentroides{j}(3) - centroides{j}(3)) > 1e-6  
            sePuede = false;
            break;
        end
    end
     graficarCentroides(nuevosCentroides,numIteracion);
    if sePuede
        gruposFinales = grupos;
        break;
    else
        centroides = nuevosCentroides;        
    end       
end
disp("Le tomo "+numIteracion+" resolver los k");
colores = hsv(length(gruposFinales));
labels = {};
for i = 1:length(gruposFinales)
    color = 1 - (mean(grupos{i}(:,3:5), 1)/255);
    color = colores(i,:);
    labels{i} = "Grupo " + i;
    figure(1);
    plot(gruposFinales{i}(:,2),gruposFinales{i}(:,1),'ko','MarkerSize',5,"Color",color,'MarkerFaceColor',color);
end
legend(labels,'Location','east','Orientation','vertical');

function graficarCentroides(centroides,numIteracion)    
    cmap = hsv(3);
    figure(numIteracion+1);
    title("Iteracion "+numIteracion);
    hold on;
    view(3);%Ordenar 3 dimensiones a la cuadricula
    grid on;
    labels = {};
    for i=1:3
        fprintf("Centroide de la clase %d: R = %d, G = %d, B = %d\n",i,centroides{i}(3),centroides{i}(4),centroides{i}(5))               
        plot3(centroides{i}(3), centroides{i}(4), centroides{i}(5),'O','MarkerSize',10,'Color',cmap(i,:)); %Graficar los centroides
        labels{i} = "Centroide de la clase " + i;
    end
    legend(labels,'Location','east','Orientation','vertical');
end