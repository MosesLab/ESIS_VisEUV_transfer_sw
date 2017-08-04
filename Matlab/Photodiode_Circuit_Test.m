
%take many (100-200) measurements over a few (5-10) steps
%read the csv in
data=csvread('vis-euv_20170406-112739.csv');

[len width]=size(data);
width=(width-1)/3;

%prepares the while loop
i=0;
n=-1;
c1data=repmat(0,len,width);

%disregaurds all but channel 1
while(i<width)
    i=i+1;
    n=n+3;
    c1data((1:len),i)=data((1:len),n);
end

%averages all columns of the data to see if on average, voltages changes
%with time
for(i=1:width)
    c1avgc(i)=mean(c1data(:,i));
end

%linear fits the average of columns
figure()
hold on
scatter(1:length(c1avgc),c1avgc)
pf=polyfit(1:length(c1avgc),c1avgc,1);
yy=polyval(pf,1:length(c1avgc));
plot(1:length(c1avgc),yy)
xlabel('Observation Number')
ylabel('Voltage')
title('Average value for each measurement over an entire run')



%formats data for histogram of slopes
for(i=1:len)
    [slope inter]=polyfit((1:width),c1data(i,:),1);
    slope=slope(1);
    slps(i)=slope;
end

%may or may not be a useful figure
figure()
histogram(abs(slps))
xlabel('Slope')
title('Histogram of Absolute Values of Slopes')


%bootstraps data to see if the linear fit is a fluke
n=0;
while(n<1000)
    n=n+1;
    for(i=1:length(c1avgc))
        y(i)=datasample(c1avgc,1);
    end
    x=1:length(c1avgc);
    [p dc]=polyfit(x,y,1);
    avgslps(n)=p(1);
end

%histogram of bootstrapped data with red line equal to the observed slope
figure()
hold on
histogram(abs(avgslps))
plot(repmat(abs(pf(1)),1,140),1:140,'r')
xlabel('Slope')
title('Histogram of Bootstraped Slopes')
legend('Counts','Observed Value')

%finds the p-value of the slope

%if p-value is greater that 90%, test is passed and the electronics of that
%tested channel work

%if p-values is less than 90%, the circuit is messed up and needs
%rethinking

%p-value=probability of seeing a linear fit of the data will be as or more
%extreme as the oberved slope if we were to do the test again.
prop=length(avgslps(find(avgslps>abs(pf(1)))))/(n-1);
sprintf('p-value = %g%%',prop*100)