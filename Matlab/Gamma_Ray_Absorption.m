blocks=0:2:14;
T=[35 300 300 300 302 315 300 300];
count=[1000 861 665 447 364 309 268 185];
cps=count./T;
lncps=log(cps);
er=1./(T.*(count).^(1/2));
ercor=1./(T.*(count-103*T/300).^(1/2));

thk=.016;
stthk=.0016;
thknes=thk.*blocks;

hold on
scatter(thknes,lncps)
errorbar(thknes,lncps,ercor,'vertical')
errorbar(thknes,lncps,repmat(stthk,1,length(thknes)),'horizontal')


ylabel('Ln(Intensity)')
xlabel('Thickness of Lead')

ft=polyfit(thknes(2:end),lncps(2:end),1);
ylin=polyval(ft,thknes(2:end));

plot(thknes(2:end),ylin)

hithklo=thknes(2)-stthk;
hithkhi=thknes(end)+stthk;
lothklo=thknes(2)+stthk;
lothkhi=thknes(end)-stthk;
hilncpslo=lncps(2)+ercor(2);
hilncpshi=lncps(end)+ercor(end);
lolncpslo=lncps(2)-ercor(2);
lolncpshi=lncps(end)-ercor(end);

slp=(lncps(2)-lncps(end))/(thknes(end)-thknes(2))
hislp=(hilncpslo-lolncpshi)/(lothkhi-lothklo)
loslp=(lolncpslo-hilncpshi)/(hithkhi-hithklo)

dif1=hislp-slp
dif2=slp-loslp
ag=mean([dif1 dif2])
slp