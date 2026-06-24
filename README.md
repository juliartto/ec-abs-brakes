# 🚗 Modelagem e Controle de ABS via Simulink

![Status do Projeto](https://img.shields.io/badge/Status-Concluído-success)
![Linguagem](https://img.shields.io/badge/MATLAB-R2023a%2B-blue)
![Simulink](https://img.shields.io/badge/Simulink-Modelagem-orange)

Este repositório contém a modelagem, simulação e implementação em ambiente **MATLAB/Simulink** de um **Sistema de Frenagem Antibloqueio (ABS)**, desenvolvido para a disciplina de Análise de Sistemas Lineares (ASL) e publicado no **X Simpósio de Controle e Processos Industriais (SIMPROIN'25)**.

O objetivo central do projeto é realizar uma análise comparativa de controladores sobre a dinâmica de escorregamento do pneu. O foco principal deste conjunto de arquivos é a implementação e validação do **Controle por Modos Deslizantes (SMC - Sliding Mode Control) com Camada Limite**, projetado para garantir o rastreamento da razão de escorregamento ideal (s = 0.2) e conferir máxima robustez contra perturbações e incertezas paramétricas da planta (como variações na massa do veículo e no coeficiente de atrito da pista).

---

## 📂 Estrutura de Arquivos do Repositório

Abaixo encontra-se a listagem e a descrição detalhada do papel de cada arquivo no projeto:

### 📄 Documentação
* **`Projeto_ASL.pdf`**: Artigo científico completo submetido ao SIMPROIN'25 ("*Modelagem e Controle do Sistema ABS via Simulink: Análise Comparativa de Controladores sobre a Dinâmica de Escorregamento*"). Contém toda a revisão teórica, equacionamento matemático da planta, design analítico do PID e do SMC, além das discussões e conclusões sobre o fenômeno do *chattering* e a análise de robustez.

### ⚙️ Modelos Simulink (`.slx`)
* **`SMC_sldemo_absbrake.slx`**: **O modelo principal do projeto**. Consiste no clássico benchmark `sldemo_absbrake` modificado. O controlador *bang-bang* original da MathWorks foi integralmente substituído pela arquitetura do controlador por modos deslizantes (SMC) projetada pelo grupo. Utiliza blocos de soma, ganho e saturação para implementar a camada limite que suaviza a lei de controle.
* **`sldemo_absbrake.slx`**: Modelo padrão e original fornecido pelo Simulink (controlador liga/desliga convencional), utilizado como linha de base para as comparações iniciais.
* **`sldemo_wheelspeed_absbrake.slx`**: Modelo auxiliar focado na malha e dinâmica de velocidade angular da roda.

### 💻 Scripts MATLAB (`.m`)
Os scripts em código estruturado são responsáveis pela automação dos testes, cálculo de índices de desempenho e plotagem das curvas dinâmicas:

* **`sldemo_absdata.m`**: Script essencial de inicialização da planta. Define constantes físicas fundamentais do veículo (massa nominal m = 500 kg, inércia da roda I = 5 kg·m², raio do pneu Rr = 0.4 m, velocidade inicial v0 = 28 m/s) e os vetores que descrevem a curva não-linear de atrito pneu-pista (*mu-slip*). **Deve ser executado antes de rodar os modelos**.
* **`SMC_nominal.m`**: Script automático para simulação sob **condições nominais (ideais)**.
  - Carrega as variáveis e configura os ganhos do controlador no workspace.
  - Executa em malha fechada o modelo `SMC_sldemo_absbrake.slx`.
  - Extrai os logs de simulação (`slip` e `conout`).
  - **Gráficos Gerados**: Cria uma figura com subplots contendo a curva de escorregamento real vs. a referência de 0.2, e o sinal de esforço de controle aplicado na válvula hidráulica de pressão do freio.
  - **Métricas Calculadas**: Computa e exibe uma tabela com os índices de erro integral **RMSE, ISE, IAE e ITAE** na janela de frenagem efetiva.
* **`SMC_variacao_parametros.m`**: Script focado no **teste de robustez** do SMC sob incertezas severas na planta.
  - Avalia o comportamento do sistema com desvios de **-30%, 0% (Nominal) e +30%** nos parâmetros físicos, mantendo os ganhos do controlador fixos.
  - Possui uma variável interna `modo` para alternar o cenário: `'escalar'` para injetar variações na massa do veículo ou `'mu'` para aplicar fatores de escala na curva de atrito pneu-pista.
  - **Gráficos Gerados**: Executa um loop de simulações e plota as curvas de escorregamento sobrepostas na mesma tela, evidenciando graficamente a capacidade do SMC de rejeitar distúrbios sem perder a estabilidade.
* **`sldemo_absbrakeplots.m`**: Script nativo do MATLAB adaptado para plotar as velocidades lineares do veículo vs. velocidade tangencial da roda a partir dos dados gravados.

---

## 🚀 Como Executar as Simulações

Para reproduzir os resultados apresentados no artigo e visualizar os gráficos gerados, siga os passos abaixo no MATLAB:

### 1. Resposta Nominal e Métricas
Para rodar a simulação padrão e analisar o erro de rastreamento do escorregamento, execute diretamente no Command Window:
```matlab
SMC_nominal
