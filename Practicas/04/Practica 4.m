%Practica 4 KNN
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

n = 1;
while n ~= 5
    n = input("¿Que metodo quieres utilizar?\n" + ...
        "1. Distancia euclideana\n" + ...
        "2. Mahalanobis\n" + ...
        "3. Criterio de Bayes\n" + ...
        "4. Todos los criterios\n" + ...
        "5. Salir\n");
    if n == 5
        break;
    end

    % Vector X
    vector = [
        input("Dame las coordenadas del vector en x: ");
        input("Dame las coordenadas del vector en y: ")
    ];

    % Limpiar grafica
    clf
    % Grafica las clases
    graficarClases(clases);
    % Graficando el vector desconocido
    plot(vector(1,:),vector(2,:), 'ko','MarkerSize',10,'MarkerFaceColor','k');
    % Imprimir las etiquetas de las clases
    legend(etiquetas,'Location','east','Orientation','vertical');


    switch n
        case 1
            porDistanciaEuclideana(vector, medias);
        case 2
            porMahalanobis(vector, clases, medias);
        case 3
            porCriterioBayes(vector, clases, medias);
        case 4
            disp("Distancia euclideana");
            porDistanciaEuclideana(vector, medias);
            disp("Mahalanobis");
            porMahalanobis(vector, clases, medias);
            disp("Criterio de Bayes");
            porCriterioBayes(vector, clases, medias);
            disp("Criterio de Bayes");
            porCriterioBayes(vector, clases, medias);
    end

end

disp("Fin del programa"); 

% Funcion para gener n cantidad de clases
% aleatorias
function [clases, etiquetas, medias] = generaClases(cantidadDeClases)
    clases = {};
    etiquetas = {};
    medias = {};
    for i = 1:cantidadDeClases
        % Se genera una clase aleatoria
        clase = generaClase2D( ...
            input("Cuantos representantes tendra la clase "+i+": "), ...
            input("Ubicación de la clase "+i+" en X: "), ...
            input("Ubicación de la clase "+i+" en Y: "), ...
            input("Dispersion de la clase "+i+": ") ...
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

    % Se agrega a las etiquetas la etiqueta para
    % el vector desconocido x
    etiquetas{cantidadDeClases+1} = "Vector desconocido";
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
    cX = (rand(1, N) + x)*dispersion;
    cY = (rand(1, N) + y)*dispersion;
    clase = [cX ; cY];
end

% Funcion para el criterio por distancia euclideana
function porDistanciaEuclideana(x, medias)
    distancias = zeros(1,length(medias));
    for i = 1:length(medias)
        % Se almacenan la distancia
        % de la media i al vector desonocido
        % x
        distancias(i) = norm(medias{i} - x);
    end

    [~ , numClase] = min(distancias);
    fprintf("El vector desconocido pertence a la clase: %d\n", numClase); %Imprimir la clase a la que pertenece
end

% Funcion para el criterio por Mahalanobis
function porMahalanobis(x, clases, medias)
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
    fprintf("El vector desconocido pertence a la clase: %d\n", numClase); %Imprimir la clase a la que pertenece
end

%Por Criterio de Bayes
function porCriterioBayes(x, clases, medias)
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

    [probGanadora , numClase] = max(probanorm);
    if probGanadora >= 0.1
        fprintf("El vector desconocido pertence a la clase: %d\n", numClase); %Imprimir la clase a la que pertenece
    else
        fprintf("El vector desconocido no pertenece a ninguna clase"); %Imprimir que no pertenece a ninguna
    end
    
end
function porKNN(x, clases, medias)
    
end







