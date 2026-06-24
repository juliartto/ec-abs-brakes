# 🚗 Modelagem e Controle de ABS via Simulink

![Status do Projeto](https://img.shields.io/badge/Status-Concluído-success)
![Linguagem](https://img.shields.io/badge/MATLAB-R2026a%2B-blue)
![Simulink](https://img.shields.io/badge/Simulink-Modelagem-orange)

Este repositório contém a modelagem, simulação e implementação em ambiente **MATLAB/Simulink** de um **Sistema de Frenagem Antibloqueio (ABS)**, desenvolvido para a disciplina de Análise de Sistemas Lineares (ASL) e publicado no **X Simpósio de Controle e Processos Industriais (SIMPROIN'25)**.

O objetivo central do projeto é realizar uma análise comparativa de controladores sobre a dinâmica de escorregamento do pneu. O foco principal deste conjunto de arquivos é a implementação, validação e comparação de duas estratégias clássicas: o **Controlador Proporcional-Integral-Derivativo (PID)** e o **Controle por Modos Deslizantes (SMC - Sliding Mode Control) com Camada Limite**. Ambos foram projetados para rastrear a razão de escorregamento ideal (s = 0.2) nas rodas.

---

## 📂 Estrutura de Arquivos do Repositório

Abaixo encontra-se a listagem e a descrição detalhada do papel de cada arquivo no projeto:

### 📄 Documentação
* **`Modelagem e Controle do Sistema ABS via SimuLink.pdf`**: Artigo científico completo submetido ao SIMPROIN'25 ("*Modelagem e Controle do Sistema ABS via Simulink: Análise Comparativa de Controladores sobre a Dinâmica de Escorregamento*"). Contém toda a revisão teórica, equacionamento matemático da planta, design analítico do PID no domínio da frequência, design do SMC no domínio do tempo e as conclusões da análise de robustez.

### ⚙️ Modelos Simulink (`.slx`)
* **`PID_sldemo_absbrake.slx`**: Modelo da planta do ABS modificado para utilizar o controlador **PID**. O controlador foi implementado utilizando o bloco nativo do Simulink (forma paralela, tempo contínuo). Atua de forma mais linear e suave sobre a válvula do freio.
* **`SMC_sldemo_absbrake.slx`**: Modelo da planta modificado com a arquitetura **SMC**. O controlador *bang-bang* original foi substituído por uma estratégia não-linear de Modos Deslizantes. Utiliza blocos de soma, ganho e saturação para implementar a camada limite que suaviza a lei de controle e mitiga o chattering.
* **`sldemo_absbrake.slx`**: Modelo padrão e original fornecido pelo Simulink (controlador liga/desliga convencional bang-bang), utilizado como linha de base para as comparações iniciais.
* **`sldemo_wheelspeed_absbrake.slx`**: Modelo auxiliar focado na malha e dinâmica de velocidade angular da roda.

### 💻 Scripts MATLAB (`.m`)
Os scripts em código estruturado são responsáveis pela automação dos testes, cálculo de índices de desempenho e plotagem das curvas dinâmicas:

* **`sldemo_absdata.m`**: **Script essencial de inicialização**. Define constantes físicas fundamentais do veículo (massa nominal m = 500 kg, inércia da roda I = 5 kg·m², raio do pneu Rr = 0.4 m, velocidade inicial v0 = 28 m/s) e a curva não-linear de atrito pneu-pista (*mu-slip*). **Deve ser executado antes de rodar os modelos**.

#### 🔹 Scripts do Controlador SMC
* **`SMC_nominal.m`**: Script automático para simulação sob condições ideais. Carrega os ganhos, roda a simulação, calcula as métricas de erro integral (RMSE, ISE, IAE e ITAE) e plota o rastreamento do escorregamento vs. esforço de controle.
* **`SMC_variacao_parametros.m`**: Teste de robustez do SMC. Roda o sistema com desvios de -30%, 0% e +30% na massa do carro (`modo = 'escalar'`) ou na pista (`modo = 'mu'`), gerando gráficos sobrepostos para atestar a estabilidade frente a distúrbios.

#### 🔹 Scripts do Controlador PID
* **`subplots.m`**: Script automático para análise do PID em condições nominais. Roda o modelo `PID_sldemo_absbrake`, calcula as métricas de desempenho (RMSE, ISE, IAE, ITAE) e gera uma figura completa com 3 subplots: a curva de escorregamento, o sinal de controle u(t) e o respectivo espectrograma do sinal.
* **`variacao_parametros_pid.m`**: Teste de robustez dedicado ao PID. Funciona de forma similar ao teste do SMC, avaliando a perda de desempenho do sistema linear sob incertezas de -30% a +30% na massa ou pista.

#### 🔹 Utilidades
* **`sldemo_absbrakeplots.m`**: Script nativo do MATLAB adaptado para plotar a velocidade linear do veículo e a velocidade tangencial da roda.

---
### 👥 Autores
| [<img loading="lazy" src="https://avatars.githubusercontent.com/u/188865867?v=4" width=115><br><sub>Felipe Rochoel</sub>](https://github.com/rochoel-felipe) |  [<img loading="lazy" src="https://avatars.githubusercontent.com/u/132113334?v=4" width=115><br><sub>Julia Romanetto</sub>](https://github.com/juliartto) |  [<img loading="lazy" src="https://avatars.githubusercontent.com/u/188619435?v=4" width=115><br><sub>Vinicius Gabriel</sub>](https://github.com/Vinegabriel) |
:---: | :---: | :---: |
