
%OVERVIEW: This program takes the data from the agilent for the three
%photodiode channels and outputs an adaptive grid which the stepper moter
%and agelant will test over to get the precision of the peak intensity to
%be within a certain tolerance.

%input and outputs arguments
function [cont_loop, strt, stp, stept, mest,iteration] = complete_align(csv_dir,iteration,grating,type)
%polynomial fits are normally not ideal
warning('off','all');

%here data will be interpreted from its csv format

iteration=iteration+1;
data=csvread(csv_dir);

[h,l]=size(data);

%position of stage at time of measurement
distanc1=data(:,1)';
%distanc values will be the same for all 3 data sets
distanc2=distanc1;
distanc3=distanc1;

%sets up for loop
voltag1=zeros(1,(l-1)/3);
voltag2=voltag1;
voltag3=voltag1;
%averages multiple measurements for a single distance
for n=1:h
    voltag1(n)=mean(data(n,2:3:end));
    voltag2(n)=mean(data(n,3:3:end));
    voltag3(n)=mean(data(n,4:3:end));
end


%plots data and fits to data; cuts unneccessary data
original_4th_poly=figure(1);
hold on

%scatter plot of all data
scatter(distanc1,voltag1,'r')
scatter(distanc2,voltag2,'b')
scatter(distanc3,voltag3,'g')

%finds min and max distance values for plotting
min_dis=min(distanc1);
max_dis=max(distanc1);

%makes makes array of precise distance values that will be used for
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


%finds half max of gausian fit
bnd_gaus1=ft_gaus1.a1/2;
bnd_gaus2=ft_gaus2.a1/2;
bnd_gaus3=ft_gaus3.a1/2;

%cuts all data that isn't higher than half the height of the guassian fit
distance1=distanc1(voltag1>bnd_gaus1)';
voltage1=voltag1(voltag1>bnd_gaus1)';
distance2=distanc2(voltag2>bnd_gaus2)';
voltage2=voltag2(voltag2>bnd_gaus2)';
distance3=distanc3(voltag3>bnd_gaus3)';
voltage3=voltag3(voltag3>bnd_gaus3)';

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
legend([post_gaus_plot1,post_gaus_plot2,post_gaus_plot3],{'data1','data2','data3'})
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

%saves figures as pdfs
print(original_4th_poly,strrep(csv_dir,'data.csv','original_4th_poly'),'-dpdf')
print(original_1st_gaus,strrep(csv_dir,'data.csv','original_1st_gaus'),'-dpdf')
print(relevant_4th_poly,strrep(csv_dir,'data.csv','relevant_4th_poly'),'-dpdf')
print(all_fig_combo,strrep(csv_dir,'data.csv','all_fig_combo'),'-dpdf')


%ALL FOLLOWING DETERMINES THE ADAPTIVE GRID

if(iteration==1)
    %finds the distance value for which the voltage is maximized
    mx1=distanc1(voltag1==max(voltag1));
    mx2=distanc2(voltag2==max(voltag2));
    mx3=distanc3(voltag3==max(voltag3));
    
    %sets gridsize parameters
    strt=min([mx1 mx2 mx3])-.5;
    stp=max([mx1 mx2 mx3])+.5;
    mest=3;
    stept=round((stp-strt)/.02,0);
    cont_loop=0;
    %%%[cont_loop strt stp stept mest];
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
    %%%[cont_loop strt stp stept mest];
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
        strt=min([distance1' distance2' distance3'])-.02;
    end
    
    mest=10;
    stept=round((stp-strt)/.002,0);
    cont_loop=0;
    %%%[cont_loop strt stp stept mest];
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
    maxxs1=zeros(1,times);

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
        max1=prec_dis1(ft_vol1==max(ft_vol1));        
        %fills data variable with the distance value which maximizes the
        %polynomial fit to the radonly selected data
        maxxs1(tim)=max1(1);
    end

    tim=0;

    len2=length(voltage2);

    prec_dis2=min(distance2):.0001:max(distance2);

    maxxs2=zeros(1,times);

    while(tim<times)
        tim=tim+1;

        indexnew=datasample(1:len2,len2);
        bot_dis2=distance2(indexnew);
        bot_vol2=voltage2(indexnew);

        pft2=polyfit(bot_dis2,bot_vol2,4);
        ft_vol2=polyval(pft2,prec_dis2);
        
        max2=prec_dis2(ft_vol2==max(ft_vol2));
        
        maxxs2(tim)=max2(1);
    end

    tim=0;

    len3=length(voltage3);

    prec_dis3=min(distance3):.0001:max(distance3);

    maxxs3=zeros(1,times);


    while(tim<times)
        tim=tim+1;

        indexnew=datasample(1:len3,len3);
        bot_dis3=distance3(indexnew);
        bot_vol3=voltage3(indexnew);

        pft3=polyfit(bot_dis3,bot_vol3,4);
        ft_vol3=polyval(pft3,prec_dis3);
        
        max3=prec_dis3(ft_vol3==max(ft_vol3));
        
        maxxs3(tim)=max3(1);
    end


    %creates histograms with formatting of the maxxs# values
    hist1=figure(5);
    hold on
    histogram(maxxs1)
    title('Histogram of  Measurement 1')
    xlabel('Distance (mm)')

    hist2=figure(6);
    hold on
    histogram(maxxs2)
    title('Histogram of  Measurement 2')
    xlabel('Distance (mm)')

    hist3=figure(7);
    hold on
    histogram(maxxs3)
    title('Histogram of  Measurement 3')
    xlabel('Distance (mm)')
    
    print(hist1,strrep(csv_dir,'data.csv','hist1'),'-dpdf')
    print(hist2,strrep(csv_dir,'data.csv','hist2'),'-dpdf')
    print(hist3,strrep(csv_dir,'data.csv','hist3'),'-dpdf')

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
    rng1=(hibd1-lwbd1)*1000;
    rng2=(hibd2-lwbd2)*1000;
    rng3=(hibd3-lwbd3)*1000;

    %finds the widest confidence interval
    hi_rng=max([rng1 rng2 rng3]/1000);

    if(hi_rng<.001) %CHANGE THIS VALUE ACCORDING TO PRECISION REQUIREMENTS
        strt=0;
        stp=0;
        mest=0;
        stept=0;
        cont_loop=2;
        
        %find file path for image
        alfg=strrep(csv_dir,'data.csv','all_fig_combo.pdf');
        alfg=alfg(3:end);
        alfg=strcat('/home/krg/ESIS_VisEUV_transfer_sw',alfg)
        
        %output pdf test report
        variableList = {type num2str(grating) num2str(mode(maxxs1)) num2str(rng1) num2str(mode(maxxs2)) num2str(rng2) num2str(mode(maxxs3)) num2str(rng3) num2str(iteration) num2str((l-1)/3) num2str(h) alfg};

        line1 = cellstr(['{\scshape\large Grating Type:',variableList{1},' \par}']);
        line2 = cellstr(['{\scshape\large Grating Number:' variableList{2} ' \par}']);
        line3 = cellstr(['\indent...for channel 1 lies at ' variableList{3} ' mm to a precision of ' variableList{4} ' microns.\\']);
        line4 = cellstr(['\indent...for channel 2 lies at ' variableList{5} ' mm to a precision of ' variableList{6} ' microns.\\']);
        line5 = cellstr(['\indent...for channel 3 lies at ' variableList{7} ' mm to a precision of ' variableList{8} ' microns.\\']);
        line6 = cellstr(['\indent...after ' variableList{9} ' intensity scans.\\']);
        line7 = cellstr(['\indent...with ' variableList{10} ' measurements taken at each distance.\\']);
        line8 = cellstr(['\indent...with data from ' variableList{11} ' distances.\\']);
        %change this
        line9 = cellstr(['\includegraphics[height=.5\textheight, trim={4cm 8.5cm 4cm 8.5cm},clip]{' variableList{12} '}\\']);


        str = ['\documentclass[12pt,a4paper]{article}'
               '\usepackage{datetime}'
               '\usepackage{ragged2e}'
               '\usepackage{graphicx}'
               '\usepackage{subcaption}'
               '\usepackage{mwe}'
               '\usepackage{float}'
               '\pagenumbering{gobble}'
               ''
               '\begin{document}'
               ''
               '\begin{center}'
               '{\scshape\LARGE VIS-EUV Test Report \par}'
               '{\scshape\Large \today, \currenttime \par}'
               '\bigskip'
               line1
               line2
               '\end{center}'
               ''
               '\noindent We are 98\% confident that the peak intensity...\\'
               line3
               line4
               line5
               ''
               '\noindent The final model was created...\\'
               line6
               line7
               line8
               ''
               '\begin{figure}[H]'
               '\centering'
               line9
               '\end{figure}'
               ''
               '\end{document}'];

        pth=csv_dir(1:end-31);
        pth=strcat(pth,'reports/Test_Report.tex');
        
        fileID = fopen(pth,'w');   %open the blank report file
        formatSpec = '%s\r\n';  %specify the data type being output through fprintf
        [nRows,~] = size(str);  %tell matlab the size of the file

        for row = 1:nRows   
            fprintf(fileID,formatSpec,str{row,:});      %print the data onto the file
        end

        fclose(fileID); %close the finished file
        
        cd (pth(1:end-15))
        system('pdflatex Test_Report.tex')
        system('sudo xdg-open Test_Report.pdf')



    else
        if(iteration==4)
            strt=min([distanc1 distanc2 distanc3])-.01;
            stp=max([distanc1 distanc2 distanc3])+.01;
            mest=10;
            stept=round((stp-strt)/.002,0);
            cont_loop=0;
            %%%[cont_loop strt stp stept mest]
        end
        if(iteration==5)
            strt=0;
            stp=0;
            mest=0;
            stept=0;
            cont_loop=1;
            %%%[cont_loop strt stp stept mest]
        end
    end
end   
end