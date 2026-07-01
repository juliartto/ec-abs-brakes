%% ========================================================================
%  SMC_NOMINAL.M  -  Controlador SMC nominal para o sistema ABS
%  ------------------------------------------------------------------------
% Calcula RMSE, ISE, IAE e ITAE sobre o erro de escorregamento e plota. 
% PRE-REQUISITOS:
%   1) SMC_sldemo_absbrake.slx no mesmo diretorio.
%   2) sldemo_absdata.m no mesmo diretorio.
%   3) No modelo SMC, o sinal de saida do controlador deve estar logado
%      com o nome  conout.
%   4) O sinal slip deve estar logado com o nome  slip.
% =========================================================================

%% --- Parametros SMC (ficam no workspace para o modelo usar) -------------
K_smc = 3;    % ganho do SMC
phi   = 0.08;   % largura da camada limite

assignin('base', 'K_smc', K_smc);
assignin('base', 'phi',   phi);

%% --- Carrega dados da planta e roda simulacao ---------------------------
sldemo_absdata;

mdl = 'SMC_sldemo_absbrake';
load_system(mdl);
sim(mdl);

%% --- Extrai sinais do dataset -------------------------------------------
ds = sldemo_absbrake_output;

slipEl = ds.getElement('slip');
uEl    = ds.getElement('conout');

t_slip = slipEl.Values.Time;   s  = slipEl.Values.Data;
t_u    = uEl.Values.Time;      uu = uEl.Values.Data;

referencia = 0.2;

%% --- Janela de frenagem efetiva -----------------------------------------
idxFim = find(s > 0.5, 1, 'first');
if isempty(idxFim), idxFim = numel(s); end
idxFim = idxFim - 1;

% Encontra o índice onde o carro parou (quando o slip explode numérico)
idx = find(ss > 0.5, 1); 

if ~isempty(idx)
    % Zera todos os valores de escorregamento e controle do índice até o final
    ss(idx:end) = 0; 
    uu(idx:end) = 0; 
end

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
disp('Metricas de desempenho - controlador SMC (nominal):');
disp(M);

%% --- Figura: subplot slip + acao de controle ----------------------------
figure('Color','w','Name','SMC - Resposta Nominal');

subplot(2,1,1);
plot(t_slip, s, 'b', 'LineWidth', 1.4); hold on;
yline(referencia, '--k', 'LineWidth', 1.2);
grid on;
ylabel('Slip');
title('SMC nominal - Deslizamento e referencia');
legend({'slip(t)', 'Referencia 0.2'}, 'Location', 'best');
ylim([0 1]);

subplot(2,1,2);
plot(t_u, uu, 'r', 'LineWidth', 1.2);
grid on;
xlabel('Tempo (s)');
ylabel('u(t)');
title('Sinal da acao de controle u(t) - SMC');
xlim([t_u(1) t_u(end)]);

% Para salvar: exportgraphics(gcf, 'smc_nominal.png', 'Resolution', 300);
