%% ========================================================================
%  Metricas de desempenho + espectrograma do sinal de controle - PID
%  ------------------------------------------------------------------------
%  Calcula RMSE, ISE, IAE e ITAE sobre o erro de escorregamento e plota,
%  em subplots, o sinal de controle u(t) e seu espectrograma (eixos de
%  tempo alinhados).
%
%  PRE-REQUISITOS:
%   - Signal logging ligado (dataset solto no workspace:
%     sldemo_absbrake_output).
%   - Sinais logados e nomeados: 'slip' e 'controller out'.
%   - Espectrograma requer a Signal Processing Toolbox.
% =========================================================================
mdl = 'PID_sldemo_absbrake';
load_system(mdl);
sim(mdl);                                  % roda; saidas vao p/ o workspace

ds   = sldemo_absbrake_output;
slip = ds.getElement('slip');
u    = ds.getElement('conout');

t_slip = slip.Values.Time;   s  = slip.Values.Data;
t_u    = u.Values.Time;      uu = u.Values.Data;

referencia = 0.2;

%% --- janela de frenagem efetiva (corta o pico final de v->0) ------------
idxFim = find(s > 0.5, 1, 'first');
if isempty(idxFim), idxFim = numel(s); end
idxFim = idxFim - 1;

tw = t_slip(1:idxFim);
sw = s(1:idxFim);
e  = referencia - sw;                      % erro na janela efetiva

%% --- metricas (integracao trapezoidal, passo variavel) ------------------
ISE  = trapz(tw, e.^2);
IAE  = trapz(tw, abs(e));
ITAE = trapz(tw, tw .* abs(e));
RMSE = sqrt( trapz(tw, e.^2) / (tw(end) - tw(1)) );

M = table(RMSE, ISE, IAE, ITAE, ...
          'VariableNames', {'RMSE','ISE','IAE','ITAE'}, ...
          'RowNames', {'PID'});
disp(' ');
disp('Metricas de desempenho - controlador PID:');
disp(M);

%% --- reamostra u(t) em grade uniforme (necessario p/ spectrogram) -------
Fs = 50;                                   % Hz de reamostragem
tg = (t_u(1) : 1/Fs : t_u(end))';
[tu_uni, iu] = unique(t_u);
ug = interp1(tu_uni, uu(iu), tg, 'linear');
ugc = ug - mean(ug);                       % remove o nivel DC p/ o espectrograma

%% --- figura com subplots -----------------------------------------------
figure('Color','w');

% plot dos sinais
subplot(2,1,1);
plot(slip.Values.Time, slip.Values.Data, 'b', 'LineWidth', 1.4); hold on;
yline(0.2, '--k', 'LineWidth', 1.2);
grid on; ylabel('Slip'); ylim([0 1]);
legend('s(t)', 'referencia (0.2)', 'Location', 'best');
title('Resposta do sistema com PID nominal');
 
subplot(2,1,2);
plot(u.Values.Time, u.Values.Data, 'r', 'LineWidth', 1.4);
grid on; xlabel('Tempo (s)'); ylabel('Acao de controle u(t)');

% --- espectrograma sozinho ---
figure('Color','w');
spectrogram(ugc, hamming(64), 60, 128, Fs, 'yaxis');
ylim([0 10]);
xlabel('Tempo (s)'); ylabel('Frequencia (Hz)');
title('Espectrograma do sinal de controle u(t) - PID');
colorbar;

% exportgraphics(gcf, 'espectrograma_pid.png', 'Resolution', 300);