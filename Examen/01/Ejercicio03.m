clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings
clases = {};
medias = {};
etiquetas = {};
while true
    minimo = input("Ingrese el minimo: ");
    maximo = input("Ingrese el maximo: ");
    if minimo <= 0 || maximo <= minimo        
        disp("Los valores son invalidos");
    else
        break
    end
end
clases = {};
clases{1} = [0;0];
clases{2} = [0;0];
for i=minimo:maximo
    punto=[i;i];
    if(isprime(i))
        if(length(clases{1})) == 0
            clases{1} = punto;
        else
             clases{1} = [clases{1},punto];
        end
    else
        if(length(clases{2})) == 0
            clases{2} = punto;
        else
            clases{2} = [clases{2},punto];
        end
    end
end
clases{1}(:,1) = []; %limpiar el [0;0]
clases{2}(:,1) = []; %limpiar el [0;0]
medias{1} = mean(clases{1},2);
medias{2} = mean(clases{2},2);
etiquetas = {};
etiquetas{1} = "Clase 1";
etiquetas{2} = "Clase 2";
etiquetas{3} = "Vector desconocido";
disp("Clase 1: Números primos");
disp("Clase 2: Números no-primos");
vector = input("Ingrese el vector desconocido: ");
if vector < minimo || vector > maximo
    disp("El vector no es valido");
else
    vector = [vector;vector];
    % Limpiar grafica
    clf
    % Grafica las clases
    graficarClases(clases);
    % Graficando el vector desconocido
    plot(vector(1,:),vector(2,:), 'ko','MarkerSize',10,'MarkerFaceColor','k');
    % Imprimir las etiquetas de las clases
    legend(etiquetas,'Location','east','Orientation','vertical');
    graficarClases(clases);
    porKNN(vector, clases, medias);
end

function graficarClases(clases)
    grid on %Poner una cuadricula
    hold on %Mantener lo que se haga despues del primer plot
    cmap = hsv(length(clases));
    for i = 1:length(clases)
        plot(clases{i}(1,:), clases{i}(2,:),'o','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i       
    end
end

%Por K Nearest Neighbors (Los K vecinos mas cercanos)
function porKNN(x, clases, medias)
    posicionActual = 1;
    for i=1:length(clases)
        clase = clases{i};        
        for j=1:length(clase)
            elemento = clase(:,j);            
            %calculando las distancias a todos y cada de los elementos
            distancias(posicionActual,1) = norm(x-elemento); %Calculamos la distancia del elemento al vector
            distancias(posicionActual,2) = i; %Guardamos la clase a la que pertenece la distancia
            posicionActual = posicionActual+1;
        end
    end

    lista_ordenada = sortrows(distancias); %Ordenamos el arreglo de distancias para tenerlas por la menor    
    vecinos = 2;
    while mod(vecinos,2) == 0
        vecinos = input('dame el número k de vecinos que deseas clasificar = ');
        if mod(vecinos,2) == 0
            disp("El número de vecinos debe ser impar");
        end        
    end
    disp("Los K vecinos mas cercanos son: \n");
    encuentra_clase = lista_ordenada(1:vecinos,2);    
    for d=1:vecinos        
        fprintf("El vecino de la clase %d con una distancia de %d\n",lista_ordenada(d,2),lista_ordenada(d,1));
    end

    [gc, gr] = groupcounts(encuentra_clase);

    for i=1:length(gr)
        probabilidades(i, 1) = gc(i)/vecinos;
        probabilidades(i, 2) = gr(i);
        fprintf("La probabilidad de la Clase %d es: %d%%\n",probabilidades(i, 2),probabilidades(i, 1)*100);
    end

    encuentra_clase = mode(encuentra_clase);

    [probabilidad_maxima, indice] = max(probabilidades(:,1));
    probabilidad_clase = probabilidades(indice, 2);

    fprintf('Modo por clase: El vector pertenece a la clase %d\n',encuentra_clase);
    fprintf('Modo por probabilidades: El vector pertenece a la clase %d\n', probabilidad_clase);

end

