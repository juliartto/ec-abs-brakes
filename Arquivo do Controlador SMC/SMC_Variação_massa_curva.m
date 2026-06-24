sldemo_absdata;
K_smc = 500; phi = 0.12;
mdl = 'SMC_sldemo_absbrake';
load_system(mdl);
bloco_mu = 'SMC_sldemo_absbrake/Vehicle Dynamics/Vehicle  /mu-slip friction curve';
mu_nom = [0 .4 .8 .97 1.0 .98 .96 .94 .92 .9 .88 .855 .83 .81 .79 .77 .75 .73 .72 .71 .7];

% === VARIACAO DE MASSA ===
m=350; sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t1=tt(1:idx-1); s1=ss(1:idx-1);
m=500; sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t2=tt(1:idx-1); s2=ss(1:idx-1);
m=650; sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t3=tt(1:idx-1); s3=ss(1:idx-1);

f3=figure('Color','w'); hold on; grid on;
plot(t1,s1,'b','LineWidth',1.4,'DisplayName','m = 350 kg (-30%)');
plot(t2,s2,'r','LineWidth',1.4,'DisplayName','m = 500 kg (nominal)');
plot(t3,s3,'g','LineWidth',1.4,'DisplayName','m = 650 kg (+30%)');
yline(0.2,'--k','LineWidth',1.2,'DisplayName','Referencia (0.2)');
xlabel('Tempo (s)'); ylabel('Escorregamento');
title('SMC nominal - Variacao de massa (\pm30%)');
legend('Location','best'); ylim([0 1]); hold off;
exportgraphics(f3,'smc_variacao_massa.png','Resolution',300);

% === VARIACAO DE MU ===
set_param(bloco_mu,'Table',mat2str(mu_nom*0.7)); sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t1=tt(1:idx-1); s1=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom));     sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t2=tt(1:idx-1); s2=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom*1.3)); sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t3=tt(1:idx-1); s3=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom));

f4=figure('Color','w'); hold on; grid on;
plot(t1,s1,'b','LineWidth',1.4,'DisplayName','mu x0.7 (-30%)');
plot(t2,s2,'r','LineWidth',1.4,'DisplayName','mu nominal');
plot(t3,s3,'g','LineWidth',1.4,'DisplayName','mu x1.3 (+30%)');
yline(0.2,'--k','LineWidth',1.2,'DisplayName','Referencia (0.2)');
xlabel('Tempo (s)'); ylabel('Escorregamento');
title('SMC nominal - Variacao da curva \mu-escorregamento (\pm30%)');
legend('Location','best'); ylim([0 1]); hold off;
exportgraphics(f4,'smc_variacao_mu.png','Resolution',300);

disp('Figuras salvas!');
Figuras salvas!
rtgraphics(f3,'smc_variacao_massa.png','Resolution',300);

% === VARIACAO DE MU ===
set_param(bloco_mu,'Table',mat2str(mu_nom*0.7)); sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t1=tt(1:idx-1); s1=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom));     sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t2=tt(1:idx-1); s2=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom*1.3)); sim(mdl); sl=sldemo_absbrake_output.getElement('slip'); tt=sl.Values.Time; ss=sl.Values.Data; idx=find(ss>0.5,1); if isempty(idx),idx=numel(ss); end; t3=tt(1:idx-1); s3=ss(1:idx-1);
set_param(bloco_mu,'Table',mat2str(mu_nom));

f4=figure('Color','w'); hold on; grid on;
plot(t1,s1,'b','LineWidth',1.4,'DisplayName','mu x0.7 (-30%)');
plot(t2,s2,'r','LineWidth',1.4,'DisplayName','mu nominal');
plot(t3,s3,'g','LineWidth',1.4,'DisplayName','mu x1.3 (+30%)');
yline(0.2,'--k','LineWidth',1.2,'DisplayName','Referencia (0.2)');
xlabel('Tempo (s)'); ylabel('Escorregamento');
title('SMC nominal - Variacao da curva \mu-escorregamento (\pm30%)');
legend('Location','best'); ylim([0 1]); hold off;
exportgraphics(f4,'smc_variacao_mu.png','Resolution',300);

disp('Figuras salvas!');