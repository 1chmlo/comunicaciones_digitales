%**********
% Sinusoide
%**********
A = 1;
fc = 1000;
fs = 100000;
PeriodoMuestreo = 1/fs;  % Cada cuanto toma una muestra
ls = 200;  % Número de muestras
t_seno = (0:PeriodoMuestreo:0.002);  % Generar el tiempo multiplicado por la cantidad de muestras
seno = A * sin(2 * pi * fc * t_seno);  % Generar la sinusoide

%**********
% TREN DE PULSOS
%**********

f_muesteo = 10000;  % Frecuencia del tren de pulsos (10 kHz)
TrenPulsos_Fs = f_muesteo;  % Frecuencia muestreo tren pulsos
TrenPulsos_Ts = 1 / TrenPulsos_Fs;  % Periodo muestreo tren pulsos
tau = 0.00005;  % Duración del pulso (50 μs)
d = tau / TrenPulsos_Ts * 100;  % Ciclo de trabajo (en porcentaje)

% Parámetros de la señal cuadrada
T_total = 1;  % Tiempo total de la señal (segundos)
t_tren = 0:PeriodoMuestreo:0.002;  % Eje de tiempo

% Generar el tren de pulsos
tren_pulsos = (1 + square(2 * pi * f_muesteo * t_tren, d)) / 2;  % Generar la onda cuadrada

% PAM con Muestreo Natural
PAM = tren_pulsos .* seno;  % muestreo natural

% Crear la figura con las 3 subgráficas
figure;

% Subgráfica 1: Señal sinusoidal
subplot(4,1,1);  % 4 filas, 1 columna, primer gráfico
plot(t_seno, seno, 'LineWidth', 2, 'Color', 'b');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal');
grid on;

% Subgráfica 2: Tren de pulsos
subplot(4,1,2);  % 4 filas, 1 columna, segundo gráfico
plot(t_tren, tren_pulsos, 'LineWidth', 2, 'Color', 'r');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('TREN DE PULSOS');
grid on;

% Subgráfica 3: PAM Natural
subplot(4,1,3);  % 4 filas, 1 columna, tercer gráfico
plot(t_tren, PAM, 'LineWidth', 2, 'Color', 'g');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('PAM (Muestreo Natural)');
grid on;

% Subgráfica 4: Señal sinusoidal y PAM juntos
subplot(4,1,4);  % 4 filas, 1 columna, cuarta gráfica
plot(t_tren, seno(1:length(t_tren)), 'b', 'LineWidth', 2);  % Señal sinusoidal en azul
hold on;
plot(t_tren, PAM, 'g', 'LineWidth', 2);  % PAM en verde
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Sinusoidal y PAM (Muestreo Natural)');
legend('Señal Sinusoidal', 'PAM Natural');
grid on;