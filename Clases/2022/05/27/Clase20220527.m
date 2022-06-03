clc
clear all
close all
warning off all
[file,path] = uigetfile('*.png;*.jpg;*.webp;*.svg;*.bmp','Archivos de imagen');
a = imread(path+""+file);
figure(1);
subplot(1,3,1);
imshow(a);
title("Imagen original");
b = rgb2gray(a);
subplot(1,3,2);
imshow(b);
title("Escala de grises");
c=im2bw(b);
subplot(1,3,3);
imshow(c);
title("Binario");
g = bwlabel(c);
h = max(max(g));
objetos=regionprops(c,'Perimeter','Area', 'Centroid', 'BoundingBox');
for k=1:length(objetos)    
    caja=objetos(k).BoundingBox;    
    if(objetos(k).Area > 10000)
        rectangle("Position",[caja(1),caja(2),caja(3),caja(4)],'Edgecolor','b','Linewidth',2);
    else
        rectangle("Position",[caja(1),caja(2),caja(3),caja(4)],'Edgecolor','r','Linewidth',2);
    end
    if((objetos(k).Perimeter^2)/objetos(k).Area>18)
        text(objetos(k).Centroid(1),objetos(k).Centroid(2),"TRIANGULO",'r');
    elseif (objetos(k).Perimeter^2)/objetos(k).Area<14.3
        text(objetos(k).Centroid(1),objetos(k).Centroid(2),'CIRCULO','Color','g')
    else
        text(objetos(k).Centroid(1),objetos(k).Centroid(2),'CUADRADO','Color','g')
    end
end
disp("proceso terminado");
