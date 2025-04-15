% Parámetros
f0 = 1;                                  % Frecuencia base (B)
alpha_vals = [0, 0.25, 0.75, 1];         % Factores de roll-off
t = linspace(0, 5, 1000);                % Solo t ≥ 0
f = linspace(-2*f0, 2*f0, 1000);         % -2B ≤ f ≤ 2B

% --------- Figura 1: Respuesta al impulso he(t) ---------
figure('Name','Respuesta al impulso he(t)');
for k = 1:length(alpha_vals)
    alpha = alpha_vals(k);
    delta_f = alpha * f0;
    
    % Respuesta al impulso he(t)
    he_t = 2 * f0 * ...
        (sin(2*pi*f0*t) ./ (2*pi*f0*t)) .* ...
        (cos(2*pi*delta_f*t) ./ (1 - (4*delta_f*t).^2));
    
    % Corrección en t = 0 (evita división por 0)
    he_t(t == 0) = 2 * f0;

    subplot(2,2,k);
    plot(t, he_t, 'LineWidth', 1.2);
    title(['he(t), \alpha = ' num2str(alpha)]);
    xlabel('Tiempo (t)');
    ylabel('Amplitud');
    grid on;
    xlim([0 5]);
end
sgtitle('Respuesta al impulso he(t) para distintos \alpha');

% --------- Figura 2: Respuesta en frecuencia He(f) ---------
figure('Name','Respuesta en frecuencia He(f)');
for k = 1:length(alpha_vals)
    alpha = alpha_vals(k);
    He_f = zeros(size(f));
    
    for i = 1:length(f)
        abs_f = abs(f(i));
        if abs_f < f0 * (1 - alpha)
            He_f(i) = 1;
        elseif abs_f <= f0 * (1 + alpha)
            He_f(i) = 0.5 * (1 + cos(pi / (2 * alpha * f0) * ...
                         (abs_f - f0 * (1 - alpha))));
        else
            He_f(i) = 0;
        end
    end

    subplot(2,2,k);
    plot(f, He_f, 'LineWidth', 1.2);
    title(['He(f), \alpha = ' num2str(alpha)]);
    xlabel('Frecuencia (f)');
    ylabel('Magnitud');
    grid on;
    xlim([-2*f0 2*f0]);
end
sgtitle('Respuesta en frecuencia He(f) para distintos \alpha');