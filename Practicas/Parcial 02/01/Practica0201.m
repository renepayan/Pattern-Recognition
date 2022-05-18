%Practica 5 Evaluador
%Payán Téllez René
%Romero Lucero Alan
%Zepeta Rivera Jose Antonio

clc % limpiar pantalla
clear all % limpiar todo
close all % cierra todo
warning off all % Elimina los warnings

% Solicita del usuario la cantidad de clases
% y las genera con sus etiquetas para la grafica
[clases, etiquetas, medias] = generaClases( input("¿Cuantas clases se deben generar?: ") );
FIN_DEL_PROGRAMA = 0;
n = 1;

% Graficar clases
graficar(clases, etiquetas);

% Entrar al menu de opciones

while n ~= FIN_DEL_PROGRAMA

    n = input("¿Que clasificador quieres evaluar?\n" + ...
        "1. Distancia euclideana\n" + ...
        "2. Mahalanobis\n" + ...
        "3. Criterio de Bayes\n" + ...
        "4. Critero de KNN\n"+ ...
        "0. Salir\n");

    if n == FIN_DEL_PROGRAMA
        break;
    end
    
    % Aqui deberia iniciar la evaluacion por cada metodo
    clasificador = @porDistanciaEuclideana;
    vecinos = 0;
    switch n
        case 1
            clasificador = @porDistanciaEuclideana;
        case 2
            clasificador = @porMahalanobis;
        case 3
            clasificador = @porCriterioBayes;
        case 4
            while mod(vecinos,2) == 0
                vecinos = input('Dame el número k de vecinos que se clasificaran = ');
                if mod(vecinos,2) == 0
                    disp("El número de vecinos debe ser impar");
                end
            end
            clasificador = @porKNN;
    end

    [~, diagonalesRes, eficienciaRes] = resustitucion(clasificador, clases, medias, vecinos);
    [~, diagonalesCross, eficienciaCross] = crossValidation(clasificador, clases, medias, vecinos);
    [~, diagonalesHold, eficienciaHold] = holdInOne(clasificador, clases, medias, vecinos);
    
    disp("Eficiencia Resustitucion");
    disp(eficienciaRes);
    disp("Eficiencia Cross Validation");
    disp(eficienciaCross);
    disp("Eficiencia Hold In One");
    disp(eficienciaHold);
    
    % Limpiar grafica
    figure
    % plot(1:length(clases), [diagonalesRes diagonalesCross diagonalesHold]);
    hold on
    plot(1:length(clases), [diagonalesRes diagonalesCross diagonalesHold]);
    etiquetas_diagonales = ["Resustitucion", "Cross Validation", "Hold On One"];
    legend(etiquetas_diagonales,'Location','northeast','Orientation','vertical');

end


disp("Fin del programa"); 

% Funcion para limpiar la grafica y volver a graficar, ademas
% de agregar las leyendas
function graficar(clases, etiquetas)
    % Limpiar grafica
    clf
    % Grafica las clases
    graficarClases(clases);
    % Imprimir las etiquetas de las clases
    legend(etiquetas,'Location','east','Orientation','vertical');
end


% Funcion para gener n cantidad de clases
% aleatorias
function [clases, etiquetas, medias] = generaClases(cantidadDeClases)
    clases = {};
    etiquetas = {};
    medias = {};
    numRepresentantes = input("Numero de representantes: ");
    for i = 1:cantidadDeClases
        % Se genera una clase aleatoria
        disp("Clase " + i);
        clase = generaClase2D( ...
            numRepresentantes, ...
            input("Ubicación en X: "), ...
            input("Ubicación en Y: "), ...
            input("Dispersion: ") ...
        );

        % Se calcula su media/promedio/centro de gravedad
        % ya que se estara utilizando
        media = mean(clase, 2);

        % Se almacena la informacion generada
        % para su retorno
        clases{i} = clase;
        etiquetas{i} = "Clase "+i;
        medias{i} = media; 
    end
end


% Funcion que grafica n clases
% Ademas configura la cuadricula y 
% que no se borre la grafica al volver
% a graficar
function graficarClases(clases)
    grid on %Poner una cuadricula
    hold on %Mantener lo que se haga despues del primer plot
    cmap = hsv(length(clases));
    for i = 1:length(clases)
        plot(clases{i}(1,:), clases{i}(2,:),'o','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i       
    end
end


% Funcion para generar una clase
% N: Numero de representantes
% x: Coordenada en x
% y: Coordenada en y
% dispersion: La dispersion de los elementos de la clase
function clase = generaClase2D(N, x, y, dispersion)
    cX = rand(1, N)*dispersion + x;
    cY = rand(1, N)*dispersion + y;
    clase = [cX ; cY];
end


% Funcion para el criterio por distancia euclideana
function numClase = porDistanciaEuclideana(x, clases, medias, vecinos)
    distancias = zeros(1,length(medias));
    for i = 1:length(medias)
        % Se almacenan la distancia
        % de la media i al vector desonocido
        % x
        distancias(i) = norm(medias{i} - x);
    end

    [~ , numClase] = min(distancias);
end


% Funcion para el criterio por Mahalanobis
function numClase = porMahalanobis(x, clases, medias, vecinos)
    distancias = zeros(1, length(clases));

    for i = 1:length(clases)

        % Variables auxiliares para la clase i y
        % media i
        clase = clases{i};
        media = medias{i};
        N = length(clase);

        % Se hace la diferencia de cada elemento de la clase
        % con la media de la misma
        difClaseMedia = clase - repmat(media, 1, length(clase));

        % Se calcula entonces la matriz de covarianza
        % como Z = 1/N ( (x - m) * (x - m)' )
        % Donde 
        % N: Numero de representantes
        % x: Elemento de la clase
        % m: Media de la clase
        matrizCov = (1/N) * (difClaseMedia * difClaseMedia');

        % Para la distancia se necesita la diferencia
        % entre la media de la clase y el vector
        % desconocido
        % Y la inversa de la matriz de covarianza
        difVectorMedia = x - media;
        invMatrizCov = inv(matrizCov);

        % Se calcula la distancia Mahalanobis
        % con dis(X, m) = (X - m) * Z^-1 * (X - m)'
        distancia = difVectorMedia' * invMatrizCov * difVectorMedia;
        distancias(i) = distancia;
    end

    [~ , numClase] = min(distancias);
end


%Por Criterio de Bayes
function numClase = porCriterioBayes(x, clases, medias, vecinos)
    %distancias = zeros(1, length(clases));
    probabilidades = zeros(1, length(clases));    
    for i = 1:length(clases)
        % Variables auxiliares para la clase i y
        % media i
        clase = clases{i};
        media = medias{i};
        N = length(clase);

        % Se hace la diferencia de cada elemento de la clase
        % con la media de la misma
        difClaseMedia = clase - repmat(media, 1, length(clase));

        % Se calcula entonces la matriz de covarianza
        % como Z = 1/N ( (x - m) * (x - m)' )
        % Donde 
        % N: Numero de representantes
        % x: Elemento de la clase
        % m: Media de la clase
        matrizCov = (1/N) * (difClaseMedia * difClaseMedia');

        % Para la distancia se necesita la diferencia
        % entre la media de la clase y el vector
        % desconocido
        % Y la inversa de la matriz de covarianza
        difVectorMedia = x - media;
        invMatrizCov = inv(matrizCov);

        % Se calcula la distancia Mahalanobis
        % con dis(X, m) = (X - m) * Z^-1 * (X - m)'
        distancia = difVectorMedia' * invMatrizCov * difVectorMedia;

        %Probabilidad de que x pertenezca a la clase i
        probabilidad = exp(-0.5*distancia)/(2*pi*det(matrizCov)^(0.5));
        probabilidades(i) = probabilidad;
    end 
    
    %sumatoria de las probabilidades
    sumatoria = sum(probabilidades);

    %Probabilidades normalizadas
    probanorm = zeros(1,length(clases));
    for i=1:length(probabilidades)
        probabilidad = probabilidades(i)/sumatoria;
        probanorm(i) = probabilidad;
    end 

    [probGanadora , probClase] = max(probanorm);
    if probGanadora >= 0.1
        numClase = probClase;
    else
        numClase = -1;
    end
    
end


%Por K Nearest Neighbors (Los K vecinos mas cercanos)
function numClase = porKNN(x, clases, medias, vecinos)
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
    for d=1:vecinos
        encuentra_clase = lista_ordenada(1:d,2);
    end

    [gc, gr] = groupcounts(encuentra_clase);

    for i=1:length(gr)
        probabilidades(i, 1) = gc(i)/vecinos;
        probabilidades(i, 2) = gr(i);
    end

    encuentra_clase = mode(encuentra_clase);

    [probabilidad_maxima, indice] = max(probabilidades(:,1));
    probabilidad_clase = probabilidades(indice, 2);

    numClase = encuentra_clase;
    probClase = probabilidad_clase;
end


% Evaluacion por Resustitucion
function [matriz, diagonales, eficiencia] = resustitucion(clasificador, clases, medias, vecinos)
    numClases = length(clases);
    elementos_pruebas = clases;
    matriz = [];
    for i = 1:numClases
        clase_pruebas = elementos_pruebas{i};
        N = length(clase_pruebas);
        row = zeros(1, numClases);
        
        % Llena la matriz para la clase i
        for j = 1:N
            c = clasificador(clase_pruebas(:, j), clases, medias, vecinos);
            row(c) = row(c) + 1;
        end

        % Convierte los votos de cada clase en
        % porcentajes
        for j = 1: numClases
            row(j) = row(j)/N;
        end

        matriz = [ matriz; row];
    end

    diagonales = diag(matriz);

    eficiencia = trace(matriz)/numClases;

end


% Evaluacion por Cross Validation
function [matrices, diagonales, eficiencia] = crossValidation(clasificador, og_clases, medias, vecinos)
    clases = og_clases;
    numClases = length(clases);

    matrices = [];
    diagonals = [];
    diagonals_sum = [];
    diagonals_sum_prom = [];
   

    for i = 1:20

        elementos_pruebas = {};
        clases_entrenamiento = {};
        for j = 1:numClases
            clase = clases{j};
    
            N = length(clase);
            clase_entrenamiento = [];
            aux_clase = clase;
            
            indices_pruebas = randperm(N, round(N/2));
            for k = 1: length(indices_pruebas)
                clase_entrenamiento = [clase_entrenamiento clase(:, indices_pruebas(k))];
                aux_clase(:,k) = [];
            end
    
            elementos_pruebas{j} = clase_entrenamiento;
            clases_entrenamiento{j} = aux_clase;
        end

        matriz = [];

        for j = 1:numClases
            clase_pruebas = elementos_pruebas{j};
            N = length(clase_pruebas);
            row = zeros(1, numClases);
            
            % Llena la matriz para la clase i
            for k = 1:N
                c = clasificador(clase_pruebas(:, k), clases_entrenamiento, medias, vecinos);
                row(c) = row(c) + 1;
            end
    
            % Convierte los votos de cada clase en
            % porcentajes
            for k = 1: numClases
                row(k) = row(k)/N;
            end
    
            matriz = [ matriz; row];
        end
        
        matrices = [matrices matriz];
        diagonals = [diagonals diag(matriz)];
        diagonals_sum = [diagonals_sum trace(matriz)];
        diagonals_sum_prom = [diagonals_sum_prom trace(matriz)/numClases];

    end
    
    diagonales = mean(diagonals')';

    eficiencia = mean(diagonals_sum_prom);
end


% Evaluacion por Hold In One
function [matriz, diagonales, eficiencia] = holdInOne(clasificador, clases, medias, vecinos)
    numClases = length(clases);
    elementos_pruebas = clases;
    matriz = [];
    for i = 1:numClases
        clase_pruebas = elementos_pruebas{i};
        N = length(clase_pruebas);
        row = zeros(1, numClases);
        
        % Llena la matriz para la clase i
        for j = 1:N
            
            clases_entrenamiento = clases;
            clases_entrenamiento{i}(:,j) = [];

            c = clasificador(clase_pruebas(:, j), clases_entrenamiento, medias, vecinos);
            row(c) = row(c) + 1;
        end

        % Convierte los votos de cada clase en
        % porcentajes
        for j = 1: numClases
            row(j) = row(j)/N;
        end

        matriz = [ matriz; row];
    end

    diagonales = diag(matriz);

    eficiencia = trace(matriz)/numClases;

end

























