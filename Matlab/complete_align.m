function [cont_loop, strt, stp, stept, mest,iteration] = complete_align(csv_dir,iteration)
warning('off','all');
%{
global distanc1
global voltag1
global voltag2
global voltag3
%dummy data
distanc1=3.9:.001:4.1;
distanc2=distanc1;
distanc3=distanc1;

voltag1=8*exp(-(distanc1-3.98).^2/.003);
voltag2=6*exp(-(distanc1-4.02).^2/.001);
voltag3=9*exp(-(distanc1-4).^2/.005);
%}


%OVERVIEW: formats data into readable format and makes it available to
%other programs

%all data variables output from this program

%here data will be interpreted from its csv format

iteration=iteration+1;
data=csvread(csv_dir);

[h l]=size(data);

%position of stage at time of measurement
distanc1=data(:,1)';
%distanc values will be the same for all 3 data sets
distanc2=distanc1;
distanc3=distanc1;


%voltag values will differ between the 3 measurements
%averages multiple measurements for a single distance
for(n=(1:h))
    voltag1(n)=mean(data(n,2:3:end));
    voltag2(n)=mean(data(n,3:3:end));
    voltag3(n)=mean(data(n,4:3:end));
end







%OVERVIEW: plots data and fits to data; cuts unneccessary data

%gets data in usable format


original_4th_poly=figure(1);
hold on

%scatter plot of all data
scatter(distanc1,voltag1,'r')
scatter(distanc2,voltag2,'b')
scatter(distanc3,voltag3,'g')

%finds min and max distance values for plotting
min_dis=min(distanc1);
max_dis=max(distanc1);

%makes makes array of very precise distance values that will be used for
%fit
prec_dis=min_dis:.0002:max_dis;

%does a 4th degree polynomial fit to data
pft1=polyfit(distanc1,voltag1,4);
pft_pre_gaus1=polyval(pft1,prec_dis);

pft2=polyfit(distanc2,voltag2,4);
pft_pre_gaus2=polyval(pft2,prec_dis);

pft3=polyfit(distanc3,voltag3,4);
pft_pre_gaus3=polyval(pft3,prec_dis);

%plots polynomial fits over scatter plot
pre_gaus_plot1=plot(prec_dis,pft_pre_gaus1,'r');
pre_gaus_plot2=plot(prec_dis,pft_pre_gaus2,'b');
pre_gaus_plot3=plot(prec_dis,pft_pre_gaus3,'g');

%formatting
legend([pre_gaus_plot1,pre_gaus_plot2,pre_gaus_plot3],{'data1','data2','data3'})
title('Original data with 4th degree polynomial fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

%%%%%saves to a folder

%does a 1st order gausian fit to data
ft_gaus1=fit(distanc1',voltag1','gauss1');
ft_gaus2=fit(distanc2',voltag2','gauss1');
ft_gaus3=fit(distanc3',voltag3','gauss1');

gaus_voltag1=ft_gaus1(prec_dis);
gaus_voltag2=ft_gaus2(prec_dis);
gaus_voltag3=ft_gaus3(prec_dis);

original_1st_gaus=figure(2);

hold on

%plots scatter plot of original data
scatter(distanc1,voltag1,'r')
scatter(distanc2,voltag2,'b')
scatter(distanc3,voltag3,'g')

%plots gaussian fits over scatter plot
gaus_plot1=plot(prec_dis,gaus_voltag1,'r');
gaus_plot2=plot(prec_dis,gaus_voltag2,'b');
gaus_plot3=plot(prec_dis,gaus_voltag3,'g');

%formatting
legend([gaus_plot1,gaus_plot2,gaus_plot3],{'data1','data2','data3'})
title('Original data with a 1st Gaussian fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

%%%%%saves to a folder

%finds half max of gausian fit
bnd_gaus1=ft_gaus1.a1/2;
bnd_gaus2=ft_gaus2.a1/2;
bnd_gaus3=ft_gaus3.a1/2;

%cuts all data that isn't higher than half the height of the guassian fit
distance1=distanc1(voltag1>bnd_gaus1)';
voltage1=voltag1(voltag1>bnd_gaus1)';
distance2=distanc2(voltag2>bnd_gaus1)';
voltage2=voltag2(voltag2>bnd_gaus1)';
distance3=distanc3(voltag3>bnd_gaus1)';
voltage3=voltag3(voltag3>bnd_gaus1)';

%makes new precise distance values for fitting, but now specific to each
%measurement

dis_prec1=min(distance1):.0002:max(distance1);
dis_prec2=min(distance2):.0002:max(distance2);
dis_prec3=min(distance3):.0002:max(distance3);

%does 4th order polynomial fit to new data
post_gaus_pft1=polyfit(distance1,voltage1,4);
pft_post_gaus1=polyval(post_gaus_pft1,dis_prec1);

post_gaus_pft2=polyfit(distance2,voltage2,4);
pft_post_gaus2=polyval(post_gaus_pft2,dis_prec2);

post_gaus_pft3=polyfit(distance3,voltage3,4);
pft_post_gaus3=polyval(post_gaus_pft3,dis_prec3);

relevant_4th_poly=figure(3);

hold on

%scatter plot of cut data
scatter(distance1,voltage1,'r')
scatter(distance2,voltage2,'b')
scatter(distance3,voltage3,'g')

%plots polynomial fit of data over scatter plot
post_gaus_plot1=plot(dis_prec1,pft_post_gaus1,'r');
post_gaus_plot2=plot(dis_prec2,pft_post_gaus2,'b');
post_gaus_plot3=plot(dis_prec3,pft_post_gaus3,'g');

%formatting
legend([post_gaus_plot1,post_gaus_plot2],{'data1','data2'})
title('Relevant data with 4th degree polynomial fit')
xlabel('Distance (mm)')
ylabel('Voltage (V)')

all_fig_combo=figure(4);

hold on

%scatter plot of original data
scatter(distanc1,voltag1,'r');
scatter(distanc2,voltag2,'b');
scatter(distanc3,voltag3,'g');

%scatter plot of cut data over original data
scatter(distance1,voltage1,'m');
scatter(distance2,voltage2,'c');
scatter(distance3,voltage3,'k');

%plots original polynomial fits
pre_gaus_plot1=plot(prec_dis,pft_pre_gaus1,'r');
pre_gaus_plot2=plot(prec_dis,pft_pre_gaus2,'b');
pre_gaus_plot3=plot(prec_dis,pft_pre_gaus3,'g');

%plots gaussian fits
gaus_plot1=plot(prec_dis,gaus_voltag1,'Color',[.5,0,.5]);
gaus_plot2=plot(prec_dis,gaus_voltag2,'Color',[0,.5,.5]);
gaus_plot3=plot(prec_dis,gaus_voltag3,'Color',[.5,.5,.5]);

%plots polynomial fit of cut data
post_gaus_plot1=plot(dis_prec1,pft_post_gaus1,'m');
post_gaus_plot2=plot(dis_prec2,pft_post_gaus2,'c');
post_gaus_plot3=plot(dis_prec3,pft_post_gaus3,'k');

%formatting
title('Polynomial fits to parts of data')
xlabel('Distance (mm)')
ylabel('Voltage (V)')
legend([pre_gaus_plot1,pre_gaus_plot2,pre_gaus_plot3,post_gaus_plot1,post_gaus_plot2,post_gaus_plot3,gaus_plot1,gaus_plot2,gaus_plot3],{'Unused1','Unused2','Unused3','Used1','Used2','Used3','Gausian1','Gausian2','Gausian3'})






%%%%%saves original_4th_poly,original_1st_gau,relevant_4th_poly,all_fig_combo










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if(iteration==1)
    %finds the distance value for which the voltage is maximized
    mx1=distanc1(find(voltag1==max(voltag1)));
    mx2=distanc2(find(voltag2==max(voltag2)));
    mx3=distanc3(find(voltag3==max(voltag3)));
    
    %sets gridsize parameters
    strt=min([mx1 mx2 mx3])-.5;
    stp=max([mx1 mx2 mx3])+.5;
    mest=5;
    stept=round((stp-strt)/.02,0);
    cont_loop=0;
    [cont_loop strt stp stept mest]
end


if(iteration==2)
    if(max([distance1' distance2' distance3'])==max([distanc1 distanc2 distanc3]))
        stp=max([distanc1 distanc2 distanc3])+.25;
    else
        stp=max([distance1' distance2' distance3'])+.05;   
    end
    
    if(min([distance1' distance2' distance3'])==min([distanc1 distanc2 distanc3]))
        strt=min([distanc1 distanc2 distanc3])-.25;
    else
        strt=min([distance1' distance2' distance3'])-.05;
    end
    
    mest=5;
    stept=round((stp-strt)/.01,0);
    cont_loop=0;
    [cont_loop strt stp stept mest]
end


if(iteration==3)
    if(max([distance1' distance2' distance3'])==max([distanc1 distanc2 distanc3]))
        stp=max([distanc1 distanc2 distanc3])+.1;
    else
        stp=max([distance1' distance2' distance3'])+.02;
    end
    
    if(min([distance1' distance2' distance3'])==min([distanc1 distanc2 distanc3]))
        strt=min([distanc1 distanc2 distanc3])-.1;
    else
        strt=min([distance1' distance2' distance3'])-.02
    end
    
    mest=10;
    stept=round((stp-strt)/.002,0);
    cont_loop=0;
    [cont_loop strt stp stept mest]
end

if(iteration==4||iteration==5)
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
%{
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
%}

    %creates histogram with formatting of the maxxs# values
    hist1=figure(5);
    hold on
    histogram(maxxs1)
    title('Histogram of  Measurement 1')
    xlabel('Distance (mm)')

%     hist2=figure(6);
%     hold on
%     histogram(maxxs2)
%     title('Histogram of  Measurement 2')
%     xlabel('Distance (mm)')
% 
%     hist3=figure(7);
%     hold on
%     histogram(maxxs3)
%     title('Histogram of  Measurement 3')
%     xlabel('Distance (mm)')

    %puts maxxs# in order from smallest to greates
    maxxs1=sort(maxxs1);
%     maxxs2=sort(maxxs2);
%     maxxs3=sort(maxxs3);

    %index number of how far to move from data center get 98% confidence
    num_pt=round(length(maxxs1)*.98/2,0);

    %finds bounds for confidence intervals
    lwbd1=maxxs1((times/2)-num_pt);
    hibd1=maxxs1((times/2)+num_pt);
%     lwbd2=maxxs2((times/2)-num_pt);
%     hibd2=maxxs2((times/2)+num_pt);
%     lwbd3=maxxs3((times/2)-num_pt);
%     hibd3=maxxs3((times/2)+num_pt);

    %width of the confidence intervals
    rng1=hibd1-lwbd1
%     rng2=hibd1-lwbd1;
%     rng3=hibd1-lwbd1;

    %finds the widest confidence interval
%    hi_rng=max([rng1 rng2 rng3]);
    hi_rng=max(rng1); %%%%% get rid of this
    %makes variable with confidence interval bounds, width, and most likely value 
    conf_int1=[lwbd1 hibd1 rng1 mode(maxxs1)];
%     conf_int2=[lwbd2 hibd2 rng2 mode(maxxs2)];
%     conf_int3=[lwbd3 hibd3 rng3 mode(maxxs3)];

    if(min(conf_int1)<.002)     %if(min([conf_int1 conf_int2 conf_int3])<.002) %CHANGE THIS VALUE ACCORDING TO PRECISION REQUIREMENTS
        strt=0
        stp=0
        mest=0;
        stept=0
        cont_loop=2;
        [cont_loop strt stp stept mest]
        %%%%%output how to shim
    else
        if(iteration==4)
            strt=min([distanc1 distanc2 distanc3])-.01
            stp=max([distanc1 distanc2 distanc3])+.01
            mest=10;
            stept=round((stp-strt)/.002,0);
            cont_loop=0;
            [cont_loop strt stp stept mest]
        end
        if(iteration==5)
            strt=0
            stp=0
            mest=0;
            stept=0
            cont_loop=1;
            [cont_loop strt stp stept mest]
        end
    end
    %%%%%save conf_int1,conf_int2,conf_int3
    %%%%%save hist1,hist2,hist3
end   
