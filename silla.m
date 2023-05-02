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
target = file(:,8);

[r p] = size(file);

suma1 = 0;
suma = 0;

%Parametros de ajuste de los pesos
alfa1 = 1;
alfa2 = 0;
alfa3 = 0;

%% Estructura de la red

N1 = 21; %Capa de entrada
N2 = 52; %Primer capa oculta
N3 = 24; %Segunda capa oculta
N4 = 1;  %Capa de salida

%Pesos
%W1 tiene el tamano de N1 multiplicado por N2
W1 = randn(N1, N2);
%W2 tiene el tamano de N2 multiplicado por N3
W2 = randn(N2, N3);
%W3 tiene el tamano de N3 multiplicado por N4
W3 = randn(N3, N4);

m4 = 3;

Se = [];

Se(1) = 0;

grad1 = zeros(N1, 1);
grad2 = zeros(N2, 1);
grad3 = zeros(N3, 1);

% Parametros de la funcion sigmoide, tienen que ser el numero de entradas

% Para la funcion sigmoide 1
a1 = ones(N1, 1);
b1 = ones(N1, 1);
c1 = ones(N1, 1);
d1 = ones(N1, 1);

% Para la funcion sigmoide 2
a2 = ones(N2, 1);
b2 = ones(N2, 1);
c2 = ones(N2, 1);
d2 = ones(N2, 1);

% Para la funcion sigmoide 3
a3 = ones(N3, 1);
b3 = ones(N3, 1);
c3 = ones(N3, 1);
d3 = ones(N3, 1);

%Dentro de este ciclo for se realiza el movimiento de la ventana para ir
%asignando los valores a cada una de las entradas, de manera que podamos
%recorrernos a traves de todo el documento de los datos adquiridos
for n = 2:1:24
    
    if (n == 24)
        break
    end

    %Asignamos los valores de las transformadas de fourier a nuestras
    %entradas
    u1 = [FFT1(n,1),FFT2(n,1),FFT3(n,1),FFT4(n,1),FFT5(n,1),FFT6(n,1),FFT7(n,1)];
    u2 = [FFT1(n + 1,1),FFT2(n + 1,1),FFT3(n + 1,1),FFT4(n + 1,1),FFT5(n + 1,1),FFT6(n + 1,1),FFT7(n + 1,1)];
    u3 = [FFT1(n + 2,1),FFT2(n + 2,1),FFT3(n + 2,1),FFT4(n + 2,1),FFT5(n + 2,1),FFT6(n + 2,1),FFT7(n + 2,1)];
    
    %Vector para la primera capa de tamano 21
    uA = [u1 u2 u3];
    
    %Funcion de activavion exponencial de forma a / (1 + exp (-c * (x - b))) + d
    %Primera capa
    for i1 = 1:N1
    
        Sig1(i1) = (a1(i1) / (1 + exp(-c1(i1) * (uA(i1) - b1(i1))))) + d1(i1);   
        
        dSig1(i1)= (a1(i1) / (1 + exp(-c1(i1) * (uA(i1) - b1(i1))))) * ((c1(i1)*exp(-c1(i1) * (uA(i1) - b1(i1)) )) / (1 + exp(-c1(i1) * (uA(i1) - b1(i1)) )) );   
    
    end

    %Vector para la segunda capa de tamano 52
    %Se realiza una transposicion de los datos de W1 para poder multiplicar y
    %que nos quede solamente la N de la siguiente capa
    uB = W1' .* Sig1;

    %Segunda capa
    for i2 = 1:N2
    
        Sig2(i2) = (a2(i2) / (1 + exp(-c2(i2) * (uB(i2) - b2(i2))))) + d2(i2);   
        
        dSig2(i2)= (a2(i2) / (1 + exp(-c2(i2) * (uB(i2) - b2(i2))))) * ((c2(i2)*exp(-c2(i2) * (uB(i2) - b2(i2)) )) / (1 + exp(-c2(i2) * (uB(i2) - b2(i2)) )) );   
    
    end

    %Vector para la tercera capa de tamano 24
    uC = W2' .* Sig2;

    %Tercera capa
    for i3 = 1:N3
    
        Sig3(i3) = (a3(i3) / (1 + exp(-c3(i3) * (uC(i3) - b3(i3))))) + d3(i3);   
        
        dSig3(i3)= (a3(i3) / (1 + exp(-c3(i3) * (uB(i3) - b3(i3))))) * ((c3(i3)*exp(-c3(i3) * (uC(i3) - b3(i3)) )) / (1 + exp(-c3(i3) * (uC(i3) - b3(i3)) )) );   
    
    end

    %Cuarta capa
    Mov_NN = m4 * (W3' .* Sig3);

end
    %% backpropagation
for n2 = 1 : 1 : 21

    e(1,n2) = target(n2) - Mov_NN(n2);

%     Se(1,n2) = Se(n2) + 0.5 * e(n2)^2;

    grad1(n2) = -2 * (grad1(n2) + (e(n2) * Mov_NN(n2) * Sig3(n2) * dSig2(n2) * Sig1(n2)));
    grad2(n2) = -2 * (grad2(n2) + (e(n2) * Mov_NN(n2) * dSig3(n2) * Sig2(n2)));
    grad3(n2) = -2 * (grad3(n2) + (e(n2) * m4 * Sig3(n2)));

    W3 = W3 - alfa3 * grad3;
    W2 = W2 - alfa2 * grad2;
    W1 = W1 - alfa1 * grad1;
end

%     % Para calcular sumatoria para W1
%     for n1 = 1:length(entradas)
%         sumaW1 = (y1ast - vaux2.*(W1 .* vaux1.*(entradas(n1)))) .* (vaux2.*(W1 .* vaux1.*(entradas(n1)))) .* (vaux1.*(entradas(n1)))
%         suma = suma + sumaW1;
%     end
%     % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
%     
%     % Para calcular el peso
%     W1 = W1 - (alfa1 * (-2) .* suma);
%     %Regresa un solo vector del tamanio del vector auxiliar
%     
%     % Para calcular sumatoria para W2
%     for n2 = 1:length(entradas)
%         sumaW2 = (y1ast - vaux3 .* (W2 .* vaux2.*(W1 .* vaux1(entradas(n2))))) .* ...
%             (vaux3 .*(W2 .* vaux2 .* (W1 .* vaux1(entradas(n2))))) .* ...
%             (vaux2 .* (W1 .* vaux1 .*(entradas(n2))))
%         suma2 = suma2 + sumaW2;
%     end
%     % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
%     
%     % Para calcular el peso
%     W2 = W2 - (alfa2 * (-2) .* suma2);
%     %Regresa un solo vector del tamanio del vector auxiliar
%     
%     % Para calcular sumatoria para W3
%     for n3 = 1:length(entradas)
%         sumaW3 = (y1ast - vaux4 .* (W3 .* vaux3.*(W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3))))) .* ...
%             (vaux4 .*(W3 .* vaux3 .* (W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3)))))) .* ...
%             (vaux3 .* (W2 .* vaux2 .* (W1 .* vaux1 .* (entradas(n3))))))
%         suma3 = suma3 + sumaW3;
%     end
%     % Regresa la suma de 3 vectores auxiliares que se dan por las entradas u
%     
%     % Para calcular el peso
%     W3 = W3 - (alfa3 * (-2) .* suma3);

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