
%plots everything and changes data by gaussian

run data_transformer.m

global distanc1
global distanc2
global distanc3
global voltag1
global voltag2
global voltag3
global distance1
global distance2
global distance3
global voltage1
global voltage2
global voltage3

figure()

hold on

scatter(distanc1,voltag1,'r')
scatter(distanc2,voltag2,'b')
scatter(distanc3,voltag3,'g')

min_dis=min([distanc1 distanc2 distanc3]);
max_dis=max([distanc1 distanc2 distanc3]);

prec_dis=min_dis:.0002:max_dis;

pft1=polyfit(distanc1,voltag1,4);
pft_pre_gaus1=polyval(pft1,prec_dis);

pft2=polyfit(distanc2,voltag2,4);
pft_pre_gaus2=polyval(pft2,prec_dis);

pft3=polyfit(distanc3,voltag3,4);
pft_pre_gaus3=polyval(pft3,prec_dis);

pre_gaus_plot1=plot(prec_dis,pft_pre_gaus1,'r');
pre_gaus_plot2=plot(prec_dis,pft_pre_gaus2,'b');
pre_gaus_plot3=plot(prec_dis,pft_pre_gaus3,'g');

legend([pre_gaus_plot1,pre_gaus_plot2,pre_gaus_plot3],{'data1','data2','data3'})
title('Original data with 4th degree polynomial fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

%saves to a folder

ft_gaus1=fit(distanc1,voltag1,'gauss1');
ft_gaus2=fit(distanc2,voltag2,'gauss1');
ft_gaus3=fit(distanc3,voltag3,'gauss1');

gaus_voltag1=ft_gaus1(prec_dis);
gaus_voltag2=ft_gaus2(prec_dis);
gaus_voltag3=ft_gaus3(prec_dis);

figure()

hold on

scatter(distanc1,voltag1,'r')
scatter(distanc2,voltag2,'b')
scatter(distanc3,voltag3,'g')
hold on
gaus_plot1=plot(prec_dis,gaus_voltag1,'r');
gaus_plot2=plot(prec_dis,gaus_voltag2,'b');
gaus_plot3=plot(prec_dis,gaus_voltag3,'g');

legend([gaus_plot1,gaus_plot2,gaus_plot3],{'data1','data2','data3'})
title('Original data with a 1st Gaussian fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

%saves to a folder

bnd_gaus1=ft_gaus1.a1/2;
bnd_gaus2=ft_gaus2.a1/2;
bnd_gaus3=ft_gaus3.a1/2;

distance1=distanc1(voltag1>bnd_gaus1);
voltage1=voltag1(voltag1>bnd_gaus1);
distance2=distanc2(voltag2>bnd_gaus1);
voltage2=voltag2(voltag2>bnd_gaus1);
distance3=distanc3(voltag3>bnd_gaus1);
voltage3=voltag3(voltag3>bnd_gaus1);

dis_prec1=min(distance1):.0002:max(distance1);
dis_prec2=min(distance2):.0002:max(distance2);
dis_prec3=min(distance3):.0002:max(distance3);

post_gaus_pft1=polyfit(distance1,voltage1,4);
pft_post_gaus1=polyval(post_gaus_pft1,dis_prec1);

post_gaus_pft2=polyfit(distance2,voltage2,4);
pft_post_gaus2=polyval(post_gaus_pft2,dis_prec2);

post_gaus_pft3=polyfit(distance3,voltage3,4);
pft_post_gaus3=polyval(post_gaus_pft3,dis_prec3);

figure()

hold on

scatter(distance1,voltage1,'r')
scatter(distance2,voltage2,'b')
scatter(distance3,voltage3,'g')

hold on

post_gaus_plot1=plot(dis_prec1,pft_post_gaus1,'r');
post_gaus_plot2=plot(dis_prec2,pft_post_gaus2,'b');
post_gaus_plot3=plot(dis_prec3,pft_post_gaus3,'g');

legend([post_gaus_plot1,post_gaus_plot2,post_gaus_plot3],{'data1','data2','data3'})
title('Relevant data with 4th degree polynomial fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

figure()

hold on

scatter(distanc1,voltag1,'r');
scatter(distanc2,voltag2,'b');
scatter(distanc3,voltag3,'g');

hold on

scatter(distance1,voltage1,'m');
scatter(distance2,voltage2,'c');
scatter(distance3,voltage3,'k');

hold on

pre_gaus_plot1=plot(prec_dis,pft_pre_gaus1,'r');
pre_gaus_plot2=plot(prec_dis,pft_pre_gaus2,'b');
pre_gaus_plot3=plot(prec_dis,pft_pre_gaus3,'g');

hold on

gaus_plot1=plot(prec_dis,gaus_voltag1,'Color',[.5,0,.5]);
gaus_plot2=plot(prec_dis,gaus_voltag2,'Color',[0,.5,.5]);
gaus_plot3=plot(prec_dis,gaus_voltag3,'Color',[.5,.5,.5]);
hold on

post_gaus_plot1=plot(dis_prec1,pft_post_gaus1,'m');
post_gaus_plot2=plot(dis_prec2,pft_post_gaus2,'c');
post_gaus_plot3=plot(dis_prec3,pft_post_gaus3,'k');
hold on

title('Polynomial fits to parts of data')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

legend([pre_gaus_plot1,pre_gaus_plot2,pre_gaus_plot3,post_gaus_plot1,post_gaus_plot2,post_gaus_plot3,gaus_plot1,gaus_plot2,gaus_plot3],{'Unused1','Unused2','Unused3','Used1','Used2','Used3','Gausian1','Gausian2','Gausian3'})

%saves image to folder