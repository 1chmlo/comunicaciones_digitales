% Parámetros generales
Nbits = 10000;              % Número de bits
Rb = 1000;                % Tasa de bits (bits por segundo)
Fs = 10 * Rb;             % Frecuencia de muestreo (10 muestras por bit)
Ts = 1 / Rb;              % Tiempo de símbolo
Ns = Fs / Rb;             % Muestras por bit
t = (0:Nbits*Ns - 1) / Fs;

% rolloff de la actividad previa
rolloff_vals = [0, 0.25, 0.75, 1];

% Generar bits aleatorios y codificación NRZ-L
bits = randi([0 1], 1, Nbits);
symbols = 2 * bits - 1;  % NRZ-L: 0 → -1, 1 → +1
upsampled = upsample(symbols, Ns);  % Inserta ceros entre símbolos

% Gráficas de diagrama de ojo para cada roll-off
for k = 1:length(rolloff_vals)
    alpha = rolloff_vals(k);
    span = 6;  % Duración del filtro en símbolos
    rcos_filter = rcosdesign(alpha, span, Ns, 'normal');  % Filtro coseno alzado

    % Filtrado (transmisión con coseno alzado)
    tx_signal = conv(upsampled, rcos_filter, 'same');

    % añadir ruido gausiano blanco
    snr = 20;  %  señal a ruido (en dB)
    rx_signal = awgn(tx_signal, snr, 'measured');

    % diag de ojo
    figure('Name', ['Diagrama de Ojo - α = ' num2str(alpha)]);
    eyediagram(rx_signal, 2 * Ns);
    title(['Diagrama de ojo para α = ' num2str(alpha)]);
end