%Practica 2 del tercer parcial. Identificacion de objetos (coloreo)
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc % limpiar pantalla
clear all % limpiar todo
close all % cierra todo
warning off all % Elimina los warnings

[file,path] = uigetfile('*.png;*.jpg;*.webp;*.svg;*.bmp','Archivos de imagen');
img = imread(path+""+file);
[width, height, colors] = size(img);
figure(1);
b = rgb2gray(img);
c=im2bw(b);
imshow(img);
grid on
hold on
mapa = b;
for i=1:width  
    for j=1:height
        mapa(i,j) = 0;        
    end
end
ultimoColor = 1;
grupos = {};
for i=1:width
    for j=1:height
        if(c(i,j) == false && mapa(i,j) == 0)                         
            [mapa,grupos] = busca(mapa, c, i, j, ultimoColor,width,height,grupos);             
            ultimoColor = ultimoColor+1;          
        end        
    end
end
fprintf("En la imagen hay %d objetos\n",ultimoColor-1);
colores = hsv(ultimoColor-1);
labels = {};
for i = 1:ultimoColor-1
    color = colores(i,:);
    labels{i} = "Objeto " + i;
    plot(grupos{i}(:,2),grupos{i}(:,1),'ko','MarkerSize',5,"Color",color,'MarkerFaceColor',color);
end
legend(labels,'Location','east','Orientation','vertical');
function [mapaNuevo,nuevosGrupos] = busca(mapaActual, imagen, x, y, colorActual, width, height,gruposActuales)
    mapaNuevo = mapaActual;    
    nuevosGrupos = gruposActuales;
    if(x <= 0 || y <= 0 || x > width || y > height)        
        return;
    end
    if(mapaActual(x,y) == 0 && imagen(x,y) == false)        
        mapaNuevo(x,y) = colorActual;   
        try
            nuevosGrupos{colorActual} = [nuevosGrupos{colorActual}; [x y]];      
        catch
            nuevosGrupos{colorActual} = [x y];
        end
        
        if(x+1 >0 && x+1 <= width && mapaActual(x+1,y) == 0 && imagen(x+1,y) == false)
            [mapaNuevo,nuevosGrupos] = busca(mapaNuevo, imagen, x+1, y, colorActual,width,height,nuevosGrupos);
        end
        if(y+1 >0 && y+1 <= height && mapaActual(x,y+1) == 0 && imagen(x,y+1) == false)
            [mapaNuevo,nuevosGrupos] = busca(mapaNuevo, imagen, x, y+1, colorActual,width,height,nuevosGrupos);
        end
        if(x-1 >0 && x-1 <= width && mapaActual(x-1,y) == 0 && imagen(x-1,y) == false)
            [mapaNuevo,nuevosGrupos] = busca(mapaNuevo, imagen, x-1, y, colorActual,width,height,nuevosGrupos);
        end
        if(y-1 >0 && y-1 <= height && mapaActual(x,y-1) == 0 && imagen(x,y-1) == false)
            [mapaNuevo,nuevosGrupos] = busca(mapaNuevo, imagen, x, y-1, colorActual,width,height,nuevosGrupos);
        end
    end
end
