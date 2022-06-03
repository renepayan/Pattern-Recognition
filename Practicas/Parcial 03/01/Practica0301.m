%Practica 2 del tercer parcial. Identificacion de objetos (conteo)
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
subplot(1,3,1);
imshow(img);
title("Imagen original");
b = rgb2gray(img);
subplot(1,3,2);
imshow(b);
title("Escala de grises");
c=im2bw(b);
subplot(1,3,3);
imshow(c);
title("Binario");
mapa = b;
for i=1:width  
    for j=1:height
        mapa(i,j) = 0;
        
    end
end
ultimoColor = 1;
for i=1:width
    for j=1:height
        if(c(i,j) == false && mapa(i,j) == 0)            
            mapa = busca(mapa, c, i, j, ultimoColor,width,height);
            ultimoColor = ultimoColor+1;
        end        
    end
end

fprintf("En la imagen hay %d objetos\n",ultimoColor-1);
function mapaNuevo = busca(mapaActual, imagen, x, y, colorActual, width, height)
    mapaNuevo = mapaActual;    
    if(x <= 0 || y <= 0 || x > width || y > height)        
        return;
    end
    if(mapaActual(x,y) == 0 && imagen(x,y) == false)        
        mapaNuevo(x,y) = colorActual;
        if(x+1 >0 && x+1 <= width && mapaActual(x+1,y) == 0 && imagen(x+1,y) == false)
            mapaNuevo = busca(mapaNuevo, imagen, x+1, y, colorActual,width,height);
        end
        if(y+1 >0 && y+1 <= height && mapaActual(x,y+1) == 0 && imagen(x,y+1) == false)
            mapaNuevo = busca(mapaNuevo, imagen, x, y+1, colorActual,width,height);
        end
        if(x-1 >0 && x-1 <= width && mapaActual(x-1,y) == 0 && imagen(x-1,y) == false)
            mapaNuevo = busca(mapaNuevo, imagen, x-1, y, colorActual,width,height);
        end
        if(y-1 >0 && y-1 <= height && mapaActual(x,y-1) == 0 && imagen(x,y-1) == false)
            mapaNuevo = busca(mapaNuevo, imagen, x, y-1, colorActual,width,height);
        end
    end
end
