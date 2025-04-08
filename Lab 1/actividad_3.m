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
% Aquí agregamos el código para m_t, m_t_nat y m_t_inst
%**********

% La señal original m_t (en este caso es la senoide original)
m_t = seno;

% PAM con muestreo natural m_t_nat
m_t_nat = PAM_natural;

% PAM con muestreo instantáneo m_t_inst
m_t_inst = PAM_instantaneo;

% Parámetros PCM
N = 2; % Número de bits para PCM
pcm_levels = 2^N; % Total de niveles PCM
% Cuantizar la señal instantánea usando PCM
pcm_signal_inst = round((m_t_inst + 1) * (pcm_levels - 1) / 2); % Cuantización
% Normaliza las señales para que estén en el mismo rango de amplitud (0 a 1)
m_t_norm = (m_t - min(m_t)) / (max(m_t) - min(m_t));
m_t_inst_norm = (m_t_inst - min(m_t_inst)) / (max(m_t_inst) - min(m_t_inst));
pcm_signal_inst_norm = (pcm_signal_inst - min(pcm_signal_inst)) / (max(pcm_signal_inst) - min(pcm_signal_inst));

% Crear una figura para mostrar todas las señales en un mismo gráfico
figure;
% Graficar la señal original en azul
plot(t_tren, m_t_norm, 'b', 'LineWidth', 1.5);
hold on;
% Graficar la señal PAM Instantánea en rojo
plot(t_tren, m_t_inst_norm, 'r', 'LineWidth', 1.5);
% Graficar la señal PAM cuantificada (PCM) en verde (usar marcador 'o' para visualizar los puntos PCM)
stem(t_tren, pcm_signal_inst_norm, 'g', 'Marker', 'o', 'LineWidth', 1.5);
% Establecer etiquetas y título del gráfico
xlabel('Tiempo (s)');
ylabel('Amplitud Normalizada');
title('Señal Original, Señal PAM Instantánea y Señal PAM Cuantificada (PCM)');
legend('Señal Original', 'Señal PAM Instantánea', 'Señal PAM Cuantificada (PCM)');
grid on;

% Crear una nueva figura para mostrar el error de cuantización
figure;
% Graficar el error de cuantización para la señal PAM cuantificada (PCM)
quantization_error_inst = abs(m_t_inst - ((2 * pcm_signal_inst / (pcm_levels - 1)) - 1));
plot(t_tren, quantization_error_inst, 'k--', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Error de Cuantización');
title('Error de Cuantización para la Señal PAM Cuantificada (PCM)');
grid on;
