

function temp_long(csv_dir)

dat=csvread(csv_dir);

sec=dat(:,12);

temp=figure();
hold on
for i=[1:4 6:10]
    t=dat(:,(i+1));
    plot(sec,t)
end

legend('1','2','3','4','6','7','8','9','10')
xlabel('Time (seconds)')
ylabel('Temperature (F)')
title('Temperature in Time')

print(temp,strrep(csv_dir,'data.csv','Temperature'),'-dpdf');


dat=csvread(csv_dir);

sec=dat(:,12);

ind=1:length(sec);


tms=1000;
ps=zeros(10,tms);

for i=1:tms
    ran=datasample(ind,length(ind));
    ran=sort(ran);
    xr=sec(ran);
    
    for j=[1:4 6:10]
        tr=dat(ran,(j+1));
        p=polyfit(xr,tr,1);
        ps(j,i)=p(1);
    end
end

cnum=round((tms*.98)/2,0);
cent=round(tms/2,0);

for i=[1:4 6:10]
    psort=sort(ps(i,:));
    lbd=psort(cent-cnum);
    hibd=psort(cent+cnum);
    if lbd*hibd>0
        pf(i)="Failed";
    else
        pf(i)="Passed";
    end
end

for i=[1:4 6:10]
    d(i)=string(sprintf('Channel %d %s',i,pf(i)));
end
d=char(d([1:4 6:10]))