clc %limpiar pantalla
clear all %limpiar todo
close all %cierra todo
warning off all %Elimina los warnings
clases = {};
medias = {};
etiquetas = {};
clases{1} = generaClase3D(4,0,0,0,3);
clases{2} = generaClase3D(3,10,10,10,3);
clases{3} = generaClase3D(4,-10,-10,-10,5);
medias{1} = mean(clases{1}, 2);
medias{2} = mean(clases{2}, 2);
medias{3} = mean(clases{3}, 2);
clf
graficarClases(clases);
graficarMedias(medias);
vector = [
    input("Dame las coordenadas del vector en x: ");
    input("Dame las coordenadas del vector en y: ");
    input("Dame las coordenadas del vector en z: ")
];
etiquetas{1} = "Clase "+1;
etiquetas{2} = "Clase "+2;
etiquetas{3} = "Clase "+3;   
etiquetas{4} = "Media de la clase 1";
etiquetas{5} = "Media de la clase 2";
etiquetas{6} = "Media de la clase 3";
etiquetas{7} = "Vector desconocido"; 
plot3(vector(1),vector(2), vector(3), 'ko','MarkerSize',10,'MarkerFaceColor','k');
legend(etiquetas,'Location','east','Orientation','vertical');
porCriterioBayes(vector,clases,medias);

%plot3(1,1,1);

function clase = generaClase3D(N, x, y, z, dispersion)
    cX = (rand(1, N) + x)*dispersion;
    cY = (rand(1, N) + y)*dispersion;
    cZ = (rand(1, N) + z)*dispersion;
    clase = [cX ; cY; cZ];
end

function graficarClases(clases)
    grid on %Poner una cuadricula
    view(3);%Ordenar 3 dimensiones a la cuadricula
    hold on %Mantener lo que se haga despues del primer plot
    cmap = hsv(length(clases));
    for i = 1:length(clases)         
        plot3(clases{i}(1,:,:), clases{i}(2,:,:), clases{i}(3,:,:),'O','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i       
    end
end

function graficarMedias(medias)
    grid on %Poner una cuadricula
    view(3);%Ordenar 3 dimensiones a la cuadricula
    hold on %Mantener lo que se haga despues del primer plot
    cmap = hsv(length(medias));
    for i = 1:length(medias)        
        plot3(medias{i}(1), medias{i}(2), medias{i}(3),'.','MarkerSize',10,'Color',cmap(i,:)); %Graficar la clase i       
    end
end
function porCriterioBayes(x, clases, medias)
    probabilidades = zeros(1, length(clases));    
    for i = 1:length(clases)
        % Variables auxiliares para la clase i y
        % media i
        clase = clases{i};        
        media = medias{i};        
        N = length(clase);                      
        % Se hace la diferencia de cada elemento de la clase
        % con la media de la misma         
        difClaseMedia = clase - repmat(media, 1, N);            
        % Se calcula entonces la matriz de covarianza
        % como Z = 1/N ( (x - m) * (x - m)' )
        % Donde 
        % N: Numero de representantes
        % x: Elemento de la clase
        % m: Media de la clase
        %matrizCov = cov(difClaseMedia);
        matrizCov = (1/N) * (difClaseMedia * difClaseMedia'); 
        %disp(matrizCov);
        % Para la distancia se necesita la diferencia
        % entre la media de la clase y el vector
        % desconocido
        % Y la inversa de la matriz de covarianza
        difVectorMedia = x - media;
        %disp(difVectorMedia);
        if det(matrizCov) ~= 0            
            invMatrizCov = inv(matrizCov);                                
            % Se calcula la distancia Mahalanobis
            % con dis(X, m) = (X - m) * Z^-1 * (X - m)'        
            distancia = difVectorMedia' * invMatrizCov * difVectorMedia;
            if(distancia < 0 || sqrt(distancia) > 150)
                distancia = 1000;
            end
            %Probabilidad de que x pertenezca a la clase i
            probabilidad = exp(-0.5*distancia)/(((2*pi)^(3/2))*det(matrizCov)^(0.5));                                     
            if isnan(probabilidad)
                fprintf("La clase %d genera una probabilidad demasiado pequeña, por lo que no se puede trabajar\n",i);                                
            else
                if(isinf(probabilidad))
                    if(probabilidad > 0)
                        probabilidades(i) = 1000;
                    else
                        probabilidades(i) = 0;
                    end
                else
                    probabilidades(i) = probabilidad;
                end
            end
        else
            fprintf("La clase %d genera una matriz singular, por lo que no se puede trabajar su  distancia\n",i);
            probabilidades(i) = 0;
        end
    end     
    %sumatoria de las probabilidades
    sumatoria = sum(probabilidades);
    if sumatoria == 0
        disp("Todas las probabilidades son 0");
        sumatoria = 1;
    end
    %Probabilidades normalizadas
    probanorm = zeros(1,length(clases));
    for i=1:length(probabilidades)      
        probabilidad = probabilidades(i)/sumatoria;
        probanorm(i) = probabilidad;
        fprintf("Probabilidad de la clase %d: %0.2f%%\n",i,probanorm(i)*100);
    end     
    [probGanadora , numClase] = max(probanorm);
    if probGanadora >= 0.1
        fprintf("El vector desconocido pertence a la clase: %d\n", numClase); %Imprimir la clase a la que pertenece
    else
        fprintf("El vector desconocido no pertenece a ninguna clase\n"); %Imprimir que no pertenece a ninguna
    end
    
end
