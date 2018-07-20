
%OVERVIEW: This program takes the data from the agilent for one
%photodiode channel and outputs and creates an adaptive grid which the stepper moter
%and agelant will test over to get the precision of the peak intensity to
%be within a certain tolerance.

%input and outputs arguments
function [cont_loop strt stp stept mest iteration] = complete_align_single_looper(csv_dir,iteration,grating,type)

warning('off','all');

%here data will be interpreted from its csv format
close all

iteration=iteration+1;
data=csvread(csv_dir);

d=data(:,1);
v=data(:,2);

strt=min(d);
stp=max(d);

stps=round((max(d)-min(d))/.002)+1;     %number of position measurements in a single scan
lps=round(length(d)/(stps-1));          %number of scans

%loop prep
ds=zeros(stps,lps);
vs=zeros(stps,lps);
%takes the distance vs voltage data array and creates a matrix of similar
%distance measurements to be averaged together later, and a matrix of
%voltage measurements made at identical positions to be boostrapped later
for i=1:lps
    ds(:,i)=d(((i-1)*stps+1):(i*stps));
    vs(:,i)=v(((i-1)*stps+1):(i*stps));
end

[h,~]=size(ds);

dav=zeros(1,h);
vav=zeros(1,h);
for n=1:h
    dav(n)=mean(ds(n,:));
    vav(n)=mean(vs(n,:));
end


%finds min and max distance values for plotting
min_dis=min(d);
max_dis=max(d);

%makes makes array of precise distance values that will be used for
%fit
prec_dis=min_dis:.0001:max_dis;

%does a 4th degree polynomial fit to data
pft1=polyfit(d,v,4);
pft_pre_avg=polyval(pft1,prec_dis);

pft2=polyfit(dav,vav,4);
pft_post_avg=polyval(pft2,prec_dis);

all_fig_combo=figure();
hold on
scatter(d,v)
scatter(dav,vav)
plot(prec_dis,pft_pre_avg)
plot(prec_dis,pft_post_avg)
xlabel('Distance (mm)')
ylabel('Voltage (V)')
title('All data with fits')
legend('All Data','Averaged Data','Polyfit of All Data','Polyfit of Averaged Data')


print(all_fig_combo,strrep(csv_dir,'data.csv','all_fig_combo'),'-dpdf')



%ALL FOLLOWING DETERMINES THE ADAPTIVE GRID
if(iteration==1)
    %finds the distance value for which the voltage is maximized
    mx=dav(vav==max(vav));
    
    %sets gridsize parameters
    strt=mx-1;
    stp=mx+1;
    mest=20;
    stept=round((stp-strt)/.002,0);
    cont_loop=0;
end


if(iteration==2||iteration==3)
    n=0;
    [~,len]=size(vs);
    vbot=zeros(1,lps);
    tms=1000;  %how many times to run through while loop
    mxxs=zeros(1,tms);
    while n<tms

        if rem(5*n,tms)==0;
            sprintf('%g%%',round(100*n/tms))
        end

        n=n+1;
        %sample with replacement
        for i=1:h
            vbot(i)=mean(datasample(vs(i,:),lps));
        end

        %polynomial fit with max finding of bootstrapped data
        pdis=min(dav):.0001:max(dav);
        pft=polyfit(dav,vbot,4);
        ft=polyval(pft,pdis);
        mx=pdis(ft==max(ft));        
        mxxs(n)=mx(1);

    end


    %creates histograms with formatting of the maxxs# values
    hist1=figure(2);

    hold on
    histogram(mxxs)
    title('Histogram of  Bootstrapped Maxes')
    xlabel('Distance (mm)')
    print(hist1,strrep(csv_dir,'data.csv','hist1'),'-dpdf')

    %puts maxxs# in order from smallest to greates
    mxxs=sort(mxxs);

    %index number of how far to move from data center get 98% confidence
    num_pt=round(length(mxxs)*.98/2,0);

    %finds bounds for confidence intervals
    lwbd1=mxxs((tms/2)-num_pt);
    hibd1=mxxs((tms/2)+num_pt);

    %width of the confidence intervals
    rng1=(hibd1-lwbd1)*1000;

    %finds the widest confidence interval
    hi_rng=max(rng1/1000);

    %if(hi_rng<.001) %CHANGE THIS VALUE ACCORDING TO PRECISION REQUIREMENTS
        
    if hi_rng<=15.3
        pf='Passed';
    else
        pf='Failed';
    end

    %find file path for image
    alfg=strrep(csv_dir,'data.csv','all_fig_combo.pdf');

    %output pdf test report
    variableList = {type num2str(grating) num2str(mode(mxxs)) num2str(rng1) num2str(iteration) num2str(lps) num2str(stps) alfg pf};

    line0 = cellstr(['{\textbf{Test ',variableList{9},'} \par}']);
    line1 = cellstr(['{\scshape\large Grating Type:',variableList{1},' \par}']);
    line2 = cellstr(['{\scshape\large Grating Number:' variableList{2} ' \par}']);
    line3 = cellstr(['\indent...for channel 1 lies at ' variableList{3} ' mm to a precision of ' variableList{4} ' microns with a target of 15.3 micron.\\']);
    line6 = cellstr(['\indent...after ' variableList{5} ' intensity scans.\\']);
    line7 = cellstr(['\indent...with ' variableList{6} ' measurements taken at each distance.\\']);
    line8 = cellstr(['\indent...with data from ' variableList{7} ' distances.\\']);
    line9 = cellstr(['\includegraphics[height=.5\textheight, trim={4cm 8.5cm 4cm 8.5cm},clip]{' variableList{8} '}\\']);


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
           '\bigskip'
           line0
           '\end{center}'
           ''
           '\noindent We are 98\% confident that the peak intensity...\\'
           line3
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

    pth=csv_dir(1:end-20);
    pthfol=strcat(pth,'reports');
    pth=strcat(pth,'reports/Test_Report.tex');

    formatSpec = '%s\r\n';  %specify the data type being output through fprintf
    [nRows,~] = size(str);  %tell matlab the size of the file
    mkdir(pthfol);
    fileID = fopen(pth,'wt');   %open the blank report file

    for row = 1:nRows   
        fprintf(fileID,formatSpec,str{row,:});      %print the data onto the file
    end

    fclose(fileID); %close the finished file
    cd (pth(1:end-15));
    system('pdflatex Test_Report.tex > /dev/null 2>&1');
    system('xdg-open Test_Report.pdf');


    if(iteration==2)
        strt=mode(mxxs)-1.1;
        stp=mode(mxxs)+1.1;
        mest=30;
        stept=round((stp-strt)/.002,0);
        cont_loop=0;
    end
    if(iteration==3)
        strt=0;
        stp=0;
        mest=0;
        stept=0;
        cont_loop=1;
    end
end

if(strt<.5)
    strt=.5;
end
if(stp>11.5)
    stp=11.5;
end

end