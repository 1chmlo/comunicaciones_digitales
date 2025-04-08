%**********
% Sinusoide
%**********
A = 1;
fc = 1000;  % Frecuencia de la señal moduladora (sinusoide)
fs = 100000;  % Frecuencia de muestreo para buena resolución
Ts = 1/fs;  % Periodo de muestreo

t_seno = 0:Ts:0.002;  % 2ms de señal
seno = A * sin(2 * pi * fc * t_seno);  % Generar la sinusoide

%**********
% TREN DE PULSOS
%**********
f_muestreo = 10000;  % Frecuencia de muestreo (10 kHz)
Ts_pulsos = 1 / f_muestreo;  % Periodo de muestreo del tren de pulsos
tau = 0.00005;  % Ancho del pulso en segundos
d = (tau / Ts_pulsos) * 100;  % Ciclo de trabajo en porcentaje

% Vector de tiempo para el tren de pulsos
t_tren = 0:Ts:0.002;  % Mismo vector de tiempo

% Generar el tren de pulsos
tren_pulsos = (1 + square(2 * pi * f_muestreo * t_tren, d)) / 2;

% PAM con Muestreo Instantáneo usando pulsos cuadrados
PAM_instantaneo = zeros(size(t_tren));

% Para cada punto de muestreo (donde el pulso comienza)
for i = 1:length(t_tren)
    if i > 1 && tren_pulsos(i) > 0.5 && tren_pulsos(i-1) < 0.5
        % Este es el inicio de un pulso (flanco ascendente)
        valor_muestra = seno(i);  % Tomar el valor instantáneo
        
        % Mantener este valor durante todo el pulso
        j = i;
        while j <= length(t_tren) && tren_pulsos(j) > 0.5
            PAM_instantaneo(j) = valor_muestra;  % Mismo valor para todo el pulso
            j = j + 1;
        end
    end
end

% Crear la figura con las 4 subgráficas
figure;

% Subgráfica 1: Señal sinusoidal
subplot(4,1,1);
plot(t_seno, seno, 'LineWidth', 2, 'Color', 'b');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal');
grid on;
%ylim([-1.2 1.2]);

% Subgráfica 2: Tren de pulsos
subplot(4,1,2);
plot(t_tren, tren_pulsos, 'LineWidth', 2, 'Color', 'r');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Tren de Pulsos');
grid on;
%ylim([-0.2 1.2]);

% Subgráfica 3: PAM Instantáneo con Pulsos Cuadrados
subplot(4,1,3);
plot(t_tren, PAM_instantaneo, 'LineWidth', 2, 'Color', 'g');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('PAM (Muestreo Instantáneo) con Pulsos Cuadrados');
grid on;
%ylim([-1.2 1.2]);

% Subgráfica 4: Señal sinusoidal y PAM juntos
subplot(4,1,4);
plot(t_tren, seno, 'b', 'LineWidth', 2);
hold on;
plot(t_tren, PAM_instantaneo, 'g', 'LineWidth', 2);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal y PAM con Pulsos Cuadrados');
legend('Señal Sinusoidal', 'PAM Instantáneo');
grid on;
%ylim([-1.2 1.2]);
