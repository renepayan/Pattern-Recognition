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
c = not(c);
subplot(1,3,3);
imshow(c);
title("Binario");
g = bwlabel(c,4);
h = max(max(g));
objetos=regionprops(c,'Perimeter','Area', 'Centroid', 'BoundingBox');
triangulos = 0;
circulos = 0;
cuadrados = 0;
for k=1:length(objetos)    
    caja=objetos(k).BoundingBox;    
    if(objetos(k).Area > 10000)
        rectangle("Position",[caja(1),caja(2),caja(3),caja(4)],'Edgecolor','b','Linewidth',2);
    else
        rectangle("Position",[caja(1),caja(2),caja(3),caja(4)],'Edgecolor','r','Linewidth',2);
    end
    try             
        if((objetos(k).Perimeter^2)/objetos(k).Area>18)                        
            triangulos = triangulos+1;
            text(objetos(k).Centroid(1),objetos(k).Centroid(2),'TRIANGULO','Color','g');            
        elseif (objetos(k).Perimeter^2)/objetos(k).Area<14.3
            text(objetos(k).Centroid(1),objetos(k).Centroid(2),'CIRCULO','Color','g');
            circulos = circulos+1;
        else
            text(objetos(k).Centroid(1),objetos(k).Centroid(2),'CUADRADO','Color','g');
            cuadrados = cuadrados+1;
        end
    catch error
        disp(error);
    end    
end
fprintf("Hay:\n%d Circulos\n%d Cuadrados\n%d Triangulos\n",circulos,cuadrados,triangulos);
disp("proceso terminado");
