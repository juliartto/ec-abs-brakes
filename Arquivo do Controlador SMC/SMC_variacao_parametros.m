%% ========================================================================
%  SMC_VARIACAO_PARAMETROS.M
%  ------------------------------------------------------------------------
%  Mantem o SMC com ganhos FIXOS e varia um parametro da planta em
%  -30%, nominal, +30%.
%
%  Mude a variavel 'modo':
%    'escalar' -> varia a massa do veiculo (m)
%    'mu'      -> escala a curva mu-slip (diferentes pisos)
% =========================================================================

%% --- Parametros SMC (mesmos do nominal) ---------------------------------
assignin('base', 'K_smc', 500);
assignin('base', 'phi',   0.12);

sldemo_absdata;

mdl = 'SMC_sldemo_absbrake';
load_system(mdl);

referencia = 0.2;

%% ===================== ESCOLHA O MODO AQUI ==============================
modo = 'mu';          % <-- troque para 'escalar' para variar a massa

variacoes = [-0.30, 0, 0.30];

% Caminho do bloco da curva mu-slip (modo 'mu')
bloco = 'SMC_sldemo_absbrake/Vehicle Dynamics/Vehicle  /mu-slip friction curve';
% =========================================================================

%% --- Valor base ---------------------------------------------------------
switch modo
    case 'escalar'
        baseVal   = evalin('base', 'm');
        tituloVar = 'massa do veiculo (m)';
    case 'mu'
        mu_nom = str2num(get_param(bloco, 'Table')); %#ok<ST2NM>
        if isempty(mu_nom)
            mu_nom = evalin('base', get_param(bloco, 'Table'));
        end
        tituloVar = 'curva mu-slip';
    otherwise
        error('modo invalido: use ''escalar'' ou ''mu''.');
end

%% --- Loop de simulacoes -------------------------------------------------
cores      = lines(numel(variacoes));
resultados = struct();

figure('Color','w','Name','SMC - Variacao de Parametros');
hold on; grid on;

for k = 1:numel(variacoes)
    fator = 1 + variacoes(k);
    in    = Simulink.SimulationInput(mdl);

    switch modo
        case 'escalar'
            valor  = baseVal * fator;
            in     = in.setVariable('m', valor);
            rotulo = sprintf('m = %.0f kg  (%+d%%)', valor, round(variacoes(k)*100));
        case 'mu'
            mu_var = mu_nom * fator;
            in     = in.setBlockParameter(bloco, 'Table', mat2str(mu_var));
            rotulo = sprintf('mu x%.1f  (%+d%%)', fator, round(variacoes(k)*100));
    end

    out = sim(in);

    slipSig = out.sldemo_absbrake_output.getElement('slip');
    t    = slipSig.Values.Time;
    slip = slipSig.Values.Data;

    resultados(k).t    = t;
    resultados(k).slip = slip;

    plot(t, slip, 'Color', cores(k,:), 'LineWidth', 1.4, 'DisplayName', rotulo);
end

yline(referencia, '--k', 'LineWidth', 1.2, 'DisplayName', 'Referencia (0.2)');
xlabel('Tempo (s)');
ylabel('Slip');
title(sprintf('SMC nominal sob variacao de %s', tituloVar));
legend('Location', 'best');
ylim([0 1]);
hold off;

% Para salvar: exportgraphics(gcf, 'smc_variacao.png', 'Resolution', 300);
