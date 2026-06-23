%% ========================================================================
%  Analise de variacao de parametros - Sistema ABS com controlador PID
%  ------------------------------------------------------------------------
%  Mantem o PID com ganhos nominais FIXOS e varia uma incerteza da planta
%  (-30%, nominal, +30%) para avaliar a robustez do controlador.
%
%  Dois modos, escolhidos na variavel 'modo' abaixo:
%    'escalar' -> varia um parametro escalar do workspace (massa 'm', 'Kf'...)
%    'mu'      -> escala os VALORES de mu da curva mu-slip (piso molhado/seco)
%
%  PRE-REQUISITOS:
%   1) Signal logging ligado (dataset: sldemo_absbrake_output).
%   2) Fio do slip marcado com "Log Selected Signals" e nomeado 'slip'.
%   3) A variavel 'mu' deve existir no workspace (criada pelo PreLoadFcn).
% =========================================================================
mdl = 'PID_sldemo_absbrake';        % <-- nome do teu modelo
load_system(mdl);
referencia = 0.2;                   % slip desejado

%% ===================== ESCOLHA O MODO AQUI ==============================
modo = 'mu';                        % 'escalar' ou 'mu'
variacoes = [-0.30, 0, 0.30];       % -30%, nominal, +30%

% --- parametros do modo 'escalar' ---
nomeParam = 'm';                    % 'm' (massa), 'Kf', etc.

% --- parametros do modo 'mu' ---
bloco = [mdl '/Vehicle Dynamics/Vehicle  /mu-slip friction curve'];  % DOIS espacos
% ========================================================================

%% --- prepara o valor de base conforme o modo ----------------------------
switch modo
    case 'escalar'
        baseVal = evalin('base', nomeParam);
        tituloVar = nomeParam;

    case 'mu'
        nomeVarTabela = get_param(bloco, 'Table');   % retorna 'mu'
        mu_nom = evalin('base', nomeVarTabela);
        mu_nom = double(mu_nom(:)).';
        tituloVar = 'curva mu-slip';

    otherwise
        error('modo invalido: use ''escalar'' ou ''mu''.');
end

%% --- loop de simulacoes --------------------------------------------------
cores = lines(numel(variacoes));
figure('Color','w');
resultados = struct();
hCurvas = gobjects(1, numel(variacoes));   % handles das curvas

for k = 1:numel(variacoes)
    fator = 1 + variacoes(k);
    in = Simulink.SimulationInput(mdl);

    switch modo
        case 'escalar'
            valor  = baseVal * fator;
            in     = in.setVariable(nomeParam, valor);
            rotulo = sprintf('%s = %.3g  (%+d%%)', nomeParam, valor, round(variacoes(k)*100));

        case 'mu'
            mu_var = mu_nom * fator;
            in     = in.setBlockParameter(bloco, 'Table', mat2str(mu_var));
            rotulo = sprintf('mu x%.1f  (%+d%%)', fator, round(variacoes(k)*100));
    end

    out = sim(in);

    if ~isprop(out, 'sldemo_absbrake_output') || isempty(out.sldemo_absbrake_output)
        error('Nada foi logado. Verifique o Signal logging e o sinal slip.');
    end

    slipSig = out.sldemo_absbrake_output.getElement('slip');
    t       = slipSig.Values.Time;
    slip    = slipSig.Values.Data;

    resultados(k).variacao = variacoes(k);
    resultados(k).t        = t;
    resultados(k).slip     = slip;
    resultados(k).slpErr   = referencia - slip;

    hold on;
    hCurvas(k) = plot(t, slip, 'Color', cores(k,:), 'LineWidth', 1.4, ...
                      'DisplayName', rotulo);
    drawnow;
end

hRef = yline(referencia, '--k', 'LineWidth', 1.2, 'DisplayName', 'referencia (0.2)');

grid on;
xlabel('Tempo (s)');
ylabel('Slip (razao de escorregamento)');
title(sprintf('PID nominal sob variacao de %s', tituloVar));
legend([hCurvas, hRef], 'Location', 'best');   % so as curvas + referencia
ylim([0 1]);
hold off;

% exportgraphics(gcf, 'varia_parametros_slip.png', 'Resolution', 300);