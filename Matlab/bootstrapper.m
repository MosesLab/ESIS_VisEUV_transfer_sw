
%OVERVIEW: Finds the range of distance values which maximize the voltage by
%performing bootstrap statistics. Outputs most likely distance value and
%bounds for a 98% confidence interval.

%all data variables output/input from/to this program
global distance1
global distance2
global distance3
global voltage1
global voltage2
global voltage3
global hi_rng
global conf_int1
global conf_int2
global conf_int3

%keeps from command window cluttering up with warning about ill conditioned
%polynomial fits
warning('off','all')

%number of times boostrap is repeated
times=1000;

%the following code to the end of the while loop is repeated for all 3
%measurements

%initial value for while loop
tim=0;

len1=length(voltage1);

prec_dis1=min(distance1):.0001:max(distance1);

%reserves space for the distance value which maximizes the the voltage for
%all the bootstraps
maxxs1=repmat(0,1,times);


while(tim<times)
    tim=tim+1;
    
    %takes a random sample of numbers cooresponding to distance/voltage
    %data points and creates new variables for the randomly selected
    %variables
    indexnew=datasample(1:len1,len1);
    bot_dis1=distance1(indexnew);
    bot_vol1=voltage1(indexnew);
    
    %does 4th order polynomial fit to randomly selected data points
    pft1=polyfit(bot_dis1,bot_vol1,4);
    ft_vol1=polyval(pft1,prec_dis1);
    
    %fills data variable with the distance value which maximizes the
    %polynomial fit to the radonly selected data
    maxxs1(tim)=prec_dis(find(ft_vol1==max(ft_vol1)));
end

tim=0;

len2=length(voltage2);

prec_dis2=min(distance2):.0001:max(distance2);

maxxs2=repmat(0,1,times);

while(tim<times)
    tim=tim+1;
    
    indexnew=datasample(1:len2,len2);
    bot_dis2=distance2(indexnew);
    bot_vol2=voltage2(indexnew);
    
    pft2=polyfit(bot_dis2,bot_vol2,4);
    ft_vol2=polyval(pft2,prec_dis2);
    
    maxxs2(tim)=prec_dis2(find(ft_vol2==max(ft_vol2)));
end

tim=0;

len3=length(voltage3);

prec_dis3=min(distance3):.0001:max(distance3);

maxxs3=repmat(0,1,times);


while(tim<times)
    tim=tim+1;
    
    indexnew=datasample(1:len3,len3);
    bot_dis3=distance3(indexnew);
    bot_vol3=voltage3(indexnew);
    
    pft3=polyfit(bot_dis3,bot_vol3,4);
    ft_vol3=polyval(pft3,prec_dis3);
    
    maxxs3(tim)=prec_dis3(find(ft_vol3==max(ft_vol3)));
end

%creates histogram with formatting of the maxxs# values
figure()
hold on
histogram(maxxs1)
title('Histogram of  Measurement 1')
xlabel('Distance (mm)')

figure()
hold on
histogram(maxxs2)
title('Histogram of  Measurement 2')
xlabel('Distance (mm)')

figure()
hold on
histogram(maxxs3)
title('Histogram of  Measurement 3')
xlabel('Distance (mm)')

%puts maxxs# in order from smallest to greates
maxxs1=sort(maxxs1);
maxxs2=sort(maxxs2);
maxxs3=sort(maxxs3);

%index number of how far to move from data center get 98% confidence
num_pt=round(length(maxxs1)*.98/2,0);

%finds bounds for confidence intervals
lwbd1=maxxs1((times/2)-num_pt);
hibd1=maxxs1((times/2)+num_pt);
lwbd2=maxxs2((times/2)-num_pt);
hibd2=maxxs2((times/2)+num_pt);
lwbd3=maxxs3((times/2)-num_pt);
hibd3=maxxs3((times/2)+num_pt);

%width of the confidence intervals
rng1=hibd1-lwbd1;
rng2=hibd1-lwbd1;
rng3=hibd1-lwbd1;

%finds the widest confidence interval
hi_rng=max([rng1 rng2 rng3]);

%makes variable with confidence interval bounds, width, and most likely value 
conf_int1=[lwbd1 hibd1 rng1 mode(maxxs1)];
conf_int2=[lwbd2 hibd2 rng2 mode(maxxs2)];
conf_int3=[lwbd3 hibd3 rng3 mode(maxxs3)];

%%%%%save conf_int1,conf_int2,conf_int3
%%%%%save histograms