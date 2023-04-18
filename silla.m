clear all
clc


%Se toman las transformadas
file = csvread("dataEMGtargetnum.csv");

FFT1 = file(:,1);
FFT2 = file(:,2);
FFT3 = file(:,3);
FFT4 = file(:,4);
FFT5 = file(:,5);
FFT6 = file(:,6);
FFT7 = file(:,7);

%Aumentamos en un valor de 3 para poder crear una ventana que pueda
    %analizar todos los datos del archivo. En caso de que se quiera cambiar
    %el valor de la ventana, se tiene que cambiar el numero al que se suma
    %la variable de iteracion n
for n = 2:3:length(file)
    
    if (n == 146)
        break
    end

    %Asignamos los valores de las transformadas de fourier a nuestras
    %entradas
    u1 = [FFT1(n,1),FFT2(n,1),FFT3(n,1),FFT4(n,1),FFT5(n,1),FFT6(n,1),FFT7(n,1)]
    u2 = [FFT1(n + 1,1),FFT2(n + 1,1),FFT3(n + 1,1),FFT4(n + 1,1),FFT5(n + 1,1),FFT6(n + 1,1),FFT7(n + 1,1)]
    u3 = [FFT1(n + 2,1),FFT2(n + 2,1),FFT3(n + 2,1),FFT4(n + 2,1),FFT5(n + 2,1),FFT6(n + 2,1),FFT7(n + 2,1)]
    
    suma1 = 0;
    suma = 0;
    
    entradas = [u1 u2 u3];
    
    alfa1 = 1;
    alfa2 = 0;
    alfa3 = 0;
    
    y1ast = 1;
    W1 = [1 1 1 1 1 1 1];
    W2 = 0;
    W3 = 0;
    
    %determinado por las entradas 
    v1 = [3 3 3];
    %determinado por las funciones de activacion
    v2 = [3 3 3 3 3 3 3];
    v3 = [3 3 3 3 3];
    v4 = [3 3 3 3];
    
    %vectores auxiliares para tener mismo tamaño de
    %los vectores
    vaux1 = [1 1 1 1 1 1 1];
    vaux2 = [1 1 1 1 1 1 1];
    vaux3 = [1 1 1 1 1 1 1];
    vaux4 = [1 1 1 1 1 1 1];
    
    %almacenando vector en vector auxiliar
    for i = 1:length(v1)
        vaux1(i) = v1(i); 
    end
    
    for i = 1:length(v2)
        vaux2(i) = v2(i); 
    end
    
    for i = 1:length(v3)
        vaux3(i) = v3(i); 
    end
    
    for i = 1:length(v4)
        vaux4(i) = v4(i); 
    end
    
    % Para calcular sumatoria para W1
    for n1 = 1:length(entradas)
        sumaW1 = (y1ast - vaux2.*(W1 .* vaux1.*(entradas(n1)))) .* (vaux2.*(W1 .* vaux1.*(entradas(n1)))) .* (vaux1.*(entradas(n1)))
        suma = suma + sumaW1;
    end
    % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
    
    % Para calcular el peso
    W1 = W1 - (alfa1 * (-2) .* suma);
    %Regresa un solo vector del tamanio del vector auxiliar
    
    % Para calcular sumatoria para W2
    for n2 = 1:length(entradas)
        sumaW2 = (y1ast - vaux3 .* (W2 .* vaux2.*(W1 .* vaux1(entradas(n2))))) .* ...
            (vaux3 .*(W2 .* vaux2 .* (W1 .* vaux1(entradas(n2))))) .* ...
            (vaux2 .* (W1 .* vaux1 .*(entradas(n2))))
        suma2 = suma2 + sumaW2;
    end
    % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
    
    % Para calcular el peso
    W2 = W2 - (alfa2 * (-2) .* suma2);
    %Regresa un solo vector del tamanio del vector auxiliar
    
    % Para calcular sumatoria para W3
    for n3 = 1:length(entradas)
        sumaW3 = (y1ast - vaux4 .* (W3 .* vaux3.*(W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3))))) .* ...
            (vaux4 .*(W3 .* vaux3 .* (W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3)))))) .* ...
            (vaux3 .* (W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3))))))
        suma3 = suma3 + sumaW3;
    end
    % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
    
    % Para calcular el peso
    W3 = W3 - (alfa3 * (-2) .* suma3);
end
%Regresa un solo vector del tamanio del vector auxiliar

% W1 = W1 - (alfa1 * (-2) 
% * sum(y1ast - v2[0](W1 * v1[0](u1))) * 
% (v2[0](W1 * v1[0](u1))) * (v1[0](u1)));
% 
% W2 = W2 - (alfa2 * (-2) 
% * sum(y1ast - v3[0](W2 * v2[0](W1 * v1(u1)))) * 
% (v3[0](W2 * v2[0](W1 * v1(u1)))) * (v2[0](W1 * v1(u1))));
% 
% W3 = W3 - (alfa3 * (-2) 
% * sum(y1ast - v4[0](W3 * v3[0](W2 * v2(W1 * v1(u1))))) * 
% (v4[0](W3 * v3[0](W2 * v2(W1 * v1(u1))))) * 
% (v3[0](W2 * v2(W1 * v1(u1)))));