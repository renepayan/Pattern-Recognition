clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings
clases = {};
etiquetas = {};
puntos = [1 0 0;0 1 0;1 1 1]; %Clase 2 [todo lo demas]
clases{1} = puntos;
puntos = [1;1;1]; %Clase 1 [x1 = 1, x2 = 1, y = 1]
clases{2} = puntos;
w = [1;1;1];
etiquetas{1} = "Clase 1";
etiquetas{2} = "Clase 2";
etiquetas{3} = "Perceptron";
graficarClases(clases);
wn = perceptron(clases, w,1);
graficarRecta(wn, etiquetas);
fprintf("La ecuación de la recta es: %dx+%dy+%d = 0\n",wn(1),wn(2),wn(3));
function wn = perceptron(clases,w,r)
    i = 1;
    while(true)
        fprintf("Iteración: %d\n",i);        
        huboError = false;
        for j = 1:length(clases)
            clase = clases{j};          
            tope = length(clase);
            if(j == 2)
                tope = 1;
            end
            for k = 1:tope                          
                elemento = clase(:,k);  
                fprintf("Clase: %d\n",j);
                fprintf("W0 = %d\nW1 = %d\nW2 = %d\n",w(1),w(2),w(3));            
                fprintf("x0 = %d\nx1 = %d\nx2 = %d\n",elemento(1),elemento(2),elemento(3));                        
                fsal = elemento'*w;                
                fprintf("fsal = w*xi' = %d\n",fsal);
                if fsal >= 0 && j == 1
                    huboError = true; 
                    fprintf("wn+1 = wn-r*xi\n");
                    w = w-r*elemento;
                    
                elseif fsal <= 0 && j == 2
                    huboError = true;
                    fprintf("wn+1 = wn+r*xi\n");
                    w = w+r*elemento;
                else
                    fprintf("No cumple ninguna de las 2 condiciones, no se re calcula w\n");
                end                   
            end
        end    
        i = i+1;
        if(not(huboError))
            break;
        end   
    end
    fprintf("Le tomo %d iteraciones encontrar el perceptron\n",i-1);
    wn = w;
end
function graficarClases(clases)
    grid on %Poner una cuadricula    
    hold on %Mantener lo que se haga despues del primer plot
    cmap = hsv(length(clases));
    for i = 1:length(clases)         
        plot(clases{i}(1,:), clases{i}(2,:),'O','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i       
    end    
end
function graficarRecta(recta, etiquetas)
 x = -1.5:1.5;
 y = (recta(1)*x + recta(3))/((-1)*recta(2));
 plot(x,y);
 legend(etiquetas,'Location','east','Orientation','vertical');
end
