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
% TREN DE PULSOS (IGUAL PARA AMBOS TIPOS DE MUESTREO)
%**********
f_muestreo = 10000;  % Frecuencia de muestreo (10 kHz)
Ts_pulsos = 1 / f_muestreo;  % Periodo de muestreo del tren de pulsos

% Parámetros para el tren de pulsos (común para ambos)
tau = 0.00005;  % Ancho del pulso 
d = (tau / Ts_pulsos) * 100;  % Ciclo de trabajo (%)

% Vector de tiempo para el tren de pulsos
t_tren = 0:Ts:0.002;  % Mismo vector de tiempo

% Generar el tren de pulsos (común para ambos tipos de muestreo)
tren_pulsos = (1 + square(2 * pi * f_muestreo * t_tren, d)) / 2;

%**********
% PAM con Muestreo Natural
%**********
PAM_natural = tren_pulsos .* seno;  % Multiplicación directa

%**********
% PAM con Muestreo Instantáneo
%**********
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

%**********
% Transformadas de Fourier
%**********
N = length(seno);  % Número de puntos para la FFT
f = (0:N-1)*(fs/N);  % Eje de frecuencias en Hz

% FFT de la señal original
TF_original = fft(seno);
TF_original_magnitude = abs(TF_original)/N;

% FFT del PAM con muestreo natural
TF_natural = fft(PAM_natural);
TF_natural_magnitude = abs(TF_natural)/N;

% FFT del PAM con muestreo instantáneo
TF_inst = fft(PAM_instantaneo);
TF_inst_magnitude = abs(TF_inst)/N;

%**********
% Gráficos
%**********

% Crear figura para mostrar cada señal individualmente
figure('Position', [100, 100, 800, 600]);

% Subgráfica 1: Señal sinusoidal
subplot(4,1,1);
plot(t_seno, seno, 'LineWidth', 2, 'Color', 'b');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal Original');
grid on;
ylim([-1.2 1.2]);

% Subgráfica 2: Tren de pulsos
subplot(4,1,2);
plot(t_tren, tren_pulsos, 'LineWidth', 2, 'Color', 'r');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Tren de Pulsos');
grid on;
ylim([-0.2 1.2]);

% Subgráfica 3: PAM con muestreo natural
subplot(4,1,3);
plot(t_tren, PAM_natural, 'LineWidth', 2, 'Color', 'g');
hold on;
plot(t_tren, seno, 'LineWidth', 1, 'Color', 'b', 'LineStyle', '--');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('PAM con Muestreo Natural');
legend('PAM Natural', 'Señal Original');
grid on;
ylim([-1.2 1.2]);

% Subgráfica 4: PAM con muestreo instantáneo
subplot(4,1,4);
plot(t_tren, PAM_instantaneo, 'LineWidth', 2, 'Color', 'm');
hold on;
plot(t_tren, seno, 'LineWidth', 1, 'Color', 'b', 'LineStyle', '--');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('PAM con Muestreo Instantáneo');
legend('PAM Instantáneo', 'Señal Original');
grid on;
ylim([-1.2 1.2]);

% Crear segunda figura para comparación y FFTs
figure('Position', [900, 300, 900, 800]);

% Subgráfica 1: Comparación de señales en el dominio del tiempo
subplot(4,1,1);
plot(t_tren, seno, 'b', 'LineWidth', 2);
hold on;
plot(t_tren, PAM_natural, 'g', 'LineWidth', 1.5);
plot(t_tren, PAM_instantaneo, 'm', 'LineWidth', 1.5);
xlabel('Tiempo (s)', 'FontSize', 12);
ylabel('Amplitud', 'FontSize', 12);
title('Comparación: Señal Original, Muestreo Natural e Instantáneo', 'FontSize', 14);
legend('Señal Sinusoidal Original', 'PAM con Muestreo Natural', 'PAM con Muestreo Instantáneo');
grid on;
ylim([-1.2 1.2]);

% Subgráfica 2: FFT de la señal original
subplot(4,1,2);
plot(f/1000, TF_original_magnitude, 'b', 'LineWidth', 2);
xlabel('Frecuencia (kHz)');
ylabel('Amplitud');
title('FFT - Señal Sinusoidal Original');
grid on;
xlim([0 fs/2000]);

% Subgráfica 3: FFT del PAM con muestreo natural
subplot(4,1,3);
plot(f/1000, TF_natural_magnitude, 'g', 'LineWidth', 2);
xlabel('Frecuencia (kHz)');
ylabel('Amplitud');
title('FFT - PAM con Muestreo Natural');
grid on;
xlim([0 fs/2000]);

% Subgráfica 4: FFT del PAM con muestreo instantáneo
subplot(4,1,4);
plot(f/1000, TF_inst_magnitude, 'm', 'LineWidth', 2);
xlabel('Frecuencia (kHz)');
ylabel('Amplitud');
title('FFT - PAM con Muestreo Instantáneo');
grid on;
xlim([0 fs/2000]);
