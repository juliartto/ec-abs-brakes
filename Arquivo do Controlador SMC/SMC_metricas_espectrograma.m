%% ========================================================================
%  SMC_METRICAS_ESPECTROGRAMA.M
%  ------------------------------------------------------------------------
%  Calcula metricas e plota espectrograma do SMC.
%  Estrutura identica ao subplots.m do PID.
% =========================================================================

assignin('base', 'K_smc', 3);
assignin('base', 'phi',   0.08);
sldemo_absdata;

mdl = 'SMC_sldemo_absbrake';
load_system(mdl);
sim(mdl);

ds = sldemo_absbrake_output;

slipEl = ds.getElement('slip');
uEl    = ds.getElement('conout');

t_slip = slipEl.Values.Time;   s  = slipEl.Values.Data;
t_u    = uEl.Values.Time;      uu = uEl.Values.Data;

referencia = 0.2;

%% --- Janela efetiva -----------------------------------------------------
idxFim = find(s > 0.5, 1, 'first');
if isempty(idxFim), idxFim = numel(s); end
idxFim = idxFim - 1;

tw = t_slip(1:idxFim);
sw = s(1:idxFim);
e  = referencia - sw;

%% --- Metricas -----------------------------------------------------------
ISE  = trapz(tw, e.^2);
IAE  = trapz(tw, abs(e));
ITAE = trapz(tw, tw .* abs(e));
RMSE = sqrt(trapz(tw, e.^2) / (tw(end) - tw(1)));

M = table(RMSE, ISE, IAE, ITAE, ...
    'VariableNames', {'RMSE','ISE','IAE','ITAE'}, ...
    'RowNames', {'SMC'});
disp(' ');
disp('Metricas de desempenho - controlador SMC:');
disp(M);

%% --- Tabela comparativa (preencha os valores do PID depois) -------------
% RMSE_PID=0.0646; ISE_PID=0.0522; IAE_PID=0.6138; ITAE_PID=2.7294;
% Mcomp = table([RMSE_PID;RMSE],[ISE_PID;ISE],[IAE_PID;IAE],[ITAE_PID;ITAE],...
%     'VariableNames',{'RMSE','ISE','IAE','ITAE'},'RowNames',{'PID','SMC'});
% disp(Mcomp);

%% --- Reamostragem para spectrogram --------------------------------------
Fs = 50;
tg = (t_u(1):1/Fs:t_u(end))';
[tu_uni, iu] = unique(t_u);
ug  = interp1(tu_uni, uu(iu), tg, 'linear');
ugc = ug - mean(ug);

%% --- Figura 1: sinal de controle ----------------------------------------
figure('Color','w','Name','SMC - Sinal de Controle');
plot(tg, ug, 'r', 'LineWidth', 1.2);
grid on;
ylabel('u(t)');
xlabel('Tempo (s)');
title('Sinal de controle u(t) - SMC');
xlim([tg(1) tg(end)]);

%% --- Figura 2: espectrograma --------------------------------------------
figure('Color','w','Name','SMC - Espectrograma');
spectrogram(ugc, hamming(64), 60, 128, Fs, 'yaxis');
ylim([0 10]);
xlabel('Tempo (s)');
ylabel('Frequencia (Hz)');
title('Espectrograma do sinal de controle u(t) - SMC');
colorbar;

% Para salvar: exportgraphics(gcf, 'smc_espectrograma.png', 'Resolution', 300);
