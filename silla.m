clear all
clc

File = csvread("vectores_silla_octantes.csv")

suma1 = 0;
suma = 0;

alfa1 = 1;
alfa2 = 0;
alfa3 = 0;
%Cada una de las entradas corresponde a los valores en cada uno de los ejes
% donde u1 = x, u2 = y, u3 = z
u1 = 0.5;
u2 = 0;
u3 = 0;

entradas = [u1 u2 u3];

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