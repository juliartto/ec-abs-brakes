# 🚗 Modelagem e Controle de ABS via Simulink

![Status do Projeto](https://img.shields.io/badge/Status-Concluído-success)
![Linguagem](https://img.shields.io/badge/MATLAB-R2023a%2B-blue)
![Simulink](https://img.shields.io/badge/Simulink-Modelagem-orange)

Este repositório contém a modelagem, simulação e implementação em ambiente **MATLAB/Simulink** de um **Sistema de Frenagem Antibloqueio (ABS)**, desenvolvido para a disciplina de Análise de Sistemas Lineares (ASL) e publicado no **X Simpósio de Controle e Processos Industriais (SIMPROIN'25)**.

O objetivo central do projeto é realizar uma análise comparativa de controladores sobre a dinâmica de escorregamento do pneu. O foco principal deste conjunto de arquivos é a implementação, validação e comparação de duas estratégias clássicas: o **Controlador Proporcional-Integral-Derivativo (PID)** e o **Controle por Modos Deslizantes (SMC - Sliding Mode Control) com Camada Limite**. Ambos foram projetados para rastrear a razão de escorregamento ideal (s = 0.2) nas rodas.

---

## 📂 Estrutura de Arquivos do Repositório

Abaixo encontra-se a listagem e a descrição detalhada do papel de cada arquivo no projeto:

### 📄 Documentação
* **`Projeto_ASL.pdf`**: Artigo científico completo submetido ao SIMPROIN'25 ("*Modelagem e Controle do Sistema ABS via Simulink: Análise Comparativa de Controladores sobre a Dinâmica de Escorregamento*"). Contém toda a revisão teórica, equacionamento matemático da planta, design analítico do PID no domínio da frequência, design do SMC no domínio do tempo e as conclusões da análise de robustez.

### ⚙️ Modelos Simulink (`.slx`)
* **`PID_sldemo_absbrake.slx`**: Modelo da planta do ABS modificado para utilizar o controlador **PID**. O controlador foi implementado utilizando o bloco nativo do Simulink (forma paralela, tempo contínuo). Atua de forma mais linear e suave sobre a válvula do freio.
* **`SMC_sldemo_absbrake.slx`**: Modelo da planta modificado com a arquitetura **SMC**. O controlador *bang-bang* original foi substituído por uma estratégia não-linear de Modos Deslizantes. Utiliza blocos de soma, ganho e saturação para implementar a camada limite que suaviza a lei de controle e mitiga o chattering.
* **`sldemo_absbrake.slx`**: Modelo padrão e original fornecido pelo Simulink (controlador liga/desliga convencional bang-bang), utilizado como linha de base para as comparações iniciais.
* **`sldemo_wheelspeed_absbrake.slx`**: Modelo auxiliar focado na malha e dinâmica de velocidade angular da roda.

### 💻 Scripts MATLAB (`.m`)
Os scripts em código estruturado são responsáveis pela automação dos testes, cálculo de índices de desempenho e plotagem das curvas dinâmicas:

* **`sldemo_absdata.m`**: **Script essencial de inicialização**. Define constantes físicas fundamentais do veículo (massa nominal m = 500 kg, inércia da roda I = 5 kg·m², raio do pneu Rr = 0.4 m, velocidade inicial v0 = 28 m/s) e a curva não-linear de atrito pneu-pista (*mu-slip*). 
* **`SMC_nominal.m` / Scripts Nominais (PID)**: Scripts automáticos para simulação sob **condições nominais (ideais)**.
  - Carregam as variáveis e configuram os ganhos no workspace (como $K_{smc}$ e $\phi$ para o SMC, ou $K_p, K_i, K_d$ para o PID).
  - Executam o respectivo modelo `.slx` em malha fechada.
  - **Gráficos Gerados**: Criam figuras com a curva de escorregamento real vs. a referência de 0.2, e o sinal de esforço de controle (pressão hidráulica).
  - **Métricas Calculadas**: Exibem no terminal uma tabela com os índices de erro **RMSE, ISE, IAE e ITAE**.
* **`SMC_variacao_parametros.m`**: Script focado no **teste de robustez** sob incertezas severas na planta.
  - Avalia o comportamento do sistema com desvios de **-30%, 0% (Nominal) e +30%** nos parâmetros físicos da planta.
  - Variável de configuração interna `modo`: alternável entre `'escalar'` (injetar variações na massa do veículo) ou `'mu'` (transições para pistas com menor aderência).
  - **Gráficos Gerados**: Executa um loop de simulações e plota as curvas sobrepostas, evidenciando a capacidade do controlador de rejeitar perturbações externas.
* **`sldemo_absbrakeplots.m`**: Script nativo do MATLAB adaptado para plotar a velocidade linear do veículo e a velocidade tangencial da roda.

---

## 🚀 Como Executar as Simulações

Para reproduzir os resultados perfeitamente, garantindo que as variáveis de espaço de estado do carro sejam carregadas corretamente, siga este passo a passo:

### 1. Inicialização do Sistema (Obrigatório)
Antes de rodar qualquer modelo ou gráfico, o MATLAB precisa conhecer a física do carro. No *Command Window*, digite:
```matlab
sldemo_absdata
