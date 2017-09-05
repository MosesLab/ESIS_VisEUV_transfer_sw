o3=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser3-45min.csv');
ps=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/PowerSupply-10min.csv');
o2=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser2-1hr.csv');
o1=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser1-1hr.csv');
s1=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser1-1hr-sys.csv');
s2=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser2-50min-sys.csv');
s3=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser3-30min-sys-newsplit.csv');
sth=csvread('/home/krg/ESIS/ESIS_VisEUV_transfer_sw/Output/NoiseTest/laser3-90min-sys-thor.csv');

yo3=o3(:,1);
yps=ps(:,1);
yo2=o2(:,1);
yo1=o1(:,1);
ys1=s1(:,1);
ys2=s2(:,1);
ys3=s3(:,1);
ysth=sth(:,1);

ys1cor=ys1(find(ys1<3.3));
ys1cor=ys1cor(find(ys1cor>3.04));
yo1cor=yo1(find(yo1<4.88));
yo1cor=yo1cor(find(yo1cor>4.83));
ys2cor=ys2(find(ys2<2.7));
yo2cor=yo2(find(yo2<4.82));
yo3cor=yo3(find(yo3<4.37));
ys3cor=ys3(find(ys3<4.4));
ysthcor=ysth(find(ysth<8));
ypscor=yps;

figure()
hold on
plot(1:length(ys1cor),ys1cor)
plot(1:length(yo1cor),yo1cor)
plot(1:length(ys2cor),ys2cor)
plot(1:length(yo2cor),yo2cor)
plot(1:length(ys3cor),ys3cor)
plot(1:length(yo3cor),yo3cor)
plot(1:length(ypscor),ypscor)
plot(1:length(ysthcor),ysthcor)
legend('Laser 1 through System','Laser 1 Output','Laser 2 through System','Laser 2 Output','Laser 3 through System','Laser 3 Output','Power Supply Output','Thorlabs Photodiode Laser 3 through System')
title('Noise Comparison')
xlabel('Time (index)')
ylabel('Intensity (Volts)')

mns1=mean(ys1cor);
mno1=mean(yo1cor);
mns2=mean(ys2cor);
mno2=mean(yo2cor);
mns3=mean(ys3cor);
mno3=mean(yo3cor);
mnps=mean(ypscor);
mnsth=mean(ysthcor);
figure()
hold on
mn=[mns1 mno1 mns2 mno2 mns3 mno3 mnps mnsth];
bar(mn)
set(gca,'XTickLabel',{'','Laser 1 through System','Laser 1 Output','Laser 2 through System','Laser 2 Output','Laser 3 through System','Laser 3 Output','Power Supply Output','Thorlabs Photodiode Laser 3 through System'});
title('Mean Comparison')

mes1=median(ys1cor);
meo1=median(yo1cor);
mes2=median(ys2cor);
meo2=median(yo2cor);
mes3=median(ys3cor);
meo3=median(yo3cor);
meps=median(ypscor);
mesth=median(ysthcor);

figure()
hold on
me=[mes1 meo1 mes2 meo2 mes3 meo3 meps mesth];
bar(me)
set(gca,'XTickLabel',{'','Laser 1 through System','Laser 1 Output','Laser 2 through System','Laser 2 Output','Laser 3 through System','Laser 3 Output','Power Supply Output','Thorlabs Photodiode Laser 3 through System'});
title('Median Comparison')

mds1=std(ys1cor)/mns1;
mdo1=std(yo1cor)/mno1;
mds2=std(ys2cor)/mns2;
mdo2=std(yo2cor)/mno2;
mds3=std(ys3cor)/mns3;
mdo3=std(yo3cor/mno3);
mdps=std(ypscor)/mnps;
mdsth=std(ysthcor)/mnsth;

figure()
hold on
md=100.*[mds1 mdo1 mds2 mdo2 mds3 mdo3 mdps mdsth];
bar(md)
set(gca,'XTickLabel',{'','Laser 1 through System','Laser 1 Output','Laser 2 through System','Laser 2 Output','Laser 3 through System','Laser 3 Output','Power Supply Output','Thorlabs Photodiode Laser 3 through System'});
title('Standard Percent Deviation Comparison')


ys1thr=ys1cor(1:3:length(ys1cor));
mn=mean(ys1thr);
for(j=1:100:length(ys1thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(ys1thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iss1(k)=i;
    catch
    end
end

yo1thr=yo1cor(1:3:length(yo1cor));
mn=mean(yo1thr);
for(j=1:100:length(yo1thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(yo1thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iso1(k)=i;
    catch
    end
end

ys2thr=ys1cor(1:3:length(ys2cor));
mn=mean(ys2thr);
for(j=1:100:length(ys2thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(ys2thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iss2(k)=i;
    catch
    end
end


yo2thr=yo2cor(1:3:length(yo2cor));
mn=mean(yo2thr);
for(j=1:100:length(yo2thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(yo2thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iso2(k)=i;
    catch
    end
end

ys3thr=ys3cor(1:3:length(ys3cor));
mn=mean(ys3thr);
for(j=1:100:length(ys3thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(ys3thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iss3(k)=i;
    catch
    end
end

yo3thr=yo3cor(1:3:length(yo3cor));
mn=mean(yo3thr);
for(j=1:100:length(yo3thr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(yo3thr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    iso3(k)=i;
    catch
    end
end

ypsthr=ypscor(1:3:length(ypscor));
mn=mean(ypsthr);
for(j=1:100:length(ypsthr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(ypsthr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    isps(k)=i;
    catch
    end
end

ysththr=ysthcor(1:3:length(ysthcor));
mn=mean(ysththr);
for(j=1:100:length(ysththr))
    k=((j-1)/100)+1;
    er=5;
    i=0;
    try
    while(.03<er)
        i=i+1;
        mni=mean(ysththr(j:(j+i)));
        er=abs(mni-mn)/mn;
    end
    issth(k)=i;
    catch
    end
end

grp=[iss1 iso1 iss2 iso2 iss3 iso3 isps issth]
mntot=mean(grp)
medtot=median(grp)
stdtot=std(grp)

mncor=mean(grp(find(grp>1)))
figure()
histogram(grp)

sysgrp=[iss1 iss2 iss3]
mnsys=mean(sysgrp)
medsys=median(sysgrp)
stdsys=std(sysgrp)

figure()
histogram(sysgrp)
