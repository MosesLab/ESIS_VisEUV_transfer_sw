

%OVERVIEW: This program takes the data from the agilent for three
%photodiode channels and outputs an adaptive grid which the stepper moter
%and agelant will test over to get the precision of the peak intensity to
%be within a certain tolerance. A test report will be generated after
%sufficient certanty in measurements is made.


% the following tripple commented lines are to be used for testing purposes
% by creating a simulated data matrix

% clear all
% close all




%input and outputs arguments
function [cont_loop, strt, stp, stept, mest,iteration] = TEA_GSE_Final_Align(csv_dir,iteration,grating,type)

% csv_dir='/home/krg/Transfer_ESIS_Alignment_GSE/control_software/Output/VIS/grating_1/20180416-115705/iterations/iteration_1/data.csv';
% iteration=1;
% grating=1;
% type='VIS';

%polynomial fits are normally not ideal
warning('off','all');

%data will be interpreted from its csv format
iteration=iteration+1;
data=csvread(csv_dir);

%stage location at measurement
d=data(:,1);
v1=data(:,2);
v2=data(:,3);
v3=data(:,4);

strt=round(min(d),3);
stp=round(max(d),3);
stps=round((stp-strt)/round(d(2)-d(1),3))+1
lps=round(length(d)/(stps-1));

%loop prep
zerlps=zeros(stps,lps);
ds=zerlps;
vs1=zerlps;
vs2=zerlps;
vs3=zerlps;
%takes the distance vs voltage data array and creates a matrix of simaler
%distance measurements to be averaged together later,and matracies of
%voltage measurements made at identical position to be bootstrapped later

for i=1:lps
    ds(:,i)=d(((i-1)*stps+1):(i*stps));
    vs1(:,i)=v1(((i-1)*stps+1):(i*stps));
    vs2(:,i)=v2(((i-1)*stps+1):(i*stps));
    vs3(:,i)=v3(((i-1)*stps+1):(i*stps));
end

[h,~]=size(vs1);

%loop prep
zerstp=zeros(1,stps);
dav=zerstp;
vav1=zerstp;
vav2=zerstp;
vav3=zerstp;
%finds the average voltage for a given distance
for n=1:stps
    dav(n)=mean(ds(n,:));
    vav1(n)=mean(vs1(n,:));
    vav2(n)=mean(vs2(n,:));
    vav3(n)=mean(vs3(n,:));
end

%does a 4th order polynomial fit to all data
pd=min(d):.0001:max(d);

p1=polyfit(d,v1,4);
p2=polyfit(d,v2,4);
p3=polyfit(d,v3,4);

pruf1=polyval(p1,pd);
pruf2=polyval(p2,pd);
pruf3=polyval(p3,pd);

%finds over which data range to base fit
off1=1.5;
off2=1.75;
off3=2;

%does a polynomial fit over relavent data. The higher the iteration number,
%the wider the range over which is fit
if iteration==1
    pd1=(dav(vav1==max(vav1))-off1):.0001:(dav(vav1==max(vav1))+off1);
    pd2=(dav(vav2==max(vav2))-off1):.0001:(dav(vav2==max(vav2))+off1);
    pd3=(dav(vav3==max(vav3))-off1):.0001:(dav(vav3==max(vav3))+off1);
end
if iteration==2
    pd1=(dav(vav1==max(vav1))-off2):.0001:(dav(vav1==max(vav1))+off2);
    pd2=(dav(vav2==max(vav2))-off2):.0001:(dav(vav2==max(vav2))+off2);
    pd3=(dav(vav3==max(vav3))-off2):.0001:(dav(vav3==max(vav3))+off2);
end
if iteration==3
    pd1=(dav(vav1==max(vav1))-off3):.0001:(dav(vav1==max(vav1))+off3);
    pd2=(dav(vav2==max(vav2))-off3):.0001:(dav(vav2==max(vav2))+off3);
    pd3=(dav(vav3==max(vav3))-off3):.0001:(dav(vav3==max(vav3))+off3);
end

drel1=dav(dav>=min(pd1) & dav<=max(pd1));
drel2=dav(dav>=min(pd2) & dav<=max(pd2));
drel3=dav(dav>=min(pd3) & dav<=max(pd3));
vrel1=vav1(dav>=min(pd1) & dav<=max(pd1));
vrel2=vav2(dav>=min(pd2) & dav<=max(pd2));
vrel3=vav3(dav>=min(pd3) & dav<=max(pd3));

pav1=polyfit(drel1,vrel1,4);
pav2=polyfit(drel2,vrel2,4);
pav3=polyfit(drel3,vrel3,4);

pavd1=polyval(pav1,pd1);
pavd2=polyval(pav2,pd2);
pavd3=polyval(pav3,pd3);

%plots all data with fits
all_fig_combo=figure(1);
hold on
p1=scatter(d,v1,'r','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.05);
p2=scatter(d,v2,'b','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.05);
p3=scatter(d,v3,'g','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.05);
p4=scatter(dav,vav1,'m','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.1);
p5=scatter(dav,vav2,'c','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.1);
p6=scatter(dav,vav3,'k','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',0.1);
p7=plot(pd,pruf1,'r');
p8=plot(pd,pruf2,'b');
p9=plot(pd,pruf3,'g');
p10=plot(pd1,pavd1,'m');
p11=plot(pd2,pavd2,'c');
p12=plot(pd3,pavd3,'k');
legend([p7 p8 p9 p10 p11 p12],{'All Data 1','All Data 2','All Data 3','Averaged Data 1','Averaged Data 2','Averaged Data 3'}) 
ylim([0 (max(max([v1 v2 v3]))+.5)])
xlabel('Distance (mm)')
ylabel('Voltage (V)')
title('Data and Averaged Data with Fits')

%saves as png. pdf would be preferable, but file is too large it crashes
%computer
print(all_fig_combo,strrep(csv_dir,'data.csv','all_fig_combo'),'-dpng')

%finds peak of data
dmv1=dav(vav1==max(vav1));
dmv2=dav(vav2==max(vav2));
dmv3=dav(vav3==max(vav3));

%adaptive grid for 2nd run through
if iteration==1
    strt=min([dmv1 dmv2 dmv3])-off1;
    stp=max([dmv1 dmv2 dmv3])+off1;
    mest=10;
    stept=round((stp-strt)/.002);
    cont_loop=0;
end

%adaptive grid for 3rd run through. stops if 4th run through. outputs pdf
%test report.
iteration
if iteration==2 ||iteration==3
    %loop prep
    times=1000;
    tim=0;
    mxxs1=zeros(1,times);
    mxxs2=zeros(1,times);
    mxxs3=zeros(1,times);
    vbot1=zeros(1,lps);
    vbot2=zeros(1,lps);
    vbot3=zeros(1,lps);

    while(tim<times)
        
        %display progress through loop
        if rem(10*tim,times)==0
            sprintf('%g%%',round(100*tim/times))
        end
        tim=tim+1;
        
        %samples with replacement from measurements at every distance
        for i=1:h
            vbot1(i)=mean(datasample(vs1(i,:),lps));
            vbot2(i)=mean(datasample(vs2(i,:),lps));
            vbot3(i)=mean(datasample(vs3(i,:),lps));
        end
        
        %does polynomaial fit to boostrapped data
        pbot1=polyfit(dav,vbot1,4);
        pbot2=polyfit(dav,vbot2,4);
        pbot3=polyfit(dav,vbot3,4);
        ft1=polyval(pbot1,pd1);
        ft2=polyval(pbot2,pd2);
        ft3=polyval(pbot3,pd3);
        mx1=pd1(ft1==max(ft1));
        mx2=pd2(ft2==max(ft2));
        mx3=pd1(ft3==max(ft3));
        %find max for bootstrapped data
        mxxs1(tim)=mx1(1);
        mxxs2(tim)=mx2(1);
        mxxs3(tim)=mx3(1);
    end
    
    %creates a confidence interval
    mxxs1=sort(mxxs1);
    mxxs2=sort(mxxs2);
    mxxs3=sort(mxxs3);
        
    num_pt=round(times*.98/2,0);
   
    lwbd1=mxxs1(times/2-num_pt);
    lwbd2=mxxs2(times/2-num_pt);
    lwbd3=mxxs3(times/2-num_pt);
    hibd1=mxxs1(times/2+num_pt);
    hibd2=mxxs2(times/2+num_pt);
    hibd3=mxxs3(times/2+num_pt);
    
    %plots histograms with 98% confidence intervals
    hist1=figure();
    hold on
    hist(mxxs1,times/10)
    line([lwbd1 lwbd1],ylim,'Color','r');
    line([hibd1 hibd1],ylim,'Color','r');
    hist2=figure();
    hold on
    hist(mxxs2,times/10)
    line([lwbd2 lwbd2],ylim,'Color','r');
    line([hibd2 hibd2],ylim,'Color','r');
    hist3=figure();
    hold on
    hist(mxxs3,times/10)
    line([lwbd3 lwbd3],ylim,'Color','r');
    line([hibd3 hibd3],ylim,'Color','r');
    
    %convert to micron
    rng1=(hibd1-lwbd1)*1000;
    rng2=(hibd2-lwbd2)*1000;
    rng3=(hibd3-lwbd3)*1000;
    
    %largest confidence interval
    hi_rng=max([rng1 rng2 rng3]);
    
    %change according to resolution buget. adaptive grid for 3rd run
    %through.
    if hi_rng<=15.3
        pf='Passed';
        strt=min([dmv1 dmv2 dmv3])-off2;
        stp=max([dmv1 dmv2 dmv3])+off2;
        mest=30;
        stept=round((stp-strt)/.002);
        cont_loop=0;
    else
        pf='Failed';
        strt=0;
        stp=0;
        mest=0;
        stept=0;
        cont_loop=2;
    end
    
    %saves histograms. pdf would be better
    print(hist1,strrep(csv_dir,'data.csv','Histogram 1'),'-dpng')
    print(hist2,strrep(csv_dir,'data.csv','Histogram 2'),'-dpng')
    print(hist3,strrep(csv_dir,'data.csv','Histogram 3'),'-dpng')
    
    %begin formatting for pdf output
    %all fig combo file location
    alfg=strrep(csv_dir,'data.csv','all_fig_combo.png');
    %variables from script to be used in test report
    variableList={type num2str(grating) num2str(mode(mxxs1)) num2str(rng1) num2str(mode(mxxs2)) num2str(rng2) num2str(mode(mxxs3)) num2str(rng3) num2str(iteration) num2str(lps) num2str(stps) alfg pf};
    
    %tex lines with script inputs
    line0 = cellstr(['{\textbf{Test ',variableList{13},'} \par}']);
    line1 = cellstr(['{\scshape\large Grating Type:',variableList{1},' \par}']);
    line2 = cellstr(['{\scshape\large Grating Number:' variableList{2} ' \par}']);
    line3 = cellstr(['\indent...for channel 1 lies at ' variableList{3} ' mm to a precision of ' variableList{4} ' microns.\\']);
    line4 = cellstr(['\indent...for channel 2 lies at ' variableList{5} ' mm to a precision of ' variableList{6} ' microns.\\']);
    line5 = cellstr(['\indent...for channel 3 lies at ' variableList{7} ' mm to a precision of ' variableList{8} ' microns.\\']);
    line6 = cellstr(['\indent...after ' variableList{9} ' intensity scans.\\']);
    line7 = cellstr(['\indent...with ' variableList{10} ' measurements taken at each distance.\\']);
    line8 = cellstr(['\indent...with data from ' variableList{11} ' distances.\\']);
    line9 = cellstr(['\includegraphics[]{' variableList{12} '}\\']);
    
    %entire tex file
    str = ['\documentclass[12pt,a4paper]{article}'
           '\usepackage{datetime}'
           '\usepackage{ragged2e}'
           '\usepackage{graphicx}'
           '\usepackage{subcaption}'
           '\usepackage{mwe}'
           '\usepackage{float}'
           '\usepackage{grffile}'
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
           '\bigskip'
           line0
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
        
    %file path of tex document
    pth=csv_dir(1:end-20);
    pthfol=strcat(pth,'reports');
    pth=strcat(pth,'reports/Test_Report.tex');

    %prepare file for tex report
    formatSpec = '%s\r\n';  %specify the data type being output through fprintf
    [nRows,~] = size(str);  %tell matlab the size of the file
    mkdir(pthfol);
    fileID = fopen(pth,'wt');   %open the blank report file
    
    %writes tex file line by line
    for row = 1:nRows   
        fprintf(fileID,formatSpec,str{row,:});      %print the data onto the file
    end
    
    fclose(fileID); %close the finished file
    cd (pth(1:end-15));
    
    %compile and open latex pdf document
    system('pdflatex Test_Report.tex > /dev/null 2>&1');
    system('xdg-open Test_Report.pdf');
    
end
