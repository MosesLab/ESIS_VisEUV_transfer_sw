

function tmp(csv_dir)

dat=csvread(csv_dir);

sec=dat(:,16);

temp=figure();
hold on
for i=[1:4 6:8 10]
    t=dat(:,(i+5));
    plot(sec,t)
end

legend('1','2','3','4','6','7','8','10')
xlabel('Time (seconds)')
ylabel('Temperature (F)')
title('Temperature in Time')

print(temp,strrep(csv_dir,'data.csv','Temperature'),'-dpdf');
